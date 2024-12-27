//
//  XCTestCase+rendering.swift
//
//
//  Created by Sergey Balalaev on 29.12.2023.
//

import XCTest
import SwiftUI
import SUINavigation

extension UIHostingController {
    fileprivate func forceRender() {
        _render(seconds: 0)
    }
}

public extension View {

    @discardableResult
    func render() -> some View{
        let hostingController = UIHostingController(rootView: self)
        hostingController.forceRender()
        return self
    }
}

@inline(__always)
public func renderingTest<SourceView: View>(
    _ sourceView: SourceView,
    hasStorage: Bool,
    evalution: () -> Void,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) -> (navigationView: any View, storage: NavigationStorage?)
{
    let waiter = XCTWaiter()
    let expectation = XCTestExpectation(description: "NavigationStorage")
    var navStorage: NavigationStorage? = nil

    let view =
    sourceView
        .navigationStorage { storage in
            if navStorage == nil {
                navStorage = storage
                expectation.fulfill()
            }
        }

    evalution()

    var result: any View = sourceView

    if hasStorage {
        result = view.render()
    } else {
        result = NavigationStorageView{
            view
        }.render()
    }

    if waiter.wait(for: [expectation], timeout: 3) == .timedOut {
        XCTFail("Not found view after triger evalution", file: file, line: line)
    }

    return (result, navStorage)
}

@inline(__always)
public func renderingTest<SourceView: View, DestinationView: View>(
    _ sourceView: SourceView,
    hasStorage: Bool,
    destinationView: DestinationView.Type = DestinationView.self,
    evalution: () -> Void = {},
    destination: @escaping (_ view: DestinationView) -> Void = {_ in },
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let waiter = XCTWaiter()
    let expectation = XCTestExpectation(description: "NavigationCatch")
    expectation.assertForOverFulfill = true
    var isFound = false

    NavigationCatch.shared.catchView(to: DestinationView.self) { view in
        if isFound == false {
            isFound = true
            destination(view)
            expectation.fulfill()
        }
    }

    let view = sourceView

    evalution()

    if hasStorage {
        view.render()
    } else {
        NavigationStorageView{
            view
        }.render()
    }

    if waiter.wait(for: [expectation], timeout: 3) == .timedOut {
        XCTFail("Not found view after triger evalution", file: file, line: line)
    }
}

@inline(__always)
public func renderingTest<SourceView: View>(
    _ view: SourceView,
    hasStorage: Bool = false,
    evalution: () -> Void = { },
    destination: @escaping (_ view: any View) -> Void,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {

    let waiter = XCTWaiter()
    let expectationCatch = XCTestExpectation(description: "NavigationCatch")
    expectationCatch.assertForOverFulfill = true
    var isFound = false

    NavigationCatch.shared.catchAnyView { view in
        if isFound == false {
            isFound = true
            destination(view)
            expectationCatch.fulfill()
        }
    }

    evalution()

    if hasStorage {
        view.render()
    } else {
        NavigationStorageView{
            view
        }.render()
    }

    if waiter.wait(for: [expectationCatch], timeout: 3) == .timedOut {
        XCTFail("Not found view after triger evalution", file: file, line: line)
    }
}
