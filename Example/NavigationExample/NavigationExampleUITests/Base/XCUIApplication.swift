//
//  XCUIApplication.swift
//  NavigationExampleUITests
//
//  Created by Sergey Balalaev on 06.10.2023.
//

import Foundation
import XCTest

extension XCUIApplication {

    static var launchEn: XCUIApplication {
        return app(isEnglish: true)
    }

    static func app(isEnglish: Bool = true, isTab: Bool = false, isStackOn16: Bool = false) -> XCUIApplication {
        let result = appWithoutStart(isEnglish: isEnglish, isTab: isTab, isStackOn16: isStackOn16)
        result.launch()
        return result
    }

    static func appWithoutStart(isEnglish: Bool = true, isTab: Bool = false, isStackOn16: Bool = false) -> XCUIApplication {
        let result = XCUIApplication()

        if isEnglish {
            result.launchArguments.append(contentsOf: ["-AppleLanguages", "(en)", "-AppleLocale", "en_EN"])
        }
        if isTab {
            result.launchArguments.append(ViewMode.argumentName)
        }
        if ProcessInfo.processInfo.arguments.contains("-Modular") {
            result.launchArguments.append(ModelMode.argumentName)
        }
        if isStackOn16 {
            result.launchArguments.append(StrategyMode.argumentName)
        }
        return result
    }
}
