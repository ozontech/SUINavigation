//
//  FirstView.swift
//  MVVM+Router
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import SwiftUI
import SUINavigation

enum FirstDestination: NavigationDestination {
    case second(value: Int)
}

extension FirstDestination {
    var destination: some View {
        switch self {
        case .second(let value):
            SecondView(value: value)
        }
    }
}

protocol FirstInteractorProtocol {
    var secondValue: Int {get}
}

struct FirstInteractor: FirstInteractorProtocol {
    let secondValue = 777
}

protocol FirstViewModelProtocol: ObservableObject {
    associatedtype Router: NavigationRouterProtocol
    var router: Router {get}

    func secondAction()
}

final class FirstViewModel : FirstViewModelProtocol {

    var router = NavigationRouter<FirstDestination>()
    var interactor: FirstInteractorProtocol

    init(interactor: FirstInteractorProtocol = FirstInteractor()) {
        self.interactor = interactor
    }

    func secondAction() {
        router.navigate(to: .second(value: interactor.secondValue))
    }
}

// for routing
struct FirstView<ViewModel:FirstViewModelProtocol>: View {

    @StateObject
    private var viewModel: ViewModel

    init() where ViewModel == FirstViewModel {
        _viewModel = StateObject(wrappedValue: FirstViewModel())
    }

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("First")
            Button("to Second"){
                viewModel.secondAction()
            }
        }.router(router: viewModel.router)
    }
}
