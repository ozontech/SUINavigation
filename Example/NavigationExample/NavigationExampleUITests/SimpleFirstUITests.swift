//
//  SimpleFirstUITests.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import XCTest

final class SimpleFirstUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testTapBack() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testSwipeBack() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .swipeBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testTapDismiss() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapDismiss()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testRepeat() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapDismiss()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .swipeBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
    }

    func testToBoolWithSystemPanel() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .swipeTopToBottom()
            .checkThis()
            .swipeBottomToTop()
            .checkThis()
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }
}
