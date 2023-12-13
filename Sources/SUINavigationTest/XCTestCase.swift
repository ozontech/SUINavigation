//
//  XCTestCase.swift
//
//
//  Created by Sergey Balalaev on 30.11.2023.
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
    func render(){
        let hostingController = UIHostingController(rootView: self)
        hostingController.forceRender()
    }
}

public extension XCTestCase {

    private func test<SourceView: View>(
        _ sourceView: SourceView,
        hasStorge: Bool,
        evalution: () -> Void) -> NavigationStorage?
    {
        let expectation = expectation(description: "NavigationStorage")
        var navStorage: NavigationStorage? = nil

        let view =
            sourceView
                .navigationStorage { storage in
                    navStorage = storage
                    expectation.fulfill()
                }

        evalution()

        if hasStorge {
            view.render()
        } else {
            NavigationViewStorage{
                view
            }.render()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

        return navStorage
    }

    func test<SourceView: View>(navigationView: SourceView, evalution: () -> Void = {}) -> NavigationStorage? {
        return test(navigationView, hasStorge: true, evalution: evalution)
    }

    func test<SourceView: View>(view: SourceView, evalution: () -> Void = {}) -> NavigationStorage? {
        return test(view, hasStorge: false, evalution: evalution)
    }


    private func test<SourceView: View, DestinationView: View>(
        _ sourceView: SourceView,
        hasStorge: Bool,
        destinationView: DestinationView.Type = DestinationView.self,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in }
    ) {
        let expectation = expectation(description: "NavigationCatch")
        expectation.assertForOverFulfill = false

        NavigationCatch.shared.catchView(to: DestinationView.self) { view in
            destination(view)
            expectation.fulfill()
        }

        let view = sourceView

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

    func test<SourceView: View, DestinationView: View>(
        navigationView: SourceView, 
        destinationView: DestinationView.Type = DestinationView.self,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in }
    ) {
        test(
            navigationView,
            hasStorge: true,
            destinationView: destinationView,
            evalution: evalution,
            destination: destination
        )
    }

    func test<SourceView: View, DestinationView: View>(
        sourceView: SourceView, 
        destinationView: DestinationView.Type = DestinationView.self,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in }
    ) {
        test(
            sourceView,
            hasStorge: false,
            destinationView: destinationView,
            evalution: evalution,
            destination: destination
        )
    }

}
