//
//  NavigationItemBindingModifier.swift
//
//
//  Created by Sergey Balalaev on 04.12.2023.
//

import SwiftUI

struct NavigationItemBindingModifier<DestinationValue: Equatable, Item: Equatable>: ViewModifier {
    let item: Binding<Item?>
    let id: NavigationID?
    let paramName: String?
    let destinationValue: (Item) -> DestinationValue

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    @State
    private var identifiableView: IdentifiableView? = nil

    @State
    private var navigationId: NavigationID? = nil

    init(item: Binding<Item?>, id: NavigationID?, paramName: String?, @ViewBuilder destinationValue: @escaping (Item) -> DestinationValue) {
        self.item = item
        self.id = id
        self.paramName = paramName
        self.destinationValue = destinationValue
    }

    func body(content: Content) -> some View {
        content
            .navigation(item: $identifiableView, value: item, id: id ?? navigationId, paramName: paramName) { identifiableView in
                identifiableView.view
            }
            .onChange(of: item.wrappedValue) { value in
                if let value = value {
                    let navigationItem = destinationValue(value)
                    if let navigationItem = navigationItem as? NavigationID {
                        navigationId = navigationItem
                    }
                    if let view = navigationStorage?.searchBinding(for: DestinationValue.self)(navigationItem) {
                        identifiableView = IdentifiableView(view: view)
                    } else {
                        identifiableView = IdentifiableView(view: EmptyView())
                    }
                }
            }
            .onChange(of: identifiableView) { value in
                if value == nil {
                    item.wrappedValue = nil
                }
            }
    }

}

public extension View {

    // id should be non-optional because info from AnyView is undefined. But if DestinationValue inherited NavigationID protocol it information encapsulated of this value
    func navigation<Item: Equatable, DestinationValue: Equatable>(
        item: Binding<Item?>,
        id: NavigationID? = nil,
        paramName: String? = nil,
        destinationValue: @escaping (Item) -> DestinationValue
    ) -> some View {
        navigationModifier(NavigationItemBindingModifier(item: item, id: id, paramName: paramName, destinationValue: destinationValue))
    }

    // trigger from DestinationValue
    func navigation<DestinationValue: Equatable>(
        item: Binding<DestinationValue?>,
        id: NavigationID? = nil,
        paramName: String? = nil
    ) -> some View {
        self.navigation(item: item, id: id, paramName: paramName, destinationValue: { $0 })
    }
}

