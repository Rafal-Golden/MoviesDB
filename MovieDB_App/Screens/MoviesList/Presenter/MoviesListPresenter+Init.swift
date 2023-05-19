//
//  MoviesListPresenter+Init.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import Foundation

extension MoviesListPresenter {
    
    convenience init(ui: MoviesListInterfaceIn, coordinator: Coordinator) {
        let moviesRepository = AppMainModule.injectMoviesRepository()
        self.init(ui: ui, coordinator: coordinator, moviesRepository: moviesRepository)
    }
}
