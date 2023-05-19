//
//  AppCoordinatorTest.swift
//  MovieDB_AppTests
//
//  Created by Rafal Korzynski on 17/05/2023.
//

import XCTest
@testable import MovieDB_App

final class AppCoordinatorTest: XCTestCase {
    
    var sut: AppCoordinator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = AppCoordinator()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }

    func testaAppCoordinator_starts_initialiseNavigation() throws {
        // Given
        
        // then
        sut.start()
        
        // expected
        XCTAssertEqual(1, sut.navigationController.viewControllers.count)
    }
    
    func testAppCoordinator_starts_backNavigationNotActive() {
        // given
        var navigationCompleted = false
        // then
        sut.start()
        sut.navigate(to: .back, animated: false) {
            navigationCompleted = true
        }
        
        // expected
        XCTAssertFalse(navigationCompleted)
    }
}
