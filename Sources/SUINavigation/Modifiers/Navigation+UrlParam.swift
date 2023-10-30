//
//  Navigation+UrlParam.swift
//
//
//  Created by Sergey Balalaev on 19.10.2023.
//

import SwiftUI

/// For flag isActive
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

/// For item binding
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
