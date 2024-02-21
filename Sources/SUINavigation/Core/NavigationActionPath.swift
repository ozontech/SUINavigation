//
//  NavigationActionPath.swift
//
//
//  Created by Sergey Balalaev on 18.10.2023.
//

import Foundation

public typealias NavigateUrlParamsHandler = NavigateUrlParamsLoadHandler
public typealias NavigateUrlParamsLoadHandler = (_ path: NavigationActionPathProtocol) -> Void
public typealias NavigateUrlParamsSaveHandler = (_ path: NavigationActionSavePathProtocol) -> Void

public protocol NavigationParameterValue {
    init?(_ description: String)
    static var defaultValue: Self {get}
    var stringValue: String {get}
}

extension NavigationParameterValue {
    public var stringValue: String {
        "\(self)"
    }
}

extension String : NavigationParameterValue {
    public static var defaultValue = ""
}
extension Int : NavigationParameterValue {
    public static var defaultValue = 0
}
extension Float : NavigationParameterValue {
    public static var defaultValue: Float = 0.0
}
extension Double : NavigationParameterValue {
    public static var defaultValue: Double = 0.0
}

struct NavigationParameter {
    let name: String
    let value: String
}

public protocol NavigationActionPathProtocol {

    func popStringParam(_ name: String) -> String?
    func getStringParam(_ name: String) -> String?

    func popIntParam(_ name: String) -> Int?
    func getIntParam(_ name: String) -> Int?

    func popParam<T: NavigationParameterValue>(_ name: String) -> T?
    func getParam<T: NavigationParameterValue>(_ name: String) -> T?
}

public protocol NavigationActionSavePathProtocol {

    func pushStringParam(_ name: String, value: String)
    func replaceStringParam(_ name: String, value: String)

    func pushIntParam(_ name: String, value: Int)
    func replaceIntParam(_ name: String, value: Int)

    func pushParam<T: NavigationParameterValue>(_ name: String, _ value: T)
    func replaceParam<T: NavigationParameterValue>(_ name: String, _ value: T)
}

final public class NavigationActionPath {
    private(set) var path: [String]
    private var params: [NavigationParameter] = []

    init(path: [String]) {
        self.path = path
    }

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

    func pushParam(_ param: NavigationParameter) {
        params.append(param)
    }

    func replaceParam(_ param: NavigationParameter) {
        #warning("check the same...")
        params.append(param)
    }

    func getURL() -> String {
        let pathString = path.joined(separator: "/")
        let paramsString = params.compactMap { param in
            return "\(param.name)=\(param.value)"
        }
            .filter{ $0.isEmpty == false }
            .joined(separator: "&")
        if paramsString.isEmpty {
            return pathString
        } else {
            return "\(pathString)?\(paramsString)"
        }
    }

}

extension NavigationActionPath: NavigationActionPathProtocol {

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

extension NavigationActionPath: NavigationActionSavePathProtocol {
    public func pushStringParam(_ name: String, value: String) {
        pushParam(NavigationParameter(name: name, value: value))
    }

    public func replaceStringParam(_ name: String, value: String) {
        replaceParam(NavigationParameter(name: name, value: value))
    }

    public func pushIntParam(_ name: String, value: Int) {
        pushParam(NavigationParameter(name: name, value: value.stringValue))
    }

    public func replaceIntParam(_ name: String, value: Int) {
        replaceParam(NavigationParameter(name: name, value: value.stringValue))
    }

    public func pushParam<T>(_ name: String, _ value: T) where T : NavigationParameterValue {
        pushParam(NavigationParameter(name: name, value: value.stringValue))
    }

    public func replaceParam<T>(_ name: String, _ value: T) where T : NavigationParameterValue {
        replaceParam(NavigationParameter(name: name, value: value.stringValue))
    }
}
