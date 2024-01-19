//
//  NavigationItemModifier.swift
//
//
//  Created by Sergey Balalaev on 23.10.2023.
//

import SwiftUI

struct NavigationItemModifier<Item: Equatable, Value: Equatable, Destination: View>: ViewModifier {
    let item: Binding<Item?>
    let value: Binding<Value?>?
    let identifier: String
    let paramName: String?

    @ViewBuilder
    private var destination: (Item) -> Destination

    @State
    private var isActive: Bool = false

    init(item: Binding<Item?>, value: Binding<Value?>?, identifier: String, paramName: String?, @ViewBuilder destination: @escaping (Item) -> Destination) {
        self.item = item
        self.value = value
        self.identifier = identifier
        self.paramName = paramName
        self.destination = destination
    }

    func body(content: Content) -> some View {
        ZStack {
            if #available(iOS 16.0, *) {
                // We can't use from iOS 17 .navigationDestination with item param because that has an issue with navigation
                content
                    .navigationDestination(isPresented: $isActive, destination: {
                        if let item = item.wrappedValue {
                            viewDestination(destination(item))
                        }
                    })
            } else {
                content
                NavigationLinkWrapperView(isActive: $isActive, destination: navigationDestination)
            }
            NavigationStorageActionItemView<Destination>(isActive: $isActive, identifier: identifier, param: param)
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
        if let value = value?.wrappedValue {
            let name = paramName ?? identifier
            return NavigationParameter(name: name, value: "\(value)")
        } else {
            return nil
        }
    }

    private var navigationDestination: Destination? {
        guard let item = item.wrappedValue else {
            return nil
        }

        return viewDestination(destination(item))
    }
}

extension View {
    func navigation<Item: Equatable, Value: Equatable, Destination: View>(
        item: Binding<Item?>,
        value: Binding<Value?>?,
        id: NavigationID? = nil,
        paramName: String? = nil,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        let identifier = Destination.identifier(id)
        staticCheckDestination(item: item, id: identifier, paramName: paramName, destination: destination)
        return modifier(NavigationItemModifier(item: item, value: value, identifier: identifier, paramName: paramName, destination: destination))
    }
}

public extension View {
    func navigation<Item: Equatable, Destination: View>(
        item: Binding<Item?>,
        id: NavigationID? = nil,
        paramName: String? = nil,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        navigation(item: item, value: item, id: id, paramName: paramName, destination: destination)
    }
}
