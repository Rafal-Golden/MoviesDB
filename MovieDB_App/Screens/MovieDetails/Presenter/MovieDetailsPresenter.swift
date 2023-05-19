//
//  MovieDetailsPresenter.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18-5-2023.
//

import Foundation

class MovieDetailsPresenter: MovieDetailsInterfaceOut
{
    weak var ui: MovieDetailsInterfaceIn!
    var coordinator: Coordinator!
    
    var input: MovieDetailsInput
    let moviesRepository: MoviesRepositoryProtocol

    init(ui: MovieDetailsInterfaceIn, coordinator: Coordinator, input: MovieDetailsInput, moviesRepository: MoviesRepositoryProtocol) {
        self.ui = ui
        self.coordinator = coordinator
        self.input = input
        self.moviesRepository = moviesRepository
    }
    
    // MARK: MovieDetailsInterfaceOut
    
    func didLoad() {
        refreshUsing(input: input)
    }
    
    func goBackAction() {
        coordinator.navigate(to: .back)
    }
    
    func markAsFavourite(_ favourite: Bool) {
        moviesRepository.markAs(favourite: favourite, movieId: input.id) { _ in }
        input.isFavourite = favourite
        
        NotificationCenter.default.post(name: .movieDetailsInputUpdated, object: input)
    }
    
    private func refreshUsing(input: MovieDetailsInput) {
        let userRateText = NSLocalizedString("User rate: ", comment: "") + "\(input.averageRate)"
        
        let model = MovieDetailsViewModel(id: input.id,
                                          title: input.title,
                                          overview: input.overview,
                                          releaseText: input.releaseDate,
                                          userRateText: userRateText,
                                          isFavourite: input.isFavourite)
        
        self.ui.refreshMovie(model: model)
        
        let imageDownloader = ImageDownloader(url: input.posterUrl)
        imageDownloader.download(completed: { [weak self] image in
            if let self, let image {
                self.ui.refreshMoviePoster(image: image)
            }
        })
    }
}
