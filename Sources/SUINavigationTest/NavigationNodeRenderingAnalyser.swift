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

    var cancellention: Cancellable? = nil

    public init() { }

    fileprivate func searchChildNodes<V: View>(view: V, parent: NavigationNode, id: String, navStorage: NavigationStorage, isRecursive: Bool, children: [String: NavigateUrlParamsHandler])
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
        let waiter = XCTWaiter()

        cancellention = navStorage.$pathItems.sink { items in
            print("bingo add \(items)")
            if items.count > startItemsCount, let lastItem = items.last, lastItem.id == id {
                available = .trigger
                childItem = lastItem
                expectationAddItem.fulfill()
            }
        }

        children[id]!(actionPathTester)

        waiter.wait(for: [expectationAddItem], timeout: 0.3)

        let node = NavigationNode(id: id, params: actionPathTester.params, available: available, attributes: attributes)
        if let childItem {
            node.viewType = childItem.viewType
        }
        parent.addChild(node)
        if let childItem, isRecursive == true, node.isRecursiveLoopDetected == false {
            let expectationChildren = XCTestExpectation(description: "children")

            var children: [String: NavigateUrlParamsHandler] = [:]

            cancellention = childItem.$children
                .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
                .sink { items in
                    children = items
                    expectationChildren.fulfill()
            }

            view.render()

            waiter.wait(for: [expectationChildren], timeout: 0.3)

            for id in children.keys.sorted() {
                searchChildNodes(view: view, parent: node, id: id, navStorage: navStorage, isRecursive: isRecursive, children: children)
            }
        }

        if node.isAvailable {

            let expectationRemove = XCTestExpectation(description: "remove")

            cancellention = navStorage.$pathItems.sink { data in
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
    }

    func searchNodes<V: View>(for parent: NavigationNode, view: V, isRecursive: Bool = false) {

        let waiter = XCTWaiter()
        let expectationRootChildren = XCTestExpectation(description: "rootChildren")
        var navStorage: NavigationStorage = NavigationStorage()

        var rootChildren: [String: NavigateUrlParamsHandler] = [:]

        cancellention = navStorage.$rootChildren
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { items in
                rootChildren = items
                print("Found root children: \(rootChildren.count)")
                expectationRootChildren.fulfill()
        }

        let destinationView =
            NavigationViewStorage(navigationStorage: navStorage) {
                view
            }

        destinationView.render()

        waiter.wait(for: [expectationRootChildren], timeout: 0.3)

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
