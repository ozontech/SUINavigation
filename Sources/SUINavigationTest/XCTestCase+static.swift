//
//  XCTestCase+static.swift
//
//
//  Created by Sergey Balalaev on 29.12.2023.
//

import XCTest
import SwiftUI
import SUINavigation

@inline(__always)
public func staticTest<SourceView: View, DestinationView: View>(
    _ sourceView: SourceView,
    destinationView: DestinationView.Type = DestinationView.self,
    hasCheckingBeforeEvolution: Bool = false,
    evalution: () -> Void = {},
    destination: @escaping (_ view: DestinationView) -> Void = {_ in },
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    var isFound = false

    NavigationCatch.shared.catchView(to: DestinationView.self, mode: .static) { view in
        if isFound == false {
            isFound = true
            destination(view)
        }
    }

    if hasCheckingBeforeEvolution {
        NavigationNodeStaticAnalyser.processing(sourceView)

        if isFound == true {
            XCTFail("Shown view before triger evalution yet.", file: file, line: line)
        }
    }

    evalution()

    NavigationNodeStaticAnalyser.processing(sourceView)

    if isFound == false {
        XCTFail("Not found view after triger evalution", file: file, line: line)
    }
}
