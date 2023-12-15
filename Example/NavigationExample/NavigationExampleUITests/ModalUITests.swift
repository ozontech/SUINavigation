//
//  ModalUITests.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 15.12.2023.
//

import XCTest


final class ModalUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testSimpleFirst() throws {
        let app = XCUIApplication.launchEn

        MainView(app: app)
            .checkThis()
            .checkChanging(false)
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapModalFirst()
        FirstView(app: app)
            .checkThis(string: "Modal")
            .tapBool()
        BoolView(app: app)
            .checkThis()
            .tapDismiss()
        FirstView(app: app)
            .checkThis(string: "Modal")
            .tapDismiss()
        BoolView(app: app)
            .checkThis()
            .tapBack()
        MainView(app: app)
            .checkThis()
            .checkRootMessage(tapOK: true)
    }

}
