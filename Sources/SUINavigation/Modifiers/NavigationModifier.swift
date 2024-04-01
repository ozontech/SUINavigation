//
//  NavigationModifier.swift
//
//
//  Created by Sergey Balalaev on 23.10.2023.
//

import SwiftUI

struct NavigationModifier<Destination: View>: ViewModifier {
    let isActive: Binding<Bool>
    let identifier: String
    let destination: Destination?

    init(isActive: Binding<Bool>, identifier: String, destination: Destination?) {
        self.isActive = isActive
        self.identifier = identifier
        self.destination = destination
    }

    func body(content: Content) -> some View {
        ZStack {
            // #available version should be equal version whith using from NavigationViewStorage for trigger using NavigationStack
            if #available(iOS 17.0, *) {
                content
                    .navigationDestination(isPresented: isActive, destination: {viewDestination(destination)})
            } else {
                content
                NavigationLinkWrapperView(isActive: isActive, destination: viewDestination(destination))
            }
            NavigationStorageActionItemView<Destination>(isActive: isActive, identifier: identifier)
        }
    }
}

public extension View {
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        let identifier = Destination.identifier(id)
        staticCheckDestination(isActive: isActive, id: identifier, destination: destination)
        return navigationModifier(NavigationModifier(isActive: isActive, identifier: identifier, destination: isActive.wrappedValue ? destination() : nil))
    }
}
