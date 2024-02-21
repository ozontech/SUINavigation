//
//  NavigationTransitionStaticTests.swift
//  NavigationExampleTests
//
//  Created by Sergey Balalaev on 19.02.2024.
//

import XCTest
@testable import NavigationExample
import SwiftUI
import SUINavigationTest

final class NavigationTransitionStaticTests: XCTestCase {

    func testMainToFirst() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)

        test(sourceView: rootView, destinationView: FirstView.self, preferMode: .static) {
            viewModel.stringForFirst = "New"
        } destination: { view in
            XCTAssertEqual(view.string, "New")
        }
    }

    func testMainToSecond() throws {
        let viewModel = RootViewModelMock()
        let rootView = RootView(viewModel: viewModel)

        test(sourceView: rootView, preferMode: .static) {
            viewModel.numberForSecond = 13
        } destination: { (view: SecondView) in
            XCTAssertEqual(view.number, 13)
        }
    }

    func testMainToBool() throws {
        let isBoolShowed = State<Bool>(initialValue: true)
        let rootView = RootView(isBoolShowed: isBoolShowed)

        test(sourceView: rootView, destinationView: BoolView.self, preferMode: .static)
    }

    func testFirstToSecond() throws {
        let numberForSecond = State<Int?>(initialValue: 86)
        let firstView = FirstView(string: "First", numberForSecond: numberForSecond)

        test(sourceView: firstView, destinationView: SecondView.self, preferMode: .static) {
        } destination: { view in
            XCTAssertEqual(view.number, 86)
        }
    }

    func testFirstToBool() throws {
        let isBoolShowed = State<Bool>(initialValue: true)
        let firstView = FirstView(string: "First", isBoolShowed: isBoolShowed)

        test(sourceView: firstView, destinationView: BoolView.self, preferMode: .static)
    }

}
