//
//  ReplaceView.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 24.12.2024.
//

import Foundation
import XCTest

struct ReplaceView: View {

    let app: XCUIApplication

    @discardableResult
    func checkThis(string: String) -> Self {
        var text = app.staticTexts["This is Replace"]
        text.waitForExistingAndAssert(timeout: 5)
        text = app.staticTexts["with: \(string)"]
        text.waitForExistingAndAssert(timeout: 5)
        return self
    }

    @discardableResult
    func checkChanging(_ isChanged: Bool) -> Self {
        let text = app.staticTexts[isChanged ? "changed" : "wait change"]
        text.waitForExistingAndAssert()
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
    func tapDismiss() -> Self {
        let button = app.buttons["dismiss"].firstMatch
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func tapPop() -> Self {
        let button = app.buttons["popBack"].firstMatch
        _ = button.waitForExistence(timeout: 2)
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
    func tapRoot() -> Self {
        let button = app.buttons["to Root"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func tapTriggerNil() -> Self {
        let button = app.buttons["trigger to nil"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

}
