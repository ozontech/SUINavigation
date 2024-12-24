//
//  ReplaceViewUITests.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 24.12.2024.
//

import XCTest

final class ReplaceViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testSimple() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapSecond()
        SecondView(app: app)
            .checkThis(number: 11)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Bool")
            .tapReplace()
        ReplaceView(app: app)
            .checkThis(string: "www")
            .tapDismiss()
        SecondView(app: app)
            .checkThis(number: 11)
            .tapDismiss()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testFromDoubleFirst() throws {
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
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Bool")
            .tapReplace()
        ReplaceView(app: app)
            .checkThis(string: "www")
            .tapDismiss()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testFromDoubleSecond() throws {
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
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Bool")
            .tapSecond22()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Bool")
            .tapReplace()
        ReplaceView(app: app)
            .checkThis(string: "www")
            .tapDismiss()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "Bool")
            .tapReplace()
        ReplaceView(app: app)
            .checkThis(string: "www")
            .tapDismiss()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapDismiss()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testTabRoot() throws {
        let app = XCUIApplication.app(isTab: true)
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapTab("Second Tab")
        SecondView(app: app)
            .checkThis(number: 120)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Bool")
            .tapReplace()
        ReplaceView(app: app)
            .checkThis(string: "www")
            .tapDismiss()
        SecondView(app: app)
            .checkThis(number: 120)
        MainView(app: app)
            .tapTab("Main Tab")
            .checkThis()
    }
}
