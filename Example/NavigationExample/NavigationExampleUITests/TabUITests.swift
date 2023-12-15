//
//  TabUITests.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 01.11.2023.
//

import XCTest
@testable import NavigationExample

final class TabUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    /// This bug can be reproduced only on iOS 17
    /// When on Navigation has TabView and a User go to next View on Navigation, change screen or show system top panel he show how get to the root View
    /// Apple bug: when NavigationViewStorage content the NavigationView instead of the NavigationStack.
    /// Can't reproduce on iOS 16 and earlier.
    /// DoubleNavigation is not working from iOS 16 because NavigationStack on NavigationStack is broken
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

    func testTabSelectionFromUrl() throws {
        let app = XCUIApplication.app(isTab: true)
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapTab("Bool Tab")
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("TabView/FirstView/SecondView?firstString=first&secondNumber=1&tab=Main Tab")
            .tapReplaceUrl()
        SecondView(app: app)
            .checkThis(number: 1)
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "first")
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

    func testTabSelectionAndModalFirstFromUrl() throws {
        let app = XCUIApplication.app(isTab: true)
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("TabView/BoolView/ModalFirstView?modalFirst=modal&tab=Second Tab")
            .tapReplaceUrl()
        FirstView(app: app)
            .checkThis(string: "modal")
            .tapDismiss()
        BoolView(app: app)
            .checkThis()
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 120)
        MainView(app: app)
            .tapTab("Main Tab")
            .checkThis()
    }

    func testTabSelectionAndAppendUrlError() throws {
        let app = XCUIApplication.app(isTab: true)
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("TabView/BoolView?tab=Second Tab")
            .tapAppendUrl()
            .checkThis()
            .tapBack()
        MainView(app: app)
            .checkThis()
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
    }

    func testTabSelectionAndCorrectAppendUrl() throws {
        let app = XCUIApplication.app(isTab: true)
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapTab("First Tab")
        FirstView(app: app)
            .checkThis(string: "TabBar")
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("FirstView/SecondView/BoolView?firstString=first&secondNumber=3")
            .tapAppendUrl()
        BoolView(app: app)
            .checkThis()
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 3)
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "first")
            .tapBack()
        BoolView(app: app)
            .checkThis()
            .tapBack()
        FirstView(app: app)
            .checkThis(string: "TabBar")
    }

    func testAfterModalFirstFromUrl() throws {
        let app = XCUIApplication.app(isTab: true)
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("TabView/ModalFirstView/SecondView/BoolView/FirstView?modalFirst=modal&secondNumber=2&tab=Bool Tab&firstString=navigation")
            .tapReplaceUrl()
        FirstView(app: app)
            .checkThis(string: "navigation")
            .tapDismiss()
        BoolView(app: app)
            .checkThis()
            .tapDismiss()
        SecondView(app: app)
            .checkThis(number: 2)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "modal")
            .tapDismiss()
        BoolView(app: app)
            .checkThis()
    }

    func testChildrenNavigationFromUrl() throws {
        let app = XCUIApplication.app(isTab: true)
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .enterActionUrlTextField("TabView/SecondView/BoolView/ModalFirstView/SecondView/BoolView/ModalFirstView/SecondView?tab=First Tab&secondNumber=1&modalFirst=modal1&secondNumber=2&modalFirst=modal2&secondNumber=3")
            .tapReplaceUrl()
        SecondView(app: app)
            .checkThis(number: 3, timeout: 7)
            .swipeBack()
        FirstView(app: app)
            .checkThis(string: "modal2")
            .tapDismiss()
        BoolView(app: app)
            .checkThis()
            .tapDismiss()
        SecondView(app: app)
            .checkThis(number: 2)
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "modal1")
            .tapDismiss()
        BoolView(app: app)
            .checkThis()
            .swipeBack()
        SecondView(app: app)
            .checkThis(number: 1)
            .swipeBack()
        FirstView(app: app)
            .checkThis(string: "TabBar")
    }

}
