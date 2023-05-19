//
//  MoviesServiceMock.swift
//  MovieDB_AppTests
//
//  Created by Rafal Korzynski on 17/05/2023.
//

import Foundation

@testable import MovieDB_App

class MoviesServiceMock: MoviesServiceProtocol {
    
    var resultNowPlaying: Result<MovieResults, NSError> = .failure(CoreTests.NSErrors.unknown)
    var requestNowPlayingMoviesCalled = false
    
    func requestNowPlayingMovies(language: String, page: Int, completion: @escaping (Result<MovieResults, NSError>) -> Void) {
        
        requestNowPlayingMoviesCalled = true
        completion(resultNowPlaying)
    }
    
    var resultAPIConfig: Result<APIConfig, NSError> = .failure(CoreTests.NSErrors.unknown)
    var requestAPIConfigCalled = false
    
    func requestAPIConfig(completion: @escaping (Result<APIConfig, NSError>) -> Void) {
        requestAPIConfigCalled = true
        completion(resultAPIConfig)
    }
}
