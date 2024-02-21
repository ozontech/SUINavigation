//
//  NavigationNode.swift
//
//
//  Created by Sergey Balalaev on 14.12.2023.
//

import Foundation

public enum NavigationNodeAvailable : String, Codable {
    case none
    case trigger
    case mock
}

public enum NavigationNodeAttribute : String, Codable {
    case recursiveLoopDetected
    case deeplink
}

public class NavigationNode : Codable {
    public let id: String
    // viewType can not nil if available != .none
    public var viewType: String? = nil
    public var available: NavigationNodeAvailable
    public var attributes: [NavigationNodeAttribute]
    public var params: [NavigationNodeParameter] = []
    public private(set) var children: [NavigationNode] = []
    public private(set) weak var parent: NavigationNode? = nil

    public var isAvailable: Bool {
        available != .none
    }
    public var isDeeplinkSupport: Bool {
        attributes.contains(.deeplink)
    }
    // if isRecursiveLoopDetected is true children should be empty
    public var isRecursiveLoopDetected: Bool {
        attributes.contains(.recursiveLoopDetected)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case viewType
        case available
        case attributes
        case params
        case children
    }

    public init(
        id: String,
        params: [NavigationNodeParameter] = [],
        available: NavigationNodeAvailable,
        attributes: [NavigationNodeAttribute] = []
    ) {
        self.id = id
        self.params = params
        self.available = available
        self.attributes = attributes
    }

    public func addChild(_ child: NavigationNode) {
        child.parent = self
        children.append(child)
    }

    public func isIdExists(with id: String) -> Bool {
        // better search from View id
        if self.id == id {
            return true
        }
        if let parent = parent {
            return parent.isIdExists(with: id)
        }
        return false
    }
}

// Standart type of params
public enum NavigationNodeParameterType: String, Codable {
    case string = "String"
    case int = "Int"
    case float = "Float"
    case double = "Double"
}

public struct NavigationNodeParameter : Codable {
    public let name: String
    public let type: String
    public let defaultValue: String

    public init(name: String, type: String, defaultValue: String) {
        self.name = name
        self.type = type
        self.defaultValue = defaultValue
    }
}
