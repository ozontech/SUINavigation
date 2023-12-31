//
//  NavigationExampleApp.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 28.09.2023.
//

import SwiftUI

@main
struct NavigationExampleApp: App {
    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.arguments.contains("-Tab") {
                MainTabView()
            } else {
                MainView()
            }
        }
    }
}
