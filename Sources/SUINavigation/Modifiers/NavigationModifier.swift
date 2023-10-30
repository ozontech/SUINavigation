//
//  NavigationModifier.swift
//
//
//  Created by Sergey Balalaev on 23.10.2023.
//

import SwiftUI

struct NavigationModifier<Destination: View>: ViewModifier {
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
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        modifier(NavigationModifier(id: id, destination: isActive.wrappedValue ? destination() : nil, isActive: isActive))
    }
}
