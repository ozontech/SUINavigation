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
        text.waitForExistingAndAssert(timeout: 5)
        text = app.staticTexts["with: \(string)"]
        text.waitForExistingAndAssert(timeout: 5)
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
        let buttons = app.buttons.matching(identifier: "dismiss")
        for i in 0..<buttons.count{
            let button = buttons.element(boundBy: i)
            _ = button.waitForExistence(timeout: 2)
            if button.isHittable {
                button.tap()
                return self
            }
        }
        return self
    }

}
