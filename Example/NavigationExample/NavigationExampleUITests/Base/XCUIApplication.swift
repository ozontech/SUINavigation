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

    static func app(isEnglish: Bool = true, isTab: Bool = false) -> XCUIApplication {
        let result = XCUIApplication()
        result.launchArguments = []
        if isEnglish {
            result.launchArguments.append(contentsOf: ["-AppleLanguages", "(en)", "-AppleLocale", "en_EN"])
        }
        if isTab {
            result.launchArguments.append("-Tab")
        }
        result.launch()
        return result
    }
}
