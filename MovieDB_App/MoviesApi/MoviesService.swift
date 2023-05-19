//
//  MoviesService.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 17/05/2023.
//

import Foundation

protocol MoviesServiceProtocol {
    func requestNowPlayingMovies(language: String, page: Int, completion: @escaping (Result<MovieResults, NSError>) -> Void)
    func requestAPIConfig(completion: @escaping (Result<APIConfig, NSError>) -> Void)
}

class MoviesService: MoviesServiceProtocol {
    
    let apiService = APIRequestService()
    
    func requestNowPlayingMovies(language: String, page: Int, completion: @escaping (Result<MovieResults, NSError>) -> Void) {
        
        let queryParams = [
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let urlPath = "https://api.themoviedb.org/3/movie/now_playing"
        let request = apiService.request(method: "GET", path: urlPath, queryItems: queryParams)
        
        _ = apiService.runJson(request: request, completion: completion)
    }
    
    func requestAPIConfig(completion: @escaping (Result<APIConfig, NSError>) -> Void) {
        let urlPath = "https://api.themoviedb.org/3/configuration"
        let request = apiService.request(method: "GET", path: urlPath, queryItems: [])
        
        _ = apiService.runJson(request: request, completion: completion)
    }
}
