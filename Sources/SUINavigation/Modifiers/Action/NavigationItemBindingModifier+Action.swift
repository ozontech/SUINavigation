//
//  NavigationItemBindingModifier+Action.swift
//  SUINavigation
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI

public extension View {
    func navigationAction<Item: Equatable, DestinationValue: Equatable>(
        item: Binding<Item?>,
        id: NavigationID,
        paramName: String? = nil,
        destinationValue: @escaping (Item) -> DestinationValue,
        action: @escaping NavigateUrlParamsHandler
    ) -> some View {
        self
            .navigation(item: item, id: id, paramName: paramName, destinationValue: destinationValue)
            .navigateUrlParams(id.stringValue, action: action)
    }



    func navigationAction<Item: Equatable, DestinationValue: Equatable>(
        item: Binding<Item?>,
        id: NavigationID,
        paramName: String? = nil,
        isRemovingParam: Bool = false,
        destinationValue: @escaping (Item) -> DestinationValue
    ) -> some View where Item: NavigationParameterValue
    {
        self
            .navigationAction(item: item, id: id, paramName: paramName, destinationValue: destinationValue) { path in
                let paramName = paramName ?? id.stringValue
                item.wrappedValue = isRemovingParam ? path.popParam(paramName) : path.getParam(paramName)
            }
    }
}
