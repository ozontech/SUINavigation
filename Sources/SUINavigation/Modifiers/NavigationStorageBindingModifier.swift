//
//  NavigationStorageBindingModifier.swift
//
//
//  Created by Sergey Balalaev on 22.11.2023.
//

import SwiftUI

typealias NavigationBindingHandler = (_ value: any Equatable) -> any View

private struct ClosureKey: EnvironmentKey {

    static let defaultValue : NavigationBindingHandler = {_ in  return EmptyView() }
}

extension EnvironmentValues {
    var myClosure : (_ value: any Equatable) -> any View {
        get { self[ClosureKey.self] }
        set { self[ClosureKey.self] = newValue }
    }
}

struct NavigationStorageBindingModifier<Destination: View, Item: Equatable>: ViewModifier {
    var data: Item.Type

    @ViewBuilder
    var destination: (Item) -> Destination

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

#if DEBUG

    @Environment(\.catchView)
    private var catchViewDestination: (_ view: any View) -> Void

    @inlinable
    func viewDestination(_ view: any View) -> any View {
        catchViewDestination(view)
        return view
    }

#else

    @inlinable
    func viewDestination(_ view: any View) -> any View {
        return view
    }

#endif

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
        modifier(NavigationStorageBindingModifier(data: data, destination: destination))
    }
}
