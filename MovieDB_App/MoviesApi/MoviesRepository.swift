//
//  MoviesRepository.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 17/05/2023.
//

import Foundation

protocol MoviesRepositoryProtocol {
    func getNowPlayingMovies(language: String, page: Int, completion: @escaping (Result<MovieResults, NSError>) -> Void)
    
    func getAPIConfig(completion: @escaping (Result<APIConfig, NSError>) -> Void)
}

class MoviesRepository: MoviesRepositoryProtocol {
    
    let service: MoviesServiceProtocol
    
    init(service: MoviesServiceProtocol) {
        self.service = service
    }
    
    func getNowPlayingMovies(language: String, page: Int, completion: @escaping (Result<MovieResults, NSError>) -> Void) {
        service.requestNowPlayingMovies(language: language, page: page, completion: completion)
    }
    
    func getAPIConfig(completion: @escaping (Result<APIConfig, NSError>) -> Void) {
        service.requestAPIConfig(completion: completion)
    }
}
