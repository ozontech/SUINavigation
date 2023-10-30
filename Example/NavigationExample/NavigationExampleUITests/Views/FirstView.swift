//
//  FirstView.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 06.10.2023.
//

import Foundation
import XCTest

struct FirstView: View {

    let app: XCUIApplication

    @discardableResult
    func checkThis(string: String) -> Self {
        var text = app.staticTexts["This is First"]
        _ = text.waitForExistence(timeout: 2)
        text = app.staticTexts["with: \(string)"]
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
    func tapBool() -> Self {
        let button = app.buttons["to Bool"]
        button.waitForExistingAndAssert()
        button.tap()
        return self
    }

    @discardableResult
    func tapSecond22() -> Self {
        let button = app.buttons["to Second with 22"]
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

}
