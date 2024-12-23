//
//  NavigationModifier+Action.swift
//  SUINavigation
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI

public extension View {
    func navigationAction<Destination: View>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        @ViewBuilder destination: () -> Destination,
        action: @escaping NavigateUrlParamsHandler
    ) -> some View {
        self
            .navigation(isActive: isActive, id: id, destination: destination)
            .navigateUrlParams(id?.stringValue ?? Destination.navigationID.stringValue, action: action)
    }

    func navigationAction<Destination: View>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        self
            .navigationAction(isActive: isActive, id: id, destination: destination) { _ in
                isActive.wrappedValue = true
            }
    }
}
