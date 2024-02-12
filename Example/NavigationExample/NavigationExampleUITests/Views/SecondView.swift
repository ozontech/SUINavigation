//
//  SecondView.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 06.10.2023.
//

import Foundation
import XCTest

struct SecondView: View {

    let app: XCUIApplication

    @discardableResult
    func checkThis(number: Int, timeout: TimeInterval = 5) -> Self {
        var text = app.staticTexts["This is Second"]
        text.waitForExistingAndAssert(timeout: 5)
        text = app.staticTexts["with: \(number)"]
        text.waitForExistingAndAssert(timeout: timeout)
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
