//
//  NavigateUrlParamsModifier.swift
//
//
//  Created by Sergey Balalaev on 10.10.2023.
//

import SwiftUI

struct NavigateUrlParamsModifier: ViewModifier {

    var urlComponent: String

    var action: NavigateUrlParamsHandler

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    func body(content: Content) -> some View {
        content
            .onAppear{
                navigationStorage?.addChild(urlComponent, action)
            }
    }
}

public extension View {
    func navigateUrlParams(_ urlComponent: String, action: @escaping NavigateUrlParamsHandler) -> some View {
        staticCheckUrlParams(urlComponent, action: action)
        return modifier(NavigateUrlParamsModifier(urlComponent: urlComponent, action: action))
    }
}
