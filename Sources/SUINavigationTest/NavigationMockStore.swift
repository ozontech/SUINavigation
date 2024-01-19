//
//  NavigationMockStore.swift
//
//
//  Created by Sergey Balalaev on 09.01.2024.
//

import SwiftUI
import SUINavigation

public struct NavigationMockStore: NavigationCatchMockProtocol {

    private var items: [Any] = []

    public init(items: [Any]) {
        self.items = items
    }

    public func tryGetView<Item: Equatable, Destination: View>(destination: @escaping (Item) -> Destination) -> Destination? {
        for item in items {
            if let item = item as? Item {
                return destination(item)
            }
        }
        return nil
    }

    public func tryGetView<Destination: View>(destination: () -> Destination) -> Destination? {
        return destination()
    }

}
