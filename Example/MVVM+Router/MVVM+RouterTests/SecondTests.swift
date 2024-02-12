//
//  SecondTests.swift
//  MVVM+RouterTests
//
//  Created by Sergey Balalaev on 07.02.2024.
//

import XCTest
@testable import MVVM_Router

final class SecondRouterMock: SecondRouterProtocol {
    var navigationState: SecondDestination?
}

final class SecondTests: XCTestCase {

    func testSecondToLast() throws {
        let startValue = 11
        let secondRouter = SecondRouterMock()
        let secondViewModel = SecondViewModel(value: startValue, router: secondRouter)
        XCTAssertNil(secondRouter.navigationState)
        secondViewModel.lastAction()
        XCTAssertNotNil(secondRouter.navigationState)
        if case SecondDestination.some(let currentValue) = secondRouter.navigationState! {
            XCTAssertEqual(currentValue.wrappedValue, startValue)
        } else {
            XCTFail()
        }
    }

}
