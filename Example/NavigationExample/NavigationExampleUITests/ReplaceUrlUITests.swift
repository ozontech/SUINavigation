//
//  ReplaceUrlUITests.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 24.10.2023.
//

import XCTest

final class ReplaceUrlUITests: XCTestCase {

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
            .enterActionUrlTextField("SecondView?SecondView=155")
            .tapReplaceUrl()
        SecondView(app: app)
            .checkThis(number: 155)
            .tapDismiss()
        MainView(app: app)
            .checkThis()
    }

    func testLongUrl() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapSecond22()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("SecondView/BoolView/FirstView/SecondView/BoolView?SecondView=1&firstString=first&secondNumber=2")
            .tapReplaceUrl()
        BoolView(app: app)
            .checkThis()
        // FirstView have different input (firstString) output (FirstView) params
            .checkPath("SecondView/BoolView/FirstView/SecondView/BoolView?SecondView=1&FirstView=first&secondNumber=2")
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 2)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "first")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkPath("SecondView/BoolView?SecondView=1")
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 1)
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

    func testStartWithBoolUrl() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("BoolView/FirstView/SecondView?firstString=first&secondNumber=1")
            .tapReplaceUrl()
        SecondView(app: app)
            .checkThis(number: 1)
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "first")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

    func testErrorWithLastElementUrl() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("BoolView/FirstView/second?firstString=first&secondNumber=1")
            .tapReplaceUrl()
        FirstView(app: app)
            .checkThis(string: "first")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

    // TODO: needs testRepeatUrl

    // TODO: needs testManyManyScreens


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
            .tapReplaceUrl()
        MainView(app: app)
            .checkThis()
    }

    func testEmptyErrorUrl() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
        // because in MainView the FirstView declared just navigation without url action
            .enterActionUrlTextField("FirstView")
            .tapReplaceUrl()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .checkThis()
    }

}
