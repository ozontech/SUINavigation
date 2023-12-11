//
//  Destination.swift
//  NavigationExample
//
//  Created by Sergey Balalaev on 05.12.2023.
//

import SwiftUI
import SUINavigation

enum Destination: Equatable {
    case first(String)
    case second(Int)
    case bool
    case main
    case tab
}

extension Destination: NavigationID {
    var isRoot: Bool {
        switch self {
        case .first(_):
            return false
        case .second(_):
            return false
        case .bool:
            return false
        case .main:
            return true
        case .tab:
            return false
        }
    }

    var stringValue: String {
        switch self {
        case .first(_):
            return "FirstView"
        case .second(_):
            return "SecondView"
        case .bool:
            return "BoolView"
        case .main:
            return "MainView"
        case .tab:
            return "TabMainView"
        }
    }
}

extension Destination {
    static let first: NavigationID = Destination.first("")
    static let second: NavigationID = Destination.second(0)
}

extension Destination {

    @ViewBuilder
    var view: some View {
        switch self {
        case .first(let string):
            ModularFirstView(string: string)
        case .second(let number):
            ModularSecondView(number: number)
        case .bool:
            ModularBoolView()
        case .main:
            MainView()
        case .tab:
            MainTabView()
        }
    }
}
