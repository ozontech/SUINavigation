//
//  NavigationItemModifier+Action.swift
//  SUINavigation
//
//  Created by Sergey Balalaev on 20.12.2024.
//

import SwiftUI

public extension View {
    func navigationAction<Item: Equatable, Destination: View>(
        item: Binding<Item?>,
        id: NavigationID? = nil,
        paramName: String? = nil,
        @ViewBuilder destination: @escaping (Item) -> Destination,
        action: @escaping NavigateUrlParamsHandler
    ) -> some View {
        self
            .navigation(item: item, id: id, paramName: paramName, destination: destination)
            .navigateUrlParams(id?.stringValue ?? Destination.navigationID.stringValue, action: action)
    }



    func navigationAction<Item: Equatable, Destination: View>(
        item: Binding<Item?>,
        id: NavigationID? = nil,
        paramName: String? = nil,
        isRemovingParam: Bool = false,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View where Item: NavigationParameterValue
    {
        self
            .navigationAction(item: item, id: id, paramName: paramName, destination: destination) { path in
                let paramName = paramName ?? id?.stringValue ?? Destination.navigationID.stringValue
                item.wrappedValue = isRemovingParam ? path.popParam(paramName) : path.getParam(paramName)
            }
    }
}
