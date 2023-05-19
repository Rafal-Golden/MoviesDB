//
//  MovieDB_AppTests.swift
//  MovieDB_AppTests
//
//  Created by Rafal Korzynski on 17/05/2023.
//

import XCTest
@testable import MovieDB_App

final class MoviesRepositoryTest: XCTestCase {
    
    var sut: MoviesRepository!
    
    private var serviceMock: MoviesServiceMock!
    private var storageMock: MoviesStorageMock!
    private var dummyError: NSError!
    private var dummyMovieResults: MovieResults!
    private var dummyAPIConfig: APIConfig!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        serviceMock = MoviesServiceMock()
        storageMock = MoviesStorageMock()
        dummyError = CoreTests.NSErrors.generalError
        dummyMovieResults = CoreTests.Movies.sampleNowPlayingResults
        dummyAPIConfig = CoreTests.API.sampleApiConfig
        
        sut = MoviesRepository(service: serviceMock, storage: storageMock)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
        
        serviceMock = nil
        storageMock = nil
        dummyError = nil
        dummyMovieResults = nil
        dummyAPIConfig = nil
    }

    func testRequestNowPlaying_failure_retunsError() throws {
        // Given
        serviceMock.resultNowPlaying = .failure(dummyError)
        var completed = false
        
        // when
        sut.getNowPlayingMovies(language: "en-US", page: 1, completion: { result in
            switch result {
                case .success(_):
                    break
                    
                case .failure(let error):
                    completed = true
                    XCTAssertEqual(error, self.dummyError)
            }
        })
        
        // Expected results
        XCTAssertTrue(completed)
        XCTAssertTrue(serviceMock.requestNowPlayingMoviesCalled)
    }
    
    func testRequestNowPlaying_success_retunsMovieResults() throws {
        // Given
        serviceMock.resultNowPlaying = .success(dummyMovieResults)
        var completed = false
        
        // when
        sut.getNowPlayingMovies(language: "en-US", page: 1, completion: { result in
            switch result {
                case .success(let result):
                    completed = true
                    XCTAssertEqual(result, self.dummyMovieResults)
                    
                case .failure(_):
                    break
            }
        })
        
        // Expected results
        XCTAssertTrue(completed)
        XCTAssertTrue(serviceMock.requestNowPlayingMoviesCalled)
    }
    
    func testRequestAPIConfig_failure_retunsError() throws {
        // Given
        serviceMock.resultAPIConfig = .failure(dummyError)
        var completed = false
        
        // when
        sut.getAPIConfig { result in
            switch result {
                case .success(_):
                    break
                    
                case .failure(let error):
                    completed = true
                    XCTAssertEqual(error, self.dummyError)
            }
        }
        
        // Expected results
        XCTAssertTrue(completed)
        XCTAssertTrue(serviceMock.requestAPIConfigCalled)
    }
    
    func testRequestAPIConfig_success_retunsAPIConfig() throws {
        // Given
        serviceMock.resultAPIConfig = .success(dummyAPIConfig)
        var completed = false
        
        // when
        sut.getAPIConfig { result in
            switch result {
                case .success(let apiConfig):
                    completed = true
                    XCTAssertEqual(apiConfig, self.dummyAPIConfig)
                    XCTAssertTrue(apiConfig.images.baseUrl.contains("http://"))
                    
                case .failure(_):
                    break
            }
        }
        
        // Expected results
        XCTAssertTrue(completed)
        XCTAssertTrue(serviceMock.requestAPIConfigCalled)
    }
    
    func testMarkAsFavourite_success_savesIdState() throws {
        // Given
        let movieId = 123
        var completed = false
        
        // when
        sut.markAs(favourite: true, movieId: movieId) { success in
            completed = true
            XCTAssertTrue(success)
        }
        
        // Expected results
        XCTAssertTrue(completed)
        XCTAssertTrue(storageMock.markAsFavouriteCalled)
    }
    
    func testIsFavouriteMovie_checkUnmarked_returnsFalseState() throws {
        // Given
        let movieId = 123
        
        // when
        let isFavourite = sut.isFavourite(movieId: movieId)
        
        // Expected results
        XCTAssertFalse(isFavourite)
        XCTAssertTrue(storageMock.isFavouriteCalled)
    }
    
    func testIsFavouriteMovie_checkMarked_returnsTrueState() throws {
        // Given
        let movieId = 100
        
        // when
        sut.markAs(favourite: true, movieId: movieId) { _ in }
        
        let isFavourite = sut.isFavourite(movieId: movieId)
        
        // Expected results
        XCTAssertTrue(isFavourite)
        XCTAssertTrue(storageMock.isFavouriteCalled)
        XCTAssertTrue(storageMock.markAsFavouriteCalled)
    }
}
