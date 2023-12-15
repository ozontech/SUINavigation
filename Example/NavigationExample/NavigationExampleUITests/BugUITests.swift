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

    /// This bug can be reproduced only on iOS 17
    /// When on Navigation has TabView and a User go to next View on Navigation, change screen or show system top panel he show how get to the root View
    /// Apple bug: when NavigationViewStorage content the NavigationView instead of the NavigationStack.
    /// Can't reproduce on iOS 16 and earlier.
    func testBugWithTabBarInNavigationiOS17() throws {
        let app = XCUIApplication.app(isTab: true)
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapChange()
            .checkChanging(true)
            .checkThis()
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .checkChanging(true)
            .tapDismiss()
        MainView(app: app)
            .checkThis()
            .checkChanging(true)
    }

}
