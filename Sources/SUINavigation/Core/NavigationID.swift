//
//  NavigationID.swift
//  
//
//  Created by Sergey Balalaev on 23.10.2023.
//

import SwiftUI

public protocol NavigationID {
    var isRoot: Bool {get}

    var stringValue: String {get}
}

extension String: NavigationID {
    public static let root: NavigationID = ""

    public var stringValue: String {
        self
    }

    public var isRoot: Bool {
        self == .root.stringValue
    }
}

extension View {
    public static var navigationID: NavigationID {
        String(describing: self)
    }

    public var navigationID: NavigationID {
        Self.navigationID
    }
}
