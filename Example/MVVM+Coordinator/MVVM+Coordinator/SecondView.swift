//
//  SecondView.swift
//  MVVM+Router
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import SwiftUI
import SUINavigation

protocol SecondCoordinatorProtocol: ObservableObject {
    associatedtype SecondViewModelType: SecondViewModelProtocol

    var secondViewModel: SecondViewModelType {set get}

    var isShowingLast: Bool {set get}

    func last()

    func dismissLast()

    init(_secondViewModel: SecondViewModelType)
}

extension SecondCoordinatorProtocol {
    func last() {
        isShowingLast = true
    }

    func dismissLast() {
        isShowingLast = false
    }

    init(secondViewModel: SecondViewModelType) {
        self.init(_secondViewModel: secondViewModel)
        secondViewModel.secondCoordinator = self
    }
}

final class SecondCoordinator<SecondViewModelType: SecondViewModelProtocol> : SecondCoordinatorProtocol {

    // Not null value trigger navigation transition to SecondView with this value, nil value to dissmiss to this View.
    @Published
    var isShowingLast: Bool = false

    @Published
    var secondViewModel: SecondViewModelType

    init(_secondViewModel: SecondViewModelType) {
        self.secondViewModel = _secondViewModel
    }
}

protocol SecondViewModelProtocol: ObservableObject, Equatable {
    var firstCoordinator: (any FirstCoordinatorProtocol)? {get}
    var secondCoordinator: (any SecondCoordinatorProtocol)? {get set}
    var value: Int {get set}
    func lastAction()
}

extension SecondViewModelProtocol {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs && lhs.value == rhs.value
    }
}

final class SecondViewModel : SecondViewModelProtocol {

    @Published
    var value: Int

    weak var firstCoordinator: (any FirstCoordinatorProtocol)? = nil
    weak var secondCoordinator: (any SecondCoordinatorProtocol)? = nil

    init(value: Int, firstCoordinator: (any FirstCoordinatorProtocol)? = nil) {
        self.value = value
        self.firstCoordinator = firstCoordinator
    }

    func lastAction() {
        secondCoordinator?.last()
    }
}

// for routing
struct SecondView<Coordinator: SecondCoordinatorProtocol>: View {

    @StateObject
    private var coordinator: Coordinator

    init<ViewModel: SecondViewModelProtocol>(viewModel: ViewModel) where Coordinator == SecondCoordinator<ViewModel> {
        _coordinator = StateObject(wrappedValue: SecondCoordinator(secondViewModel: viewModel))
    }

    var body: some View {
        SecondContentView(viewModel: coordinator.secondViewModel)
            .navigation(isActive: $coordinator.isShowingLast, id: "last"){
                SomeView(secondCoordinator: coordinator)
            }
    }
}

struct SecondContentView<ViewModel: SecondViewModelProtocol>: View {

    @ObservedObject
    private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("Second")
            Text("\(viewModel.value)")
            Button("to Last"){
                viewModel.lastAction()
            }
        }
    }
}
