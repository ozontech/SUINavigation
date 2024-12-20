//
//  NavigationStorageDestinationModifier.swift
//  SUINavigation
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI

typealias NavigationDestinationHandler = (_ value: any Equatable) -> Bool

struct NavigationStorageDestinationModifier<Item: Equatable>: ViewModifier {

    let id: NavigationID?
    let paramName: String?

    @State
    var destination: Item? = nil

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    func body(content: Content) -> some View {
        content
            .onAppear {
                navigationStorage?.destinations[String(describing: Item.self)] = { item in
                    if let item = item as? Item {
                        destination = item
                        return true
                    }
                    return false
                }
            }
            .navigation(item: $destination, id: id, paramName: paramName)
    }
}

public extension View {

    // With binding
    func navigationStorageDestination<Item: Equatable, Destination: View>(
        for data: Item.Type = Item.self,
        id: NavigationID? = nil,
        paramName: String? = nil,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        self
            .navigationStorageBinding(for: data, destination: destination)
            .navigationStorageDestination(for: data, id: id, paramName: paramName)
    }

    func navigationStorageDestination<Item: Equatable>(
        for data: Item.Type,
        id: NavigationID? = nil,
        paramName: String? = nil
    ) -> some View {
        navigationModifier(NavigationStorageDestinationModifier<Item>(id: id, paramName: paramName))
    }
}
