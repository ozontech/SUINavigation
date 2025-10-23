//
//  MainView.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 05.10.2023.
//

import Foundation
import XCTest
@testable import NavigationExample

struct MainView: View {

    let app: XCUIApplication

    @discardableResult
    func checkThis() -> Self {
        let text = app.staticTexts["This is Main"]
        text.waitForExistingAndAssert(timeout: 2)
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
        text.waitForExistingAndAssert(timeout: 1.0)
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
    func tapCircular() -> Self {
        let button = app.buttons["to Circular"]
        button.waitForExistingAndAssert()
        button.tap()
        return self
    }

    @discardableResult
    func tapRoot() -> Self {
        let button = app.buttons["to Root"]
        _ = button.waitForExistence(timeout: 0.5)
        button.tap()
        return self
    }

    @discardableResult
    func tapTab(_ tab: String) -> Self {
        let button = app.buttons[tab]
        button.waitForExistingAndAssert()
        button.tap()
        return self
    }

    @discardableResult
    func tapChange() -> Self {
        let button = app.buttons["to change"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func checkVM(initCount: Int, deinitCount: Int) -> Self {
        let text = app.staticTexts["VM init count: \(initCount), VM deinit count: \(deinitCount)"]
        text.waitForExistingAndAssert(timeout: 1)
        return self
    }

}
