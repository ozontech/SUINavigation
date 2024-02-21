//
//  NodesTests.swift
//  NavigationExampleTests
//
//  Created by Sergey Balalaev on 20.12.2023.
//

import XCTest
@testable import NavigationExample
import SwiftUI
import SUINavigationTest
import SUINavigation
import Combine

final class NodesTests: XCTestCase {

    let mock = NavigationMockStore (
        items: [
            "Test",
            Int(0),
            Date(),
            PerformLoad.empty
        ],
        views: [
            BoolView()
        ]
    )

    func testSnapshot() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)
        try assertSnapshot(rootView, mock: mock)
    }

    func testItemsSnapshot() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)
        try assertItemsSnapshot(rootView, mock: mock, hasDuplicationChecking: false)
    }

    func testAllNodesTreeFromRoot() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)

        let rootNode = rootNode(for: rootView, mock: mock, isRecursive: true)

        XCTAssertEqual(rootNode.children.count, 4)
        guard rootNode.children.count == 4 else {
            return
        }
        let rootChildren = rootNode.children.sorted { $0 < $1 }

        let boolNode = rootChildren[0]
        let firstNode = rootChildren[1]
        let _ = rootChildren[2] // performanceNode
        let secondNode = rootChildren[3]

        XCTAssertEqual(boolNode.id, "BoolView")
        XCTAssertEqual(boolNode.viewType, "BoolView")
        XCTAssertTrue(boolNode.isAvailable)
        XCTAssertTrue(boolNode.isDeeplinkSupport)
        XCTAssertFalse(boolNode.isRecursiveLoopDetected)
        XCTAssertEqual(boolNode.children.count, 4)

        XCTAssertEqual(firstNode.id, "FirstView")
        XCTAssertEqual(firstNode.viewType, "FirstView")
        XCTAssertTrue(firstNode.isAvailable)
        XCTAssertFalse(firstNode.isDeeplinkSupport)
        XCTAssertFalse(firstNode.isRecursiveLoopDetected)
        XCTAssertEqual(firstNode.children.count, 4)

        XCTAssertEqual(secondNode.id, "SecondView")
        XCTAssertEqual(secondNode.viewType, "SecondView")
        XCTAssertTrue(secondNode.isAvailable)
        XCTAssertTrue(secondNode.isDeeplinkSupport)
        XCTAssertFalse(secondNode.isRecursiveLoopDetected)
        XCTAssertEqual(secondNode.children.count, 1)

        guard secondNode.children.count == 1 else {
            return
        }
        let secondBoolNode = secondNode.children[0]
        XCTAssertEqual(secondBoolNode.id, "BoolView")
        XCTAssertEqual(secondBoolNode.viewType, "BoolView")
        XCTAssertTrue(secondBoolNode.isAvailable)
        XCTAssertFalse(secondBoolNode.isRecursiveLoopDetected)
        XCTAssertEqual(secondBoolNode.children.count, 4)
        guard secondBoolNode.children.count == 4 else {
            return
        }
        let secondBoolChildren = secondBoolNode.children.sorted { $0 < $1 }

        let secondBoolFirstNode = secondBoolChildren[0]
        XCTAssertEqual(secondBoolFirstNode.id, "FirstView")
        XCTAssertEqual(secondBoolFirstNode.viewType, "FirstView")
        XCTAssertTrue(secondBoolFirstNode.isAvailable)
        XCTAssertFalse(secondBoolFirstNode.isRecursiveLoopDetected)
        XCTAssertEqual(secondBoolFirstNode.children.count, 4)

        let secondBoolMainTabNode = secondBoolChildren[1]
        XCTAssertEqual(secondBoolMainTabNode.id, "MainTabView")
        XCTAssertEqual(secondBoolMainTabNode.viewType, "MainTabView")
        XCTAssertTrue(secondBoolMainTabNode.isAvailable)
        XCTAssertFalse(secondBoolMainTabNode.isRecursiveLoopDetected)
        XCTAssertEqual(secondBoolMainTabNode.children.count, 1)

        let secondBoolMainNode = secondBoolChildren[2]
        XCTAssertEqual(secondBoolMainNode.id, "MainView")
        XCTAssertEqual(secondBoolMainNode.viewType, "MainView")
        XCTAssertTrue(secondBoolMainNode.isAvailable)
        XCTAssertFalse(secondBoolMainNode.isRecursiveLoopDetected)
        XCTAssertEqual(secondBoolMainNode.children.count, 0)

        guard secondBoolFirstNode.children.count == 2 else {
            return
        }
        let secondBoolFirstChildren = secondBoolFirstNode.children.sorted { $0 < $1 }

        let secondBoolFirstBoolNode = secondBoolFirstChildren[0]
        XCTAssertEqual(secondBoolFirstBoolNode.id, "BoolView")
        XCTAssertEqual(secondBoolFirstBoolNode.viewType, "BoolView")
        XCTAssertTrue(secondBoolFirstBoolNode.isAvailable)
        XCTAssertTrue(secondBoolFirstBoolNode.isRecursiveLoopDetected)
        XCTAssertEqual(secondBoolFirstBoolNode.children.count, 0)

        let secondBoolFirstSecondNode = secondBoolFirstChildren[1]
        XCTAssertEqual(secondBoolFirstSecondNode.id, "SecondView")
        XCTAssertEqual(secondBoolFirstSecondNode.viewType, "SecondView")
        XCTAssertTrue(secondBoolFirstSecondNode.isAvailable)
        XCTAssertTrue(secondBoolFirstSecondNode.isRecursiveLoopDetected)
        XCTAssertEqual(secondBoolFirstSecondNode.children.count, 0)

        let secondBoolModalFirstNode = secondBoolChildren[3]
        XCTAssertEqual(secondBoolModalFirstNode.id, "ModalFirstView")
        XCTAssertNil(secondBoolModalFirstNode.viewType)
        // false because .fullScreenCover not supported now
        XCTAssertFalse(secondBoolModalFirstNode.isAvailable)
        XCTAssertFalse(secondBoolModalFirstNode.isRecursiveLoopDetected)
        XCTAssertEqual(secondBoolModalFirstNode.children.count, 0)

        // check the same Bool, but Second has not recursion loop
        guard boolNode.children.count == 4 else {
            return
        }
        let boolChildren = boolNode.children.sorted { $0 < $1 }
        let boolFirstNode = boolChildren[0]
        let boolMainTabNode = boolChildren[1]
        XCTAssertEqual(boolMainTabNode.viewType, "MainTabView")
        let boolMainNode = boolChildren[2]
        let boolModalFirstNode = boolChildren[3]
        XCTAssertNil(secondBoolMainNode.check(with: boolMainNode, hasCheckingOrder: true))
        XCTAssertNil(boolModalFirstNode.check(with: secondBoolModalFirstNode, hasCheckingOrder: true))

        XCTAssertEqual(boolFirstNode.id, "FirstView")
        XCTAssertEqual(boolFirstNode.viewType, "FirstView")
        XCTAssertTrue(boolFirstNode.isAvailable)
        XCTAssertFalse(boolFirstNode.isRecursiveLoopDetected)
        XCTAssertEqual(boolFirstNode.children.count, 2)
        guard boolFirstNode.children.count == 2 else {
            return
        }
        let  boolFirstChildren = boolFirstNode.children.sorted { $0 < $1 }

        let boolFirstBoolNode = boolFirstChildren[0]
        XCTAssertEqual(boolFirstBoolNode.id, "BoolView")
        XCTAssertEqual(boolFirstBoolNode.viewType, "BoolView")
        XCTAssertTrue(boolFirstBoolNode.isAvailable)
        XCTAssertTrue(boolFirstBoolNode.isRecursiveLoopDetected)
        XCTAssertEqual(boolFirstBoolNode.children.count, 0)

        let boolFirstSecondNode = boolFirstChildren[1]
        XCTAssertEqual(boolFirstSecondNode.id, "SecondView")
        XCTAssertEqual(boolFirstSecondNode.viewType, "SecondView")
        XCTAssertTrue(boolFirstSecondNode.isAvailable)
        XCTAssertFalse(boolFirstSecondNode.isRecursiveLoopDetected)
        XCTAssertEqual(boolFirstSecondNode.children.count, 1)
        guard boolFirstSecondNode.children.count == 1 else {
            return
        }

        let boolFirstSecondBoolNode = boolFirstSecondNode.children[0]
        XCTAssertEqual(boolFirstSecondBoolNode.id, "BoolView")
        XCTAssertEqual(boolFirstSecondBoolNode.viewType, "BoolView")
        XCTAssertTrue(boolFirstSecondBoolNode.isAvailable)
        XCTAssertTrue(boolFirstSecondBoolNode.isRecursiveLoopDetected)
        XCTAssertEqual(boolFirstSecondBoolNode.children.count, 0)

        XCTAssertEqual(firstNode.id, "FirstView")
        XCTAssertEqual(firstNode.viewType, "FirstView")
        XCTAssertTrue(firstNode.isAvailable)
        XCTAssertFalse(firstNode.isRecursiveLoopDetected)
        XCTAssertEqual(firstNode.children.count, 2)
        guard firstNode.children.count == 2 else {
            return
        }
        let  firstChildren = firstNode.children.sorted { $0 < $1 }

        let firstBoolNode = firstChildren[0]
        XCTAssertEqual(firstBoolNode.id, "BoolView")
        XCTAssertEqual(firstBoolNode.viewType, "BoolView")
        XCTAssertTrue(firstBoolNode.isAvailable)
        XCTAssertFalse(firstBoolNode.isRecursiveLoopDetected)
        XCTAssertEqual(firstBoolNode.children.count, 4)
        XCTAssertNotNil(firstBoolNode.check(with: boolNode, hasCheckingOrder: true))

        let firstSecondNode = firstChildren[1]
        XCTAssertEqual(firstSecondNode.id, "SecondView")
        XCTAssertEqual(firstSecondNode.viewType, "SecondView")
        XCTAssertTrue(firstSecondNode.isAvailable)
        XCTAssertFalse(firstSecondNode.isRecursiveLoopDetected)
        XCTAssertEqual(firstSecondNode.children.count, 1)

        let firstSecondBoolNode = firstSecondNode.children[0]
        XCTAssertEqual(firstSecondBoolNode.id, "BoolView")
        XCTAssertEqual(firstSecondBoolNode.viewType, "BoolView")
        XCTAssertTrue(firstSecondBoolNode.isAvailable)
        XCTAssertFalse(firstSecondBoolNode.isRecursiveLoopDetected)
        XCTAssertEqual(firstSecondBoolNode.children.count, 4)
        XCTAssertNotNil(firstSecondBoolNode.check(with: boolNode, hasCheckingOrder: true))
    }

    func testOnlyBool() throws {
        let boolNode = rootNode(for: BoolView(), mock: mock, isRecursive: false)

        XCTAssertEqual(boolNode.children.count, 4)
        guard boolNode.children.count == 4 else {
            return
        }

        XCTAssertEqual(boolNode.children[0].id, "MainView")
        XCTAssertEqual(boolNode.children[0].viewType, "MainView")
        XCTAssertTrue(boolNode.children[0].isAvailable)
        XCTAssertFalse(boolNode.children[0].isRecursiveLoopDetected)
        XCTAssertTrue(boolNode.children[0].isDeeplinkSupport)

        XCTAssertEqual(boolNode.children[1].id, "FirstView")
        XCTAssertEqual(boolNode.children[1].viewType, "FirstView")
        XCTAssertTrue(boolNode.children[1].isAvailable)
        XCTAssertFalse(boolNode.children[1].isRecursiveLoopDetected)
        XCTAssertTrue(boolNode.children[1].isDeeplinkSupport)

        XCTAssertEqual(boolNode.children[2].id, "ModalFirstView")
        // false because .fullScreenCover not supported now
        XCTAssertNil(boolNode.children[2].viewType)
        XCTAssertFalse(boolNode.children[2].isAvailable)
        XCTAssertFalse(boolNode.children[2].isRecursiveLoopDetected)
        XCTAssertTrue(boolNode.children[2].isDeeplinkSupport)

        XCTAssertEqual(boolNode.children[3].id, "MainTabView")
        XCTAssertEqual(boolNode.children[3].viewType, "MainTabView")
        XCTAssertTrue(boolNode.children[3].isAvailable)
        XCTAssertFalse(boolNode.children[3].isRecursiveLoopDetected)
        XCTAssertFalse(boolNode.children[3].isDeeplinkSupport)
    }

    func testErrorSnapshot() throws {
        try assertSnapshot(BugView().environmentObject(RootViewModelMock()), mock: mock)
    }

    // warning ustable test, because use rendering type of nodes analayes.
    // For testing up to iOS 16.3
    func testRenderingItemsSnapshot() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)
        try assertItemsSnapshot(rootView, preferMode: .rendering, mock: mock, hasDuplicationChecking: false)
    }

}

fileprivate struct BugView: View {

    @EnvironmentObject
    private var vm: RootViewModel

    var body: some View {
        Text("\(vm.stringForFirst ?? "")")
    }
}
