//
//  NavigationItemModifier.swift
//
//
//  Created by Sergey Balalaev on 23.10.2023.
//

import SwiftUI

struct NavigationItemModifier<Destination: View, Item: Equatable>: ViewModifier {
    var item: Binding<Item?>

    @ViewBuilder var destination: (Item) -> Destination

    @State var isActive: Bool = false

    var id: NavigationID?
    var name: String?

    @OptionalEnvironmentObject var navigationStorage: NavigationStorage?

    init(id: NavigationID?, name: String?, item: Binding<Item?>, @ViewBuilder destination: @escaping (Item) -> Destination) {
        self.id = id
        self.name = name
        self.item = item
        self.destination = destination
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            NavigationLinkWrapperView(
                id: id,
                destination: navigationDestination,
                isActive: $isActive,
                param: param,
                navigationStorage: navigationStorage
            )
            .onChange(of: item.wrappedValue) { newValue in
                if let newValue {
                    isActive = true
                } else {
                    isActive = false
                }
            }
            .onChange(of: isActive) { newValue in
                if newValue == false {
                    item.wrappedValue = nil
                }
            }
        }
    }

    var param: NavigationParameter? {
        if let value = item.wrappedValue {
            let name = name ?? id?.stringValue ?? Destination.navigationID.stringValue
            return NavigationParameter(name: name, value: "\(value)")
        } else {
            return nil
        }
    }

    private var navigationDestination: Destination? {
        guard let item = item.wrappedValue else {
            return nil
        }

        return destination(item)
    }
}

public extension View {
    func navigation<Item: Equatable, Destination: View>(
        item: Binding<Item?>,
        id: NavigationID? = nil,
        paramName: String? = nil,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        modifier(NavigationItemModifier(id: id, name: paramName, item: item, destination: destination))
    }
}
