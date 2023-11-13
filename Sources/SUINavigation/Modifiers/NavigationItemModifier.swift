//
//  NavigationItemModifier.swift
//
//
//  Created by Sergey Balalaev on 23.10.2023.
//

import SwiftUI

struct NavigationItemModifier<Destination: View, Item: Equatable>: ViewModifier {
    let item: Binding<Item?>
    let id: NavigationID?
    let paramName: String?

    @ViewBuilder
    private var destination: (Item) -> Destination

    @State
    private var isActive: Bool = false

    init(item: Binding<Item?>, id: NavigationID?, paramName: String?, @ViewBuilder destination: @escaping (Item) -> Destination) {
        self.item = item
        self.id = id
        self.paramName = paramName
        self.destination = destination
    }

    func body(content: Content) -> some View {
        ZStack {
            if #available(iOS 16.0, *) {
                content
                    .navigationDestination(isPresented: $isActive, destination: {if let item = item.wrappedValue {destination(item)}})
            } else {
                content
                NavigationLinkWrapperView(isActive: $isActive, destination: navigationDestination)
            }
            NavigationStorgeActionItemView<Destination>(isActive: $isActive, id: id, param: param)
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

    private var param: NavigationParameter? {
        if let value = item.wrappedValue {
            let name = paramName ?? id?.stringValue ?? Destination.navigationID.stringValue
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
        modifier(NavigationItemModifier(item: item, id: id, paramName: paramName, destination: destination))
    }
}
