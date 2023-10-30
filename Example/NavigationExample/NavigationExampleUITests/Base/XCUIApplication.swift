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
        let result = XCUIApplication()
        result.launchArguments = ["-AppleLanguages", "(en)", "-AppleLocale", "en_EN"]
        result.launch()
        return result
    }
}
