//
//  NavigationMockStore.swift
//
//
//  Created by Sergey Balalaev on 09.01.2024.
//

import SwiftUI
import SUINavigation

public struct NavigationMockStore: NavigationCatchMockProtocol {

    private var items: [Any]

    private var views: [any View]

    public init(items: [Any], views: [any View] = []) {
        self.items = items
        self.views = views
    }

    public func tryGetView<Item: Equatable, Destination: View>(destination: @escaping (Item) -> Destination) -> Destination? {
        for item in items {
            if let item = item as? Item {
                return getDestination(destination(item))
            }
        }
        return nil
    }

    public func tryGetView<Destination: View>(destination: () -> Destination) -> Destination? {
        return getDestination(destination())
    }

    private func getDestination<Destination: View>(_ view: Destination) -> Destination {
        for view in views {
            if let view = view as? Destination {
                return view
            }
        }
        return view
    }

}
