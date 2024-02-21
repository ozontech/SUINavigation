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
    var save: NavigateUrlParamsSaveHandler?

    @OptionalEnvironmentObject
    var navigationStorage: NavigationStorage?

    @State
    private var uid: String? = nil

    func body(content: Content) -> some View {
        content
            .onAppear{
                guard uid == nil else {
                    return
                }
                uid = navigationStorage?.addChild(urlComponent, action, save)
            }
        if let uid {
            let _ = navigationStorage?.updateChild(uid: uid, urlComponent, action, save)
        }
    }
}

public extension View {
    func navigateUrlParams(
        _ urlComponent: String,
        action: @escaping NavigateUrlParamsHandler,
        save: NavigateUrlParamsSaveHandler? = nil
    ) -> some View {
        staticCheckUrlParams(urlComponent, action: action, save: save)
        return navigationModifier(NavigateUrlParamsModifier(urlComponent: urlComponent, action: action, save: save))
    }
}
