//
//  NavigationBindingModifier.swift
//  
//
//  Created by Sergey Balalaev on 22.11.2023.
//

import SwiftUI

struct NavigationBindingModifier<DestinationValue: Equatable>: ViewModifier {
    let isActive: Binding<Bool>
    let id: NavigationID?
    let value: DestinationValue

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    @State
    private var identifiableView: IdentifiableView? = nil

    init(isActive: Binding<Bool>, id: NavigationID?, value: DestinationValue) {
        self.isActive = isActive
        if id == nil, let navigationID = value as? NavigationID {
            self.id = navigationID
        } else {
            self.id = id
        }
        self.value = value
    }

    func body(content: Content) -> some View {
        content
            .modifier(NavigationItemModifier<AnyView, IdentifiableView, DestinationValue>(item: $identifiableView, value: nil, id: id, paramName: nil, destination: { identifiableView in
                identifiableView.view
            }))
            .onChange(of: isActive.wrappedValue) { isActive in
                if isActive {
                    if let view = navigationStorage?.searchBinding(for: DestinationValue.self)(value) {
                        identifiableView = IdentifiableView(view: view)
                    } else {
                        identifiableView = IdentifiableView(view: EmptyView())
                    }
                }
            }
            .onChange(of: identifiableView) { value in
                if value == nil {
                    isActive.wrappedValue = false
                }
            }
    }
}

public extension View {
    func navigation<DestinationValue: Equatable>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        destinationValue: DestinationValue
    ) -> some View {
        modifier(NavigationBindingModifier(isActive: isActive, id: id, value: destinationValue))
    }

    func navigation<DestinationValue: Equatable>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        destinationValue: @escaping () -> DestinationValue
    ) -> some View {
        modifier(NavigationBindingModifier(isActive: isActive, id: id, value: destinationValue()))
    }
}
