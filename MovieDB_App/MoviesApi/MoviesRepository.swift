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
    
    func markAs(favourite: Bool, movieId: Int, completion: @escaping (Bool) -> Void)
    func isFavourite(movieId: Int) -> Bool
}

class MoviesRepository: MoviesRepositoryProtocol {
    
    let service: MoviesServiceProtocol
    let storage: MoviesStorageProtocol
    
    init(service: MoviesServiceProtocol, storage: MoviesStorageProtocol) {
        self.service = service
        self.storage = storage
    }
    
    func getNowPlayingMovies(language: String, page: Int, completion: @escaping (Result<MovieResults, NSError>) -> Void) {
        service.requestNowPlayingMovies(language: language, page: page, completion: completion)
    }
    
    func getAPIConfig(completion: @escaping (Result<APIConfig, NSError>) -> Void) {
        service.requestAPIConfig(completion: completion)
    }
    
    func markAs(favourite: Bool, movieId: Int, completion: @escaping (Bool) -> Void) {
        storage.markAs(favourite: favourite, movieId: movieId)
        completion(true)
    }
    
    func isFavourite(movieId: Int) -> Bool {
        let isFavourite = storage.isFavourite(movieId: movieId)
        return isFavourite
    }
}
