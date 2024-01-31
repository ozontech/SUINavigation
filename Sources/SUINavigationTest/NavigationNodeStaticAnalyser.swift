//
//  NavigationNodeStaticAnalyser.swift
//
//
//  Created by Sergey Balalaev on 29.12.2023.
//

import SwiftUI
import SUINavigation

public final class NavigationNodeStaticAnalyser : NavigationNodeAnalyserProtocol {

    private(set) var failureResult: String = ""
    private(set) var failuresCount: Int = 0

    private let mock: NavigationMockStore?

    public init(mock: NavigationMockStore? = nil) { 
        self.mock = mock
    }

    private func processing<V: View>(_ view: V, _ parent: NavigationNode) {
        do {
            // Yes, the compiler may miss everything type
            // It can Never, Environments etc, we research how it handle too, now only optional
            if let view = view as? Optional<any View> {
                // Possible check to nil and make warning in a future.
                _ = view?.body
            } else {
                _ = view.body
            }
        } catch let error {
            self.failuresCount += 1
            self.failureResult += "\(self.failuresCount). From \(parent.name) node can not analyse '\(view.navigationID.stringValue)' view. Catch error: '\(error.localizedDescription)'.\n"
        }
    }
    
    private func searchNodes<V: View>(for parent: NavigationNode, view: V, isRecursive: Bool = false) {

        NavigationCatch.shared.clean()

        NavigationCatch.shared.catchUrlParamsHandler = {[weak self] urlComponent, action in
            let actionPathTester = NavigationActionPathTester()
            action(actionPathTester)
            var attributes: [NavigationNodeAttribute] = [.deeplink]
            if parent.isIdExists(with: urlComponent) {
                attributes.append(.recursiveLoopDetected)
            }
            let child = NavigationNode(id: urlComponent, params: actionPathTester.params, available: .none, attributes: attributes)
            // checking duplicated id
            if let other = parent.children.first(where: { $0.id == child.id}) {
                guard let self else { return }
                self.failuresCount += 1
                self.failureResult += "\(self.failuresCount). The \(parent.name) node has two or more using of deeplink mapping (.navigateUrlParams) with the same id: '\(child.id)' with views: '\(child.viewType)', '\(other.viewType)'.\n"
            }
            parent.addChild(child)
        }

        processing(view, parent)

        NavigationCatch.shared.clean()

        // is Available checking
        // with unexpected id

        var availableChildren: [(node: NavigationNode, view: any View)] = []

        NavigationCatch.shared.catchIdAnyView(mock: mock) {[weak self] id, view, available in
            var isFound: Bool = false
            // checking duplicated id
            if let other = availableChildren.first(where: { $0.node.id == id}) {
                guard let self else { return }
                self.failuresCount += 1
                self.failureResult += "\(self.failuresCount). The \(parent.name) node has two or more using of navigate transition (.navigation) with the same id: '\(id)' with views: '\(view.navigationID.stringValue)', '\(other.node.viewType)'.\n"
            } else {
                for node in parent.children {
                    if node.id == id {
                        node.available = available
                        node.viewType = view.navigationID.stringValue
                        availableChildren.append((node, view))
                        isFound = true
                        break
                    }
                }
            }

            if !isFound {
                // found not deeplinked
                var attributes: [NavigationNodeAttribute] = []
                if parent.isIdExists(with: id) {
                    attributes.append(.recursiveLoopDetected)
                }
                let node = NavigationNode(id: id, available: available, attributes: attributes)
                node.viewType = view.navigationID.stringValue
                parent.addChild(node)
                availableChildren.append((node, view))
            }
        }
        
        processing(view, parent)

        NavigationCatch.shared.clean()

        if isRecursive {
            for item in availableChildren {
                if item.node.isRecursiveLoopDetected == false {
                    searchNodes(for: item.node, view: item.view, isRecursive: isRecursive)
                }
            }
        }
    }

    // return root node
    public func searchNodes<V: View>(for rootView: V, isRecursive: Bool = false) -> NavigationNode {
        let rootNode = NavigationNode.createRoot()
        failuresCount = 0
        failureResult = ""
        searchNodes(for: rootNode, view: rootView, isRecursive: isRecursive)
        rootNode.viewType = rootView.navigationID.stringValue
        return rootNode
    }

}
