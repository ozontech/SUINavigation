//
//  FirstTests.swift
//  MVVM+RouterTests
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import XCTest
import SUINavigation
@testable import MVVM_Coordinator

struct FirstInteractorMock: FirstInteractorProtocol {
    var secondValue: Int
}

enum FirstCoordinatorState {
    case none
    case root
    case first
}

final class FirstCoordinatorMock: FirstCoordinatorProtocol {
    var state = FirstCoordinatorState.none

    var navigationStorage: SUINavigation.NavigationStorage?
    
    func toRoot() {
        state = .root
    }
    
    func toFirst() {
        state = .first
    }
    
    var firstViewModel: FirstViewModel
    var secondViewModel: SecondViewModel?

    init(firstViewModel: FirstViewModel) {
        self.firstViewModel = firstViewModel
        firstViewModel.coordinator = self
    }
}

final class FirstTests: XCTestCase {

    func testFirstToSecondTransition() throws {
        let firstInteractor = FirstInteractorMock(secondValue: 321)
        let firstViewModel = FirstViewModel(interactor: firstInteractor)
        let firstCoordinator = FirstCoordinatorMock(firstViewModel: firstViewModel)
        XCTAssertNil(firstCoordinator.secondViewModel)
        XCTAssertNotNil(firstInteractor.secondValue)
        firstViewModel.secondAction()
        XCTAssertNotNil(firstCoordinator.secondViewModel)
        XCTAssertEqual(firstCoordinator.secondViewModel?.value, firstInteractor.secondValue)
    }

}
