//
//  SecondView.swift
//  MVVM+Router
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import SwiftUI
import SUINavigation

enum SecondDestination: NavigationDestination {
    case some(currentValue: Binding<Int>)
}

extension SecondDestination {

    static func == (lhs: SecondDestination, rhs: SecondDestination) -> Bool {
        true
    }

    var destination: some View {
        switch self {
        case .some(let currentValue):
            SomeView(secondValue: currentValue)
        }
    }
}

protocol SecondRouterProtocol: NavigationRouterProtocol where NavigationDestinationType == SecondDestination {
    func last(currentValue: Binding<Int>)
}

extension SecondRouterProtocol {
    func last(currentValue: Binding<Int>) {
        navigate(to: .some(currentValue: currentValue))
    }
}

final class SecondRouter : NavigationRouter<SecondDestination>, SecondRouterProtocol {}

protocol SecondViewModelProtocol: ObservableObject {
    associatedtype Router: SecondRouterProtocol
    var router: Router {get}

    var value: Int {get set}

    func lastAction()
}

final class SecondViewModel<Router: SecondRouterProtocol> : SecondViewModelProtocol {

    @Published
    var value: Int

    var router: Router

    init(value: Int, router: Router = SecondRouter()) {
        self.value = value
        self.router = router
    }

    func lastAction() {
        router.last(
            currentValue: Binding<Int>(
                get: { self.value },
                set: { self.value = $0 }
            )
        )
    }
}

// for routing
struct SecondView<ViewModel: SecondViewModelProtocol>: View {

    @StateObject
    private var viewModel: ViewModel

    init(value: Int) where ViewModel == SecondViewModel<SecondRouter> {
        _viewModel = StateObject(wrappedValue: SecondViewModel(value: value))
    }

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Second")
            Text("\(viewModel.value)")
            Button("to Last"){
                viewModel.lastAction()
            }
        }.router(router: viewModel.router)
    }
}


