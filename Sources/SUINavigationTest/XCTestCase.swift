//
//  XCTestCase.swift
//
//
//  Created by Sergey Balalaev on 30.11.2023.
//

import XCTest
import SwiftUI
import SUINavigation

@inline(__always)
public func test<SourceView: View>(
    navigationView: SourceView,
    evalution: () -> Void = {},
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) -> NavigationStorage? {
    return renderingTest(
        navigationView,
        hasStorage: true,
        evalution: evalution,
        file: file,
        testName: testName,
        line: line).storage
}

@inline(__always)
public func test<SourceView: View>(
    view: SourceView,
    evalution: () -> Void = {},
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) -> NavigationStorage? {
    return renderingTest(
        view,
        hasStorage: false,
        evalution: evalution,
        file: file,
        testName: testName,
        line: line).storage
}

@inline(__always)
public func navigation<SourceView: View>(
    _ view: SourceView,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) -> (navigationView: any View, storage: NavigationStorage?) {
    return renderingTest(
        view,
        hasStorage: false,
        evalution: {},
        file: file,
        testName: testName,
        line: line)
}

@inline(__always)
public func test<SourceView: View, DestinationView: View>(
    navigationView: SourceView,
    destinationView: DestinationView.Type = DestinationView.self,
    preferMode: NavigationCatchMode = .static,
    evalution: () -> Void = {},
    destination: @escaping (_ view: DestinationView) -> Void = {_ in },
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    switch preferMode {
    case .rendering:
        renderingTest(
            navigationView,
            hasStorage: true,
            destinationView: destinationView,
            evalution: evalution,
            destination: destination,
            file: file,
            testName: testName,
            line: line
        )
    case .static:
        staticTest(
            navigationView,
            destinationView: destinationView,
            evalution: evalution,
            destination: destination,
            file: file,
            testName: testName,
            line: line
        )
    }
}

@inline(__always)
public func test<SourceView: View, DestinationView: View>(
    sourceView: SourceView,
    destinationView: DestinationView.Type = DestinationView.self,
    preferMode: NavigationCatchMode = .static,
    evalution: () -> Void = {},
    destination: @escaping (_ view: DestinationView) -> Void = {_ in },
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    switch preferMode {
    case .rendering:
        renderingTest(
            sourceView,
            hasStorage: false,
            destinationView: destinationView,
            evalution: evalution,
            destination: destination,
            file: file,
            testName: testName,
            line: line
        )
    case .static:
        staticTest(
            sourceView,
            destinationView: destinationView,
            evalution: evalution,
            destination: destination,
            file: file,
            testName: testName,
            line: line
        )
    }
}

// deprecated
@inline(__always)
public func test<SourceView: View>(
    _ view: SourceView,
    hasStorage: Bool = false,
    evalution: () -> Void = { },
    destination: @escaping (_ view: any View) -> Void,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
){
    renderingTest(
        view,
        hasStorage: hasStorage,
        evalution: evalution,
        destination: destination,
        file: file,
        testName: testName,
        line: line
    )
}
