//
//  BoolView.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 05.10.2023.
//

import Foundation
import XCTest

struct BoolView: View {

    let app: XCUIApplication

    @discardableResult
    func checkThis() -> Self {
        let text = app.staticTexts["This is Bool"]
        _ = text.waitForExistence(timeout: 2)
        return self
    }

    @discardableResult
    func checkChanging(_ isChanged: Bool) -> Self {
        let text = app.staticTexts[isChanged ? "This screen is changed" : "Waitting changes"]
        text.waitForExistingAndAssert()
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
    func tapFirst() -> Self {
        let button = app.buttons["to First with Bool"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func tapMain() -> Self {
        let button = app.buttons["to Main"]
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
    func tapDismiss() -> Self {
        let button = app.buttons["dismiss"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func tapPopTo() -> Self {
        let button = app.buttons["popTo:"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func enterPopToTextField(_ text: String) -> Self {
        let textField = app.textFields["PopToViewName"]
        _ = textField.waitForExistence(timeout: 2)
        textField.tap()
        textField.typeText(text)
        return self
    }

    @discardableResult
    func tapSkip() -> Self {
        let button = app.buttons["skip:"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func enterSkipTextField(_ text: String) -> Self {
        let textField = app.textFields["SkipViewName"]
        _ = textField.waitForExistence(timeout: 2)
        textField.tap()
        textField.typeText(text)
        dissmissKeyboard()
        return self
    }

    @discardableResult
    func tapClearSkip() -> Self {
        let button = app.buttons["clear skip"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func enterActionUrlTextField(_ text: String) -> Self {
        let textField = app.textFields["URL"]
        _ = textField.waitForExistence(timeout: 2)
        textField.tap()
        textField.typeText(text)
        dissmissKeyboard()
        return self
    }

    @discardableResult
    func tapClearActionUrl() -> Self {
        let button = app.buttons["clear url"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func tapAppendUrl() -> Self {
        let button = app.buttons["append"]
        _ = button.waitForExistence(timeout: 5)
        button.tap()
        return self
    }

    @discardableResult
    func tapReplaceUrl() -> Self {
        let button = app.buttons["replace"]
        _ = button.waitForExistence(timeout: 2)
        button.tap()
        return self
    }

    @discardableResult
    func checkPath(_ path: String) -> Self {
        let query = NSPredicate(format: "label == %@", "Path: \(path)")
        let label = app.staticTexts.matching(query).firstMatch
        label.waitForExistingAndAssert(timeout: 3)
        return self
    }

}
