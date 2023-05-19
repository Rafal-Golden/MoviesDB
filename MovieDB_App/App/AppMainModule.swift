//
//  AppMainModule.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import Foundation

class AppMainModule {
    
    class func injectMoviesRepository() -> MoviesRepositoryProtocol {
        let service = MoviesService()
        return MoviesRepository(service: service)
    }
}
