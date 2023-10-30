//
//  NavigationActionPath.swift
//
//
//  Created by Sergey Balalaev on 18.10.2023.
//

import Foundation

public typealias NavigateUrlParamsHandler = (_ path: NavigationActionPath) -> Void

public protocol NavigationParameterValue {
    init?(_ description: String)
}

extension String : NavigationParameterValue {}
extension Int : NavigationParameterValue {}
extension Float : NavigationParameterValue {}
extension Double : NavigationParameterValue {}

struct NavigationParameter {
    let name: String
    let value: String
}

final public class NavigationActionPath {
    private(set) var path: [String]
    private var params: [NavigationParameter] = []

    init(url: String) {
        let pathEnd = url.firstIndex(of: "?") ?? url.endIndex
        let pathString = url.prefix(upTo: pathEnd)

        path = pathString.components(separatedBy: NSCharacterSet(charactersIn: "/") as CharacterSet)

        if pathEnd != url.endIndex {
            let paramsString = url.suffix(from: url.index(pathEnd, offsetBy: 1))
            params = paramsString.components(separatedBy: NSCharacterSet(charactersIn: "&") as CharacterSet).compactMap { value in
                let values = value.components(separatedBy: NSCharacterSet(charactersIn: "=") as CharacterSet)
                if values.count > 1 {
                    return NavigationParameter(name: values[0], value: values[1])
                } else if values.count == 1 {
                    return NavigationParameter(name: values[0], value: "")
                } else {
                    return nil
                }
            }
        }
    }

    func popPath(id: String) -> Bool {
        guard let firstItem = path.first else {
            return false
        }
        if firstItem == id {
            path.removeFirst()
            return true
        } else {
            return false
        }
    }

}

extension NavigationActionPath {

    public func popStringParam(_ name: String) -> String? {
        var index = 0
        while index < params.count {
            if params[index].name == name {
                let result = params[index].value
                params.remove(at: index)
                return result
            }
            index += 1
        }
        return nil
    }

    public func getStringParam(_ name: String) -> String? {
        for param in params {
            if param.name == name {
                return param.value
            }
        }
        return nil
    }

    public func popIntParam(_ name: String) -> Int? {
        guard let param = popStringParam(name) else {
            return nil
        }
        return Int(param)
    }

    public func getIntParam(_ name: String) -> Int? {
        guard let param = getStringParam(name) else {
            return nil
        }
        return Int(param)
    }

    public func popParam<T: NavigationParameterValue>(_ name: String) -> T? {
        guard let param = popStringParam(name) else {
            return nil
        }
        return T(param)
    }

    public func getParam<T: NavigationParameterValue>(_ name: String) -> T? {
        guard let param = getStringParam(name) else {
            return nil
        }
        return T(param)
    }
}
