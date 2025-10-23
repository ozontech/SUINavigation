//
//  DeeplinkUITests.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 30.09.2025.
//

import XCTest

final class DeeplinkUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    @available(iOS 16.4, *)
    func testHotStart() throws {
        let app = XCUIApplication()
        app.launch()
        app.open(URL(string: "suintest://SecondView/BoolView?SecondView=454")!)

        BoolView(app: app)
            .checkThis()
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 454)
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

    @available(iOS 16.4, *)
    func testOnStarted() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
        app.open(URL(string: "suintest://SecondView/BoolView?SecondView=868")!)
        BoolView(app: app)
            .checkThis()
            .tapBack()
        SecondView(app: app)
            .checkThis(number: 868)
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

}
