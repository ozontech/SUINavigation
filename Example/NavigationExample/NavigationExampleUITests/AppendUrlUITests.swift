//
//  ActionUrlUITests.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 19.10.2023.
//

import XCTest

final class ActionUrlUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testSimpleUrl() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .enterActionUrlTextField("FirstView/SecondView?firstString=fromURL&secondNumber=155")
            .tapAppendUrl()
        SecondView(app: app)
            .checkThis(number: 155)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "fromURL")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

    func testLongUrl() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("FirstView/SecondView/BoolView/FirstView/SecondView/BoolView?firstString=first1&secondNumber=1&firstString=first2&secondNumber=2")
            .tapAppendUrl()
        BoolView(app: app)
            .checkThis()
        // FirstView have different input (firstString) output (FirstView) params
            .checkPath("BoolView/FirstView/SecondView/BoolView/FirstView/SecondView/BoolView?FirstView=first1&secondNumber=1&FirstView=first2&secondNumber=2")
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 2)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "first2")
            .tapBack()
        BoolView(app: app)
            .checkThis()
        // FirstView have different input (firstString) output (FirstView) params
            .checkPath("BoolView/FirstView/SecondView/BoolView?FirstView=first1&secondNumber=1")
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 1)
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "first1")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

    func testErrorWith2lastElementsUrl() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("FirstView/SecondView/BoolView/FirstView/BoolView/SecondView?firstString=first1&secondNumber=1&firstString=first2&secondNumber=2")
            .tapAppendUrl()
        FirstView(app: app)
            .checkThis(string: "first2")
            .tapBack()
        BoolView(app: app)
            .checkThis()
        // FirstView have different input (firstString) output (FirstView) params
            .checkPath("BoolView/FirstView/SecondView/BoolView?FirstView=first1&secondNumber=1")
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 1)
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "first1")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

    func testRepeatUrl() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("FirstView/SecondView/BoolView?firstString=&secondNumber=0")
            .tapAppendUrl()
        BoolView(app: app)
            .checkThis()
        // FirstView have different input (firstString) output (FirstView) params
            .checkPath("BoolView/FirstView/SecondView/BoolView?FirstView=&secondNumber=0")
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 0)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .tapBack()
        MainView(app: app)
            .checkThis()
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("FirstView/SecondView/BoolView?firstString=2&secondNumber=3")
            .tapAppendUrl()
        BoolView(app: app)
            .checkThis()
        // FirstView have different input (firstString) output (FirstView) params
            .checkPath("BoolView/FirstView/SecondView/BoolView?FirstView=2&secondNumber=3")
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 3)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "2")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

    /// DoubleNavigation is not working from iOS 16 because NavigationStack on NavigationStack is broken
    func testDoubleNavigation() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .enterActionUrlTextField("FirstView/SecondView/BoolView/MainView?firstString=1&secondNumber=1")
            .tapAppendUrl()
        MainView(app: app)
            .checkThis()
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapClearActionUrl()
            .enterActionUrlTextField("FirstView/SecondView/BoolView?firstString=2&secondNumber=2")
            .tapAppendUrl()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView/FirstView/SecondView/BoolView?FirstView=2&secondNumber=2")
            .tapDismiss()
        SecondView(app: app)
            .checkThis(number: 2)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "2")
            .tapDismiss()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapDismiss()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .swipeBack()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView/FirstView/SecondView/BoolView?FirstView=1&secondNumber=1")
            .tapDismiss()
        SecondView(app: app)
            .checkThis(number: 1)
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "1")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

    func testEmptyUrl() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .enterActionUrlTextField("")
            .tapAppendUrl()
            .checkThis()
            .checkPath("BoolView")
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Bool")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

}
