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
    
    let input: MovieDetailsInput

    init(ui: MovieDetailsInterfaceIn, coordinator: Coordinator, input: MovieDetailsInput) {
        self.ui = ui
        self.coordinator = coordinator
        self.input = input
    }
    
    // MARK: MovieDetailsInterfaceOut
    
    func didLoad() {
                
        refreshUsing(input: input)
    }
    
    func goBackAction() {
        coordinator.navigate(to: .back)
    }
    
    private func refreshUsing(input: MovieDetailsInput) {
        self.ui.refreshMovie(input: input)
        
        let imageDownloader = ImageDownloader(url: input.posterUrl)
        imageDownloader.download(completed: { [weak self] image in
            if let self, let image {
                self.ui.refreshMoviePoster(image: image)
            }
        })
    }
}
