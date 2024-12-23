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

    ///
    /// To declare navigation node with binded `Item` value data to `Destination` view.
    /// For activate this navigation node you can use `changeDestination` method from `NavigationStorage`.
    ///
    /// Use this modifire in one of next cases:
    /// 1. if You want to manage of this view from next a views, for example to replace a previous view in the navigation stack.
    /// 2. If You use the NavigationStorageView with a TabView. From iOS 18 without this method root transition can generate system warning in console:
    /// Do not put a navigation destination modifier inside a "lazy” container, like `List` or `LazyVStack`. These containers create child views only when needed to render on screen. Add the navigation destination modifier outside these containers so that the navigation stack can always see the destination. There's a misplaced `navigationDestination(isPresented:destination:)` modifier presenting `Optional<LastView>`. It will be ignored in a future release.
    ///
    /// - Parameter data: Type of value data, can implement Equatable protocol. Default equal to declared from `Destination` closure.
    /// - Parameter id: Identifier of this navigation node for change after this node,  for deeplink binding, or each others. Default value equal to `Destination` structure name.
    /// - Parameter paramName: name of value who trigger this navigation node for storage or change from `NavigationStorage` observer or deeplinks. Default value equal to `Destination` structure name.
    ///
    /// - Returns: self view.
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

    /// This modifier analogy to `.navigationStorageDestination` with `Destination` closure and use with `.navigationStorageBinding` called before.
    func navigationStorageDestination<Item: Equatable>(
        for data: Item.Type,
        id: NavigationID? = nil,
        paramName: String? = nil
    ) -> some View {
        navigationModifier(NavigationStorageDestinationModifier<Item>(id: id, paramName: paramName))
    }
}
