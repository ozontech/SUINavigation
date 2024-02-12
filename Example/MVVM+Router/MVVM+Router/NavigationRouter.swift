//
//  NavigationRouter.swift
//  MVVM+Router
//
//  Created by Sergey Balalaev on 08.02.2024.
//

import SwiftUI
import SUINavigation

protocol NavigationDestination: Equatable {
    associatedtype Destination: View
    var destination: Destination {get}
}

protocol NavigationRouterProtocol: ObservableObject {
    associatedtype NavigationDestinationType: NavigationDestination
    var navigationState: NavigationDestinationType? {set get}
}

extension NavigationRouterProtocol {
    func navigate(to destination: NavigationDestinationType) {
        navigationState = destination
    }

    func dismiss() {
        navigationState = nil
    }
}

class NavigationRouter<NavigationDestinationType: NavigationDestination> : NavigationRouterProtocol {
    // Not null value trigger navigation transition to SecondView with this value, nil value to dissmiss to this View.
    @Published
    var navigationState: NavigationDestinationType?
}

private struct RouterModifier<Router: NavigationRouterProtocol>: ViewModifier {

    @ObservedObject
    var router: Router

    init(router: Router) {
        self.router = router
    }

    func body(content: Content) -> some View {
        content
            .navigation(item: $router.navigationState) { state in
                state.destination
            }
    }
}

extension View {
    func router<Router: NavigationRouterProtocol>(router: Router) -> some View {
        return navigationModifier(RouterModifier<Router>(router: router))
    }
}
