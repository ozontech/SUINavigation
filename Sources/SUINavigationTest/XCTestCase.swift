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

public extension XCTestCase {

    func test<SourceView: View>(view: SourceView, evalution: () -> Void) -> NavigationStorage {
        let expectation = expectation(description: "NavigationStorage")
        var navStorage: NavigationStorage!

        let view =
            NavigationViewStorage {
                view
                    .navigationStorage { storage in
                        navStorage = storage
                    }
            }
            .onAppear{
                Task { @MainActor in
                    expectation.fulfill()
                }
            }

        let hostingController = UIHostingController(rootView: view)
        hostingController.forceRender()

        evalution()

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

        return navStorage
    }

    func test<SourceView: View, DestinationView: View>(
        sourceView: SourceView, destinationView: DestinationView.Type = DestinationView.self,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in}
    ) {
        let expectation = expectation(description: "NavigationCatch")
        expectation.assertForOverFulfill = false

        let view =
            NavigationViewStorage {
                sourceView
            }
            .navigationCatch(to: DestinationView.self) { view in
                destination(view)
                expectation.fulfill()
            }

        let hostingController = UIHostingController(rootView: view)
        hostingController.forceRender()

        evalution()

        waitForExpectations(timeout: 3) { error in
            if let error = error {
                print("Error NavigationCatch: \(error.localizedDescription)")
            }
        }
    }

}
