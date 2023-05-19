//
//  MovieDetailsPresenter+Init.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 19/05/2023.
//

import Foundation

extension MovieDetailsPresenter {
    
    convenience init(ui: MovieDetailsInterfaceIn, coordinator: Coordinator, input: MovieDetailsInput) {
        let moviesRepository = AppMainModule.injectMoviesRepository()
        self.init(ui: ui, coordinator: coordinator, input: input, moviesRepository: moviesRepository)
    }
}
