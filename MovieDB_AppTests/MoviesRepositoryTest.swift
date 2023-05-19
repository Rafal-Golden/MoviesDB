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
    private var dummyError: NSError!
    private var dummyMovieResults: MovieResults!
    private var dummyAPIConfig: APIConfig!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        serviceMock = MoviesServiceMock()
        dummyError = CoreTests.NSErrors.generalError
        dummyMovieResults = CoreTests.Movies.sampleNowPlayingResults
        dummyAPIConfig = CoreTests.API.sampleApiConfig
        
        sut = MoviesRepository(service: serviceMock)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
        
        serviceMock = nil
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
}
