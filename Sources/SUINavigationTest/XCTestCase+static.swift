//
//  XCTestCase+static.swift
//
//
//  Created by Sergey Balalaev on 29.12.2023.
//

import XCTest
import SwiftUI
import SUINavigation


extension XCTestCase {


    public func staticTest<SourceView: View, DestinationView: View>(
        _ sourceView: SourceView,
        destinationView: DestinationView.Type = DestinationView.self,
        hasCheckingBeforeEvolution: Bool = false,
        evalution: () -> Void = {},
        destination: @escaping (_ view: DestinationView) -> Void = {_ in }
    ) {
        var isFound = false

        NavigationCatch.shared.catchView(to: DestinationView.self, mode: .static) { view in
            if isFound == false {
                isFound = true
                destination(view)
            }
        }

        if hasCheckingBeforeEvolution {
            _ = sourceView.body

            if isFound == true {
                XCTFail("Shown before triger evalution yet.")
            }
        }

        evalution()

        _ = sourceView.body

        if isFound == false {
            XCTFail("Not found after triger evalution")
        }
    }

}
