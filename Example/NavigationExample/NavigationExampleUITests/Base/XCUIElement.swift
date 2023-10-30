//
//  XCUIElement.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 06.10.2023.
//

import Foundation
import XCTest

extension XCUIElement {
    @discardableResult
    func waitForExistence() -> Bool {
        waitForExistence(timeout: 0)
    }

    func waitForExistingAndAssert(timeout: TimeInterval = 0) {
        XCTAssert(waitForExistence(timeout: timeout), "Not found element with \(self.label)")
    }
}

extension XCUIElement
{
    enum SwipeDirection {
        case left, right
    }

    func longSwipe(_ direction : SwipeDirection) {
        let startOffset: CGVector
        let endOffset: CGVector

        switch direction {
        case .right:
            startOffset = CGVector(dx: -0.001, dy: 0.3)
            endOffset = CGVector(dx: 0.6, dy: 0.0)
        case .left:
            startOffset = CGVector(dx: 0.6, dy: 0.0)
            endOffset = CGVector.zero
        }

        let startPoint = self.coordinate(withNormalizedOffset: startOffset)
        let endPoint = self.coordinate(withNormalizedOffset: endOffset)
        startPoint.press(forDuration: 0, thenDragTo: endPoint)
    }

}

protocol View {

    var app: XCUIApplication {get}

}

extension View {
    @discardableResult
    func tapBack() -> Self {
        let button = app.buttons["Back"]
        button.waitForExistingAndAssert()
        button.tap()
        return self
    }

    @discardableResult
    func swipeBack() -> Self {
        let navigationBar = app.windows.firstMatch
        navigationBar.waitForExistingAndAssert()

        let startOffset = CGVector(dx: -0.01, dy: 0.5)
        let endOffset = CGVector(dx: 1, dy: 0.5)
        let startPoint = navigationBar.coordinate(withNormalizedOffset: startOffset)
        let endPoint = navigationBar.coordinate(withNormalizedOffset: endOffset)
        startPoint
            .press(forDuration: 0.1, thenDragTo: endPoint, withVelocity: .fast, thenHoldForDuration: 0.1)

        return self
    }

    func dissmissKeyboard() {
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let dissmissKeyboard = app.keyboards.buttons["Hide keyboard"]
                if dissmissKeyboard.exists, dissmissKeyboard.isHittable {
                    dissmissKeyboard.tap()
                }
            } else {
                let dissmissKeyboard = app.keyboards.buttons["return"]
                if dissmissKeyboard.exists, dissmissKeyboard.isHittable {
                    dissmissKeyboard.tap()
                }
            }
        }
    }

}
