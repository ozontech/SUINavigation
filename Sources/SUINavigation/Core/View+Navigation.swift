//
//  View+Navigation.swift
//
//
//  Created by Sergey Balalaev on 29.03.2022.
//

import SwiftUI

private struct NavigationLinkWrapperView<Destination: View>: View {
    let destination: Destination?
    let isActive: Binding<Bool>
    let navigationStorage: NavigationStorage?
    let identifier: String?

    @State
    private var uid: String? = nil

    init(id: NavigationID? = nil, destination: Destination?, isActive: Binding<Bool>, navigationStorage: NavigationStorage?) {
        self.destination = destination
        self.isActive = isActive
        self.navigationStorage = navigationStorage
        self.identifier = id?.rawValue ?? Destination.navigationID
    }

    @ViewBuilder
    var breakView: some View {
        // hacking for supporting iOS 14.5 : https://developer.apple.com/forums/thread/677333
        // better use iOS 16 too with NavigationStack
        if #available(iOS 15.0, *) {
            EmptyView().hidden()
        } else {
            NavigationLink(destination: EmptyView()) {
                EmptyView()
            }.hidden()
        }
    }

    var body: some View {
        breakView
        NavigationLink(
            destination: destination,
            isActive: isActive
        ) {
            EmptyView()
        }
        // bug from Apple: when change screen
        // - dismiss to First View
        // https://developer.apple.com/forums/thread/667460
        .isDetailLink(false)
        .onChange(of: isActive.wrappedValue) { newValue in
            if let identifier = identifier, let navigationStorage = navigationStorage {
                if newValue {
                    uid = navigationStorage.addItem(isPresented: isActive, id: identifier)
                } else {
                    navigationStorage.removeItem(isPresented: isActive, id: identifier, uid: uid)
                }
            }
        }
        .hidden()
        breakView
    }
}

private struct NavigationItemModifier<Destination: View, Item: Equatable>: ViewModifier {
    var item: Binding<Item?>

    @ViewBuilder var destination: (Item) -> Destination

    @Binding var isActive: Bool

    var id: NavigationID?

    @OptionalEnvironmentObject var navigationStorage: NavigationStorage?

    init(id: NavigationID?, item: Binding<Item?>, @ViewBuilder destination: @escaping (Item) -> Destination) {
        self.id = id
        self.item = item
        self.destination = destination
        _isActive = .init(
            get: { item.wrappedValue != nil },
            set: { newValue in
                if !newValue {
                    item.wrappedValue = nil
                }
            }
        )
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            NavigationLinkWrapperView(
                id: id,
                destination: navigationDestination,
                isActive: $isActive,
                navigationStorage: navigationStorage
            )
        }
    }

    private var navigationDestination: Destination? {
        guard let item = item.wrappedValue else {
            return nil
        }

        return destination(item)
    }
}

private struct NavigationModifier<Destination: View>: ViewModifier {
    let destination: Destination?
    let isActive: Binding<Bool>

    var id: NavigationID?

    @OptionalEnvironmentObject var navigationStorage: NavigationStorage?

    init(id: NavigationID?, destination: Destination?, isActive: Binding<Bool>) {
        self.id = id
        self.destination = destination
        self.isActive = isActive
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            NavigationLinkWrapperView(
                id: id,
                destination: isActive.wrappedValue ? destination : nil,
                isActive: isActive,
                navigationStorage: navigationStorage
            )
        }
    }
}

public extension View {
    func navigation<Item: Equatable, Destination: View>(
        item: Binding<Item?>,
        id: NavigationID? = nil,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        modifier(NavigationItemModifier(id: id, item: item, destination: destination))
    }

    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        modifier(NavigationModifier(id: id, destination: isActive.wrappedValue ? destination() : nil, isActive: isActive))
    }
}
