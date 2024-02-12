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
    case second(Int, Binding<Int?>)
    case bool
    case main
    case tab

    static func == (lhs: Destination, rhs: Destination) -> Bool {
        switch lhs {
        case .first(let string):
            if case .first(let value) = rhs {
                return value == string
            } else {
                return false
            }
        case .second(let number, let numberFromParent):
            if case .second(let value, let valueFromParent) = rhs {
                return value == number && numberFromParent.wrappedValue == valueFromParent.wrappedValue
            } else {
                return false
            }
        case .bool:
            if case .bool = rhs {
                return true
            } else {
                return false
            }
        case .main:
            if case .main = rhs {
                return true
            } else {
                return false
            }
        case .tab:
            if case .tab = rhs {
                return true
            } else {
                return false
            }
        }
    }
}

extension Destination: NavigationID {
    var isRoot: Bool {
        switch self {
        case .first(_):
            return false
        case .second(_,_):
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
        case .second(_,_):
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
    static let second: NavigationID = Destination.second(0, .constant(0))
}

extension Destination {

    @ViewBuilder
    var view: some View {
        switch self {
        case .first(let string):
            ModularFirstView(string: string)
        case .second(let number, let numberFromParent):
            ModularSecondView(number: number, numberFromParent: numberFromParent)
        case .bool:
            ModularBoolView()
        case .main:
            MainView()
        case .tab:
            MainTabView()
        }
    }
}
