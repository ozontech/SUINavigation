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

    func test<SourceView: View>(navigationView: SourceView, evalution: () -> Void) -> NavigationStorage {
        let expectation = expectation(description: "NavigationStorage")
        var navStorage: NavigationStorage!

        let view =
            navigationView
                .navigationStorage { storage in
                    navStorage = storage
                }
            .onAppear{
                Task { @MainActor in
                    expectation.fulfill()
                }
            }

        view.render()

        evalution()

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

        return navStorage
    }

    func test<SourceView: View>(view: SourceView, evalution: () -> Void) -> NavigationStorage {
        return test(
            navigationView: NavigationViewStorage{view},
            evalution: evalution
        )
    }

    func test<SourceView: View, DestinationView: View>(
        navigationView: SourceView, destinationView: DestinationView.Type = DestinationView.self,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in}
    ) {
        let expectation = expectation(description: "NavigationCatch")
        expectation.assertForOverFulfill = false

        let view = navigationView
            .navigationCatch(to: DestinationView.self) { view in
                destination(view)
                expectation.fulfill()
            }

        view.render()

        evalution()

        waitForExpectations(timeout: 3) { error in
            if let error = error {
                print("Error NavigationCatch: \(error.localizedDescription)")
            }
        }
    }

    func test<SourceView: View, DestinationView: View>(
        sourceView: SourceView, destinationView: DestinationView.Type = DestinationView.self,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in}
    ) {
        test(
            navigationView: NavigationViewStorage{sourceView},
            destinationView: destinationView,
            evalution: evalution,
            destination: destination
        )
    }

}
