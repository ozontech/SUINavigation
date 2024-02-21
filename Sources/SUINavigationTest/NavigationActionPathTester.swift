//
//  NavigationActionPathTester.swift
//
//
//  Created by Sergey Balalaev on 20.12.2023.
//

import SUINavigation

class NavigationActionPathTester: NavigationActionPathProtocol {

    private(set) var params: [NavigationNodeParameter] = []

    init() {}

    private func isNotExists(name: String) -> Bool {
        for param in params {
            if param.name == name {
                return false
            }
        }
        return true
    }


    func popStringParam(_ name: String) -> String? {
        params.append(NavigationNodeParameter(name: name, type: NavigationNodeParameterType.string.rawValue, defaultValue: ""))
        return ""
    }
    func getStringParam(_ name: String) -> String?{
        if isNotExists(name: name) {
            params.append(NavigationNodeParameter(name: name, type: NavigationNodeParameterType.string.rawValue, defaultValue: ""))
        }
        return ""
    }

    func popIntParam(_ name: String) -> Int?{
        params.append(NavigationNodeParameter(name: name, type: NavigationNodeParameterType.int.rawValue, defaultValue: "0"))
        return 0
    }
    func getIntParam(_ name: String) -> Int?{
        if isNotExists(name: name) {
            params.append(NavigationNodeParameter(name: name, type: NavigationNodeParameterType.int.rawValue, defaultValue: "0"))
        }
        return 0
    }

    func popParam<T: NavigationParameterValue>(_ name: String) -> T?{
        let result = T.defaultValue
        params.append(NavigationNodeParameter(name: name, type: String(describing: T.self), defaultValue: result.stringValue))
        return result
    }
    func getParam<T: NavigationParameterValue>(_ name: String) -> T?{
        let result = T.defaultValue
        if isNotExists(name: name) {
            params.append(NavigationNodeParameter(name: name, type: String(describing: T.self), defaultValue: result.stringValue))
        }
        return result
    }

}
