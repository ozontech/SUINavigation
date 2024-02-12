//
//  FirstTests.swift
//  MVVM+RouterTests
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import XCTest
@testable import MVVM_Router

struct FirstInteractorMock: FirstInteractorProtocol {
    var secondValue: Int
}

final class FirstTests: XCTestCase {

    func testFirstToSecondTransition() throws {
        let firstInteractor = FirstInteractorMock(secondValue: 123)
        let firstViewModel = FirstViewModel(interactor: firstInteractor)
        let firstRouter = firstViewModel.router
        XCTAssertNotNil(firstInteractor.secondValue)
        XCTAssertNil(firstRouter.navigationState)
        firstViewModel.secondAction()
        XCTAssertNotNil(firstRouter.navigationState)
        if case .second(let value) = firstRouter.navigationState {
            XCTAssertEqual(value, firstInteractor.secondValue)
        } else {
            XCTFail()
        }
    }

}
