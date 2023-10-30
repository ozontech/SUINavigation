//
//  MainView.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 05.10.2023.
//

import Foundation
import XCTest

struct MainView: View {

    let app: XCUIApplication

    @discardableResult
    func checkThis(with timeout: TimeInterval = 0.5) -> Self {
        let text = app.staticTexts["This is Main"]
        text.waitForExistingAndAssert(timeout: timeout)
        return self
    }

    @discardableResult
    func checkChanging(_ isChanged: Bool) -> Self {
        let text = app.staticTexts[isChanged ? "This screen is changed" : "Waitting changes"]
        text.waitForExistingAndAssert()
        return self
    }

    @discardableResult
    func checkRootMessage(tapOK: Bool) -> Self {
        let text = app.staticTexts["This is Root View"]
        text.waitForExistingAndAssert()
        let button = app.buttons["OK"]
        button.waitForExistingAndAssert()
        if tapOK {
            button.tap()
        }
        return self
    }

    @discardableResult
    func tapFirst() -> Self {
        let button = app.buttons["to First with Hi"]
        button.waitForExistingAndAssert()
        button.tap()
        return self
    }

    @discardableResult
    func tapSecond() -> Self {
        let button = app.buttons["to Second with 11"]
        button.waitForExistingAndAssert()
        button.tap()
        return self
    }

    @discardableResult
    func tapBool() -> Self {
        let button = app.buttons["to Bool"]
        button.waitForExistingAndAssert()
        button.tap()
        return self
    }

    @discardableResult
    func tapRoot() -> Self {
        let button = app.buttons["to Root"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

}
