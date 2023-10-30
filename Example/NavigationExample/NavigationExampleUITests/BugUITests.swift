//
//  BugUITests.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 06.10.2023.
//

import Foundation
import XCTest

final class BugUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testBugWithChangingBackScreen() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapSecond()
        SecondView(app: app)
            .checkThis(number: 11)
            .tapChange()
            .checkThis(number: 11)
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkChanging(true)
            .checkRootMessage(tapOK: true)
            .tapSecond()
        SecondView(app: app)
            .checkThis(number: 11)
            .tapChange()
            .checkThis(number: 11)
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
    }

    func testBugWithChangingRootScreen() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .checkChanging(false)
            .tapSecond22()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapChange()
            .checkThis(number: 22)
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .checkChanging(true)
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkChanging(true)
            .checkRootMessage(tapOK: true)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .checkChanging(true)
            .tapSecond22()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapChange()
            .checkThis(number: 22)
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .checkChanging(false)
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
    }

    func testBugWithChangingCurrentScreen() throws {
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
            .checkChanging(false)
            .tapChange()
            .checkThis()
            .checkChanging(true)
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 11)
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkChanging(true)
    }

    func testBugWithManyChanging() throws {
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
            .checkChanging(false)
            .tapChange()
            .checkThis()
            .checkChanging(true)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Bool")
            .checkChanging(true)
            .tapSecond22()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapChange()
            .checkThis(number: 22)
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "Bool")
            .checkChanging(false)
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 11)
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
    }

}
