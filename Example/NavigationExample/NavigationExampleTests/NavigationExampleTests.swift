//
//  NavigationExampleTests.swift
//  NavigationExampleTests
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import XCTest
@testable import NavigationExample
import SwiftUI
import SUINavigationTest

final class NavigationExampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainToSecondDeepLink() throws {
        let viewModel = MainViewModelMock()
        let mainContentView = MainContentView(viewModel: viewModel)
        let navStorage = test(view: mainContentView) {
            viewModel.numberForSecond = 11
        }
        XCTAssertEqual(navStorage.currentUrl, "SecondView?SecondView=11")
    }

    func testMainToFirst() throws {
        self.measure {
            let viewModel = MainViewModelMock()
            let mainContentView = MainContentView(viewModel: viewModel)

            test(sourceView: mainContentView, destinationView: FirstView.self) {
                viewModel.stringForFirst = "New"
            } destination: { view in
                XCTAssertEqual(view.string, "New")
            }
        }
    }

    func testMainToSecond() throws {
        let viewModel = MainViewModelMock()
        let mainContentView = MainContentView(viewModel: viewModel)

        test(sourceView: mainContentView) {
            viewModel.numberForSecond = 13
        } destination: { (view: SecondView) in
            XCTAssertEqual(view.number, 13)
        }
    }

    func testMainToBool() throws {
        let isBoolShowed = State<Bool>(initialValue: true)
        let mainContentView = MainContentView(isBoolShowed: isBoolShowed)

        test(sourceView: mainContentView, destinationView: BoolView.self) {
        } destination: { view in
            XCTAssertEqual(BoolView.navigationID.stringValue, "BoolView")
        }
    }

    func testFirstToSecond() throws {
        let numberForSecond = State<Int?>(initialValue: 86)
        let firstView = FirstView(string: "First", numberForSecond: numberForSecond)

        test(sourceView: firstView, destinationView: SecondView.self) {
        } destination: { view in
            XCTAssertEqual(view.number, 86)
        }
    }

    func testFirstToBool() throws {
        let isBoolShowed = State<Bool>(initialValue: true)
        let firstView = FirstView(string: "First", isBoolShowed: isBoolShowed)

        test(sourceView: firstView, destinationView: BoolView.self)
    }

}
