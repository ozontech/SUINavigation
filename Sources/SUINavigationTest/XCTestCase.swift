//
//  XCTestCase.swift
//
//
//  Created by Sergey Balalaev on 30.11.2023.
//

import XCTest
import SwiftUI
import SUINavigation

public extension XCTestCase {

    public static var preferMode: NavigationCatchMode = .static

    func test<SourceView: View>(navigationView: SourceView, evalution: () -> Void = {}) -> NavigationStorage? {
        return renderingTest(navigationView, hasStorage: true, evalution: evalution).storage
    }

    func test<SourceView: View>(view: SourceView, evalution: () -> Void = {}) -> NavigationStorage? {
        return renderingTest(view, hasStorage: false, evalution: evalution).storage
    }

    func navigation<SourceView: View>(_ view: SourceView) -> (navigationView: any View, storage: NavigationStorage?) {
        return renderingTest(view, hasStorage: false, evalution: {})
    }

    func test<SourceView: View, DestinationView: View>(
        navigationView: SourceView, 
        destinationView: DestinationView.Type = DestinationView.self,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in }
    ) {
        switch Self.preferMode {
        case .rendering:
            renderingTest(
                navigationView,
                hasStorage: true,
                destinationView: destinationView,
                evalution: evalution,
                destination: destination
            )
        case .static:
            staticTest(
                navigationView,
                destinationView: destinationView,
                evalution: evalution,
                destination: destination
            )
        }

    }

    func test<SourceView: View, DestinationView: View>(
        sourceView: SourceView, 
        destinationView: DestinationView.Type = DestinationView.self,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in }
    ) {
        switch Self.preferMode {
        case .rendering:
            renderingTest(
                sourceView,
                hasStorage: false,
                destinationView: destinationView,
                evalution: evalution,
                destination: destination
            )
        case .static:
            staticTest(
                sourceView,
                destinationView: destinationView,
                evalution: evalution,
                destination: destination
            )
        }
    }

    // deprecated
    func test<SourceView: View>(
        _ view: SourceView,
        hasStorge: Bool = false,
        evalution: () -> Void = { },
        destination: @escaping (_ view: any View) -> Void
    ){
        renderingTest(
            view,
            hasStorge: hasStorge,
            evalution: evalution,
            destination: destination
        )
    }

}
