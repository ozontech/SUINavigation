//
//  NavigationNodeRenderingAnalyser.swift
//
//
//  Created by Sergey Balalaev on 20.12.2023.
//

import SwiftUI
import SUINavigation
import Combine
import XCTest

// need add id douplication checking
public final class NavigationNodeRenderingAnalyser : NavigationNodeAnalyserProtocol {

    public init() { }

    var cancellention: Cancellable? = nil

    fileprivate func searchChildNodes<V: View>(view: V, parent: NavigationNode, id: String, navStorage: NavigationStorage, isRecursive: Bool, children: [String: NavigationStorage.Child])
    {
        let actionPathTester = NavigationActionPathTester()
        var available = NavigationNodeAvailable.none
        // this method available for deeplinked nodes
        var attributes: [NavigationNodeAttribute] = [.deeplink]
        if parent.isIdExists(with: id) {
            attributes.append(.recursiveLoopDetected)
        }

        var childItem: NavigationStorage.Item? = nil
        let startItemsCount = navStorage.pathItems.count

        let expectationAddItem = XCTestExpectation(description: "addItem")
        let expectationNewView = XCTestExpectation(description: "newView")
        let waiter = XCTWaiter()

        cancellention = navStorage.$pathItems.sink { items in
            print("bingo add \(items)")
            if items.count > startItemsCount, let lastItem = items.last, lastItem.id == id {
                available = .trigger
                childItem = lastItem
                expectationAddItem.fulfill()
            }
        }

        var newView: (any View)? = nil

        NavigationCatch.shared.catchAnyView(mode: .rendering) { view in
            print("New view")
            if newView == nil {
                newView = view
                expectationNewView.fulfill()
            }
        }

        let transitionTrigger = children[id]!.load
        transitionTrigger(actionPathTester)

        waiter.wait(for: [expectationAddItem, expectationNewView], timeout: 0.3)

        NavigationCatch.shared.clean()

        let node = NavigationNode(id: id, params: actionPathTester.params, available: available, attributes: attributes)
        if let childItem {
            node.viewType = childItem.viewType
        }
        parent.addChild(node)

        // to revert to start position
        if node.isAvailable {
            let expectationRemove = XCTestExpectation(description: "remove")

            cancellention = navStorage.$pathItems
                .sink
            { data in
                print("complite \(data)")
            } receiveValue: { items in
                if items.count == startItemsCount {
                    print("bingo remove \(items)")
                    expectationRemove.fulfill()
                }
            }

            navStorage.pop()

            waiter.wait(for: [expectationRemove], timeout: 0.3)
        }

        // from start position try to analyze chields
        if let childItem, isRecursive == true, node.isRecursiveLoopDetected == false {
            if let newView {
                searchNodes(for: node, view: newView, isRecursive: isRecursive)
            }
        }
    }

    func searchNodes<V: View>(for parent: NavigationNode, view: V, isRecursive: Bool = false) {

        let waiter = XCTWaiter()
        let expectationRootChildren = XCTestExpectation(description: "rootChildren")
        var navStorage: NavigationStorage = NavigationStorage()

        var rootChildren: [String: NavigationStorage.Child] = [:]

        navStorage.$rootChildren.catchDidChange(delay: 0.1) { items in
            rootChildren = items
            print("Found root children: \(rootChildren.count)")
            expectationRootChildren.fulfill()
        }

        let destinationView =
            NavigationStorageView(navigationStorage: navStorage) {
                view
            }

        destinationView.render()

        waiter.wait(for: [expectationRootChildren], timeout: 0.3)

        navStorage.$rootChildren.clean()

        for id in rootChildren.keys.sorted() {
            searchChildNodes(view: view, parent: parent, id: id, navStorage: navStorage, isRecursive: isRecursive, children: rootChildren)
        }
    }

    // return root node
    public func searchNodes<V: View>(for rootView: V, isRecursive: Bool = false) -> NavigationNode {
        let rootNode = NavigationNode.createRoot()
        searchNodes(for: rootNode, view: rootView, isRecursive: isRecursive)
        rootNode.viewType = rootView.navigationID.stringValue
        return rootNode
    }

}
