//
//  NavigationModifier.swift
//
//
//  Created by Sergey Balalaev on 23.10.2023.
//

import SwiftUI

struct NavigationModifier<Destination: View>: ViewModifier {
    let isActive: Binding<Bool>
    let id: NavigationID?
    let destination: Destination?

#if DEBUG

    @Environment(\.catchView)
    private var catchViewDestination: (_ view: any View) -> Void

    func viewDestination(_ view: Destination?) -> Destination? {
        if let view = view {
            catchViewDestination(view)
        }
        return view
    }

#else

    @inlinable
    func viewDestination(_ view: Destination?) -> Destination? {
        return view
    }

#endif

    init(isActive: Binding<Bool>, id: NavigationID?, destination: Destination?) {
        self.isActive = isActive
        self.id = id
        self.destination = destination
    }

    func body(content: Content) -> some View {
        ZStack {
            if #available(iOS 16.0, *) {
                content
                    .navigationDestination(isPresented: isActive, destination: {viewDestination(destination)})
            } else {
                content
                NavigationLinkWrapperView(isActive: isActive, destination: viewDestination(destination))
            }
            NavigationStorgeActionItemView<Destination>(isActive: isActive, id: id)
        }
    }
}

public extension View {
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        modifier(NavigationModifier(isActive: isActive, id: id, destination: isActive.wrappedValue ? destination() : nil))
    }
}
