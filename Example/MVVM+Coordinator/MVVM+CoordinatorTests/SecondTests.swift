//
//  SecondTests.swift
//  MVVM+RouterTests
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import XCTest
@testable import MVVM_Coordinator

final class SecondCoordinatorMock: SecondCoordinatorProtocol {
    var secondViewModel: SecondViewModel

    var isShowingLast: Bool = false

    init(_secondViewModel: SecondViewModelType) {
        self.secondViewModel = _secondViewModel
    }
}

final class SecondTests: XCTestCase {

    func testSecondToLast() throws {
        let secondViewModel = SecondViewModel(value: 10)
        let secondCoordinator = SecondCoordinatorMock(secondViewModel: secondViewModel)
        XCTAssertFalse(secondCoordinator.isShowingLast)
        secondViewModel.lastAction()
        XCTAssertTrue(secondCoordinator.isShowingLast)
    }

}
