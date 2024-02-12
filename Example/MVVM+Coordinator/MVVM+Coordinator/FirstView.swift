//
//  FirstView.swift
//  MVVM+Router
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import SwiftUI
import SUINavigation

protocol FirstCoordinatorProtocol: ObservableObject {
    associatedtype FirstViewModelType: FirstViewModelProtocol
    associatedtype SecondViewModelType: SecondViewModelProtocol

    var navigationStorage: NavigationStorage? {set get}

    var firstViewModel: FirstViewModelType {set get}
    var secondViewModel: SecondViewModelType? {set get}

    func second(with value: Int)

    func toRoot()

    func toFirst()
}

extension FirstCoordinatorProtocol {
    func second(with value: Int) {
        secondViewModel = SecondViewModel(value: value, firstCoordinator: self) as? SecondViewModelType
    }
}

final class FirstCoordinator<FirstViewModelType: FirstViewModelProtocol, SecondViewModelType: SecondViewModelProtocol> : FirstCoordinatorProtocol {

    @Published
    var firstViewModel: FirstViewModelType

    @Published
    var secondViewModel: SecondViewModelType?

    var navigationStorage: NavigationStorage?

    init(firstViewModel: FirstViewModelType) {
        self.firstViewModel = firstViewModel
        firstViewModel.coordinator = self
    }

    func toRoot(){
        navigationStorage?.popToRoot()
    }

    func toFirst() {
        navigationStorage?.popTo("first")
    }
}

protocol FirstInteractorProtocol {
    var secondValue: Int {get}
}

struct FirstInteractor: FirstInteractorProtocol {
    let secondValue = 777
}

protocol FirstViewModelProtocol: ObservableObject {
    func secondAction()

    var coordinator: (any FirstCoordinatorProtocol)? {get set}
}

final class FirstViewModel : FirstViewModelProtocol {

    var interactor: FirstInteractorProtocol
    weak var coordinator: (any FirstCoordinatorProtocol)? = nil

    init(interactor: FirstInteractorProtocol = FirstInteractor()) {
        self.interactor = interactor
    }

    func secondAction() {
        coordinator?.second(with: interactor.secondValue)
    }
}

// for routing
struct FirstView<Coordinator: FirstCoordinatorProtocol>: View {

    // This optional everywhere, because in a test can use NavigationView without navigationStorage object
    @OptionalEnvironmentObject
    private var navigationStorage: NavigationStorage?

    @StateObject
    private var coordinator: Coordinator

    init() where Coordinator == FirstCoordinator<FirstViewModel, SecondViewModel> {
        _coordinator = StateObject(wrappedValue: FirstCoordinator<FirstViewModel, SecondViewModel>(firstViewModel: FirstViewModel()))
    }

    var body: some View {
        FirstContentView(viewModel: coordinator.firstViewModel)
            .navigation(item: $coordinator.secondViewModel, id: "second"){ secondViewModel in
                SecondView(viewModel: secondViewModel)
            }
            .onAppear{
                coordinator.navigationStorage = navigationStorage
            }
    }
}

struct FirstContentView<ViewModel: FirstViewModelProtocol>: View {

    @ObservedObject
    var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            Text("First")
            Button("to Second"){
                viewModel.secondAction()
            }
        }
    }
}
