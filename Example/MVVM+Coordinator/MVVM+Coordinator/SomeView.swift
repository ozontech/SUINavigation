//
//  SomeView.swift
//  MVVM+Router
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import SwiftUI
import SUINavigation

struct SomeView<SecondCoordinatorType: SecondCoordinatorProtocol>: View {

    @ObservedObject
    private var secondCoordinator: SecondCoordinatorType

    init(secondCoordinator: SecondCoordinatorType) {
        self.secondCoordinator = secondCoordinator
    }

    var body: some View {
        Button("Go to First") {
            secondCoordinator.secondViewModel.firstCoordinator?.toFirst()
        }
        Button("Go to SecondView") {
            secondCoordinator.secondViewModel.value = 10
            secondCoordinator.dismissLast()
        }
        Button("Go to Root") {
            secondCoordinator.secondViewModel.firstCoordinator?.toRoot()
        }
        Button("Skip First") {
            secondCoordinator.secondViewModel.firstCoordinator?.navigationStorage?.skip("first")
        }
        Button("Skip Second") {
            secondCoordinator.secondViewModel.firstCoordinator?.navigationStorage?.skip("second")
        }
    }
}
