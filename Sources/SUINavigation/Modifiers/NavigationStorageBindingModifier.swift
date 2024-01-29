//
//  NavigationStorageBindingModifier.swift
//
//
//  Created by Sergey Balalaev on 22.11.2023.
//

import SwiftUI

typealias NavigationBindingHandler = (_ value: any Equatable) -> any View

struct NavigationStorageBindingModifier<Destination: View, Item: Equatable>: ViewModifier {
    var data: Item.Type

    @ViewBuilder
    var destination: (Item) -> Destination

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    func body(content: Content) -> some View {
        content
            .onAppear {
                navigationStorage?.bindings[String(describing: Item.self)] = { item in
                    guard let item = item as? Item else {
                        return EmptyView()
                    }
                    return viewDestination(destination(item))
                }
            }

    }
}

public extension View {
    func navigationStorageBinding<Item: Equatable, Destination: View>(
        for data: Item.Type,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        navigationModifier(NavigationStorageBindingModifier(data: data, destination: destination))
    }
}
