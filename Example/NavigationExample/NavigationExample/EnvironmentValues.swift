//
//  EnvironmentValues.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 05.02.2024.
//

import SwiftUI

private struct RootViewIsChangeShowedKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isChange: Binding<Bool> {
        get { self[RootViewIsChangeShowedKey.self] }
        set { self[RootViewIsChangeShowedKey.self] = newValue }
    }
}

extension CaseIterable where Self: Equatable, AllCases.Index == Int {
    mutating func next() {
        let items = Self.allCases
        if let index = items.firstIndex(of: self) {
            if index < items.count - 1 {
                self = items[index + 1]
            } else if items.count > 0{
                self = items[0]
            }
        }
    }
}

enum ViewMode: String, CaseIterable {
    case navigation
    case tabBar

    static var defaultValue: ViewMode {
        ProcessInfo.processInfo.arguments.contains(argumentName) ? .tabBar : .navigation
    }

    static let argumentName = "-Tab"
}

private struct ViewModeKey: EnvironmentKey {
    static let defaultValue: Binding<ViewMode> = .constant(.defaultValue)
}

extension EnvironmentValues {
    var viewMode: Binding<ViewMode> {
        get { self[ViewModeKey.self] }
        set { self[ViewModeKey.self] = newValue }
    }
}

enum ModelMode: String, CaseIterable {
    case standard
    case modular

    static var defaultValue: ModelMode {
        ProcessInfo.processInfo.arguments.contains(argumentName) ? .modular : .standard
    }

    static let argumentName = "-Modular"
}

private struct ModelModeKey: EnvironmentKey {
    static let defaultValue: Binding<ModelMode> = .constant(.defaultValue)
}

extension EnvironmentValues {
    var modelMode: Binding<ModelMode> {
        get { self[ModelModeKey.self] }
        set { self[ModelModeKey.self] = newValue }
    }
}

enum StrategyMode: String, CaseIterable {
    case stackOn16
    case stackOn17

    static var defaultValue: StrategyMode {
        ProcessInfo.processInfo.arguments.contains(argumentName) ? .stackOn16 : .stackOn17
    }

    static let argumentName = "-stackOn16"
}
