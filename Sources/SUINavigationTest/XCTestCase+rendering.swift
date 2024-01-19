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

internal extension XCTestCase {

    func renderingTest<SourceView: View>(
        _ sourceView: SourceView,
        hasStorage: Bool,
        evalution: () -> Void) -> (navigationView: any View, storage: NavigationStorage?)
    {
        let expectation = expectation(description: "NavigationStorage")
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
            result = NavigationViewStorage{
                view
            }.render()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

        return (result, navStorage)
    }

    func renderingTest<SourceView: View, DestinationView: View>(
        _ sourceView: SourceView,
        hasStorage: Bool,
        destinationView: DestinationView.Type = DestinationView.self,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in }
    ) {
        let expectation = expectation(description: "NavigationCatch")
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
            NavigationViewStorage{
                view
            }.render()
        }

        waitForExpectations(timeout: 3) { error in
            if let error = error {
                print("Error NavigationCatch: \(error.localizedDescription)")
            }
        }
    }

    func renderingTest<SourceView: View>(
        _ view: SourceView,
        hasStorge: Bool = false,
        evalution: () -> Void = { },
        destination: @escaping (_ view: any View) -> Void
    ) {

        let expectationCatch = expectation(description: "NavigationCatch")
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

        if hasStorge {
            view.render()
        } else {
            NavigationViewStorage{
                view
            }.render()
        }

        waitForExpectations(timeout: 3) { error in
            if let error = error {
                print("Error NavigationCatch: \(error.localizedDescription)")
            }
        }
    }

}
