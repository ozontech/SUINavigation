//
//  NavigationBindingModifier+Action.swift
//  SUINavigation
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI

public extension View {
    func navigationAction<DestinationValue: Equatable>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        componentName: String? = nil,
        destinationValue: DestinationValue,
        action: @escaping NavigateUrlParamsHandler
    ) -> some View {
        self
            .navigation(isActive: isActive, id: id, destinationValue: destinationValue)
            .navigateUrlParams(id?.stringValue ?? componentName ?? (destinationValue as? NavigationID)?.stringValue ?? "\(destinationValue)", action: action)
    }

    func navigationAction<DestinationValue: Equatable>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        componentName: String? = nil,
        destinationValue: DestinationValue
    ) -> some View {
        self
            .navigationAction(isActive: isActive, id: id, componentName: componentName, destinationValue: destinationValue) { _ in
                isActive.wrappedValue = true
            }
    }

    func navigationAction<DestinationValue: Equatable>(
        isActive: Binding<Bool>,
        id: NavigationID? = nil,
        componentName: String? = nil,
        destinationValue: @escaping () -> DestinationValue
    ) -> some View {
        self.navigationAction(isActive: isActive, id: id, componentName: componentName, destinationValue: destinationValue())
    }
}
