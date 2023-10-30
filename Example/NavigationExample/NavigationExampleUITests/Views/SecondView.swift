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
    func checkThis(number: Int) -> Self {
        var text = app.staticTexts["This is Second"]
        _ = text.waitForExistence(timeout: 2)
        text = app.staticTexts["with: \(number)"]
        _ = text.waitForExistence(timeout: 2)
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
        let button = app.buttons["dismiss"]
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

}
