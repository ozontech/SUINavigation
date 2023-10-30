//
//  SimpleBoolUITests.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import XCTest

final class SimpleBoolUITests: XCTestCase {

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
            .tapBool()
        BoolView(app: app)
            .checkThis()
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
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .swipeBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testTapRoot() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapRoot()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testTapDismiss() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
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
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapDismiss()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapPopTo()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapRoot()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .swipeBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapBool()
        BoolView(app: app)
            .checkThis()
    }

}
