//
//  RootUITests.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 06.10.2023.
//

import XCTest

final class RootUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testAllScreens() throws {
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
            .tapRoot()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testMoreScreens() throws {
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
            .tapRoot()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testManyScreens() throws {
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
            .tapRoot()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testManyManyScreens() throws {
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
            .tapMain()
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapSecond22()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapRoot()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapRoot()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    func testEmpty() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapRoot()
            .checkThis()
    }

    func testOnlySecond() throws {
        let app = XCUIApplication.launchEn
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapSecond()
        SecondView(app: app)
            .checkThis(number: 11)
            .tapRoot()
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
            .tapSecond22()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapRoot()
        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapFirst()
        FirstView(app: app)
            .checkThis(string: "Hi")
            .tapSecond22()
        SecondView(app: app)
            .checkThis(number: 22)
            .tapRoot()
        MainView(app: app)
            .checkThis()
    }

    func testPopToRoot() throws {
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
            .checkPath("FirstView/SecondView/BoolView?FirstView=Hi&secondNumber=22")
            .enterPopToTextField("")
            .tapPopTo()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .checkPath("BoolView")
            .tapBack()
        MainView(app: app)
            .checkThis()
    }

}
