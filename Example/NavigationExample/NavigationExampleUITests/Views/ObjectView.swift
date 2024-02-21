//
//  ObjectView.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 15.02.2024.
//

import Foundation
import XCTest

struct ObjectView: View {

    let app: XCUIApplication

    @discardableResult
    func checkThis(string: String) -> Self {
        var text = app.staticTexts["This is Object"]
        text.waitForExistingAndAssert(timeout: 5)
        text = app.staticTexts["Object: \(string)"]
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
    func tapFirst() -> Self {
        let button = app.buttons["to First"]
        button.waitForExistingAndAssert()
        button.tap()
        return self
    }

    @discardableResult
    func tapPopToFirst() -> Self {
        let button = app.buttons["pop to First"]
        button.waitForExistingAndAssert()
        button.tap()
        return self
    }

    @discardableResult
    func tapPopToBool() -> Self {
        let button = app.buttons["pop to Bool"]
        button.waitForExistingAndAssert()
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
