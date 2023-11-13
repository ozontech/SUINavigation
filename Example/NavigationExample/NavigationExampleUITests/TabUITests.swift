//
//  TabUITests.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 01.11.2023.
//

import XCTest

final class TabUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    /// This bug can be reproduced only on iOS 17
    /// When on Navigation has TabView and a User go to next View on Navigation, change screen or show system top panel he show how get to the root View
    /// Apple bug: when NavigationViewStorge content the NavigationView instead of the NavigationStack.
    /// Can't reproduce on iOS 16 and earlier.
    func testTabBarInDoubleNavigation() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapChange()
            .checkChanging(true)
            .checkThis()
            .tapTab()
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
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .checkChanging(true)
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkChanging(true)
    }

}
