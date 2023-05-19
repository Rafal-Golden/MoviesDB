//
//  MoviesListPresenter.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 17-5-2023.
//

import Foundation
import Combine

class MoviesListPresenter: MoviesListInterfaceOut
{
    var moviesModel: MoviesModel
    
    weak var ui: MoviesListInterfaceIn!
    var coordinator: Coordinator!
    
    private var languageCode = "en-US"
    private var moviesRepository: MoviesRepositoryProtocol
    
    @Published private(set) var configImages: APIConfigImages?
    private var didLoadedSubject = PassthroughSubject<Bool, Never>()
    private var cancellables: Set<AnyCancellable> = []

    init(ui: MoviesListInterfaceIn, coordinator: Coordinator, moviesRepository: MoviesRepositoryProtocol) {
        self.ui = ui
        self.coordinator = coordinator
        self.moviesRepository = moviesRepository
        
        self.moviesModel = MoviesModel.empty
        
        getAPIConfig()
    }
    
    // MARK: MoviesListInterfaceOut
    
    func didLoad() {
        didLoadedSubject.send(true)
    }
    
    func didSelectedCell(index: Int) {
        let input = moviesModel.inputs[index]
        coordinator.navigate(to: .movieDetails(input: input))
    }
    
    private func getAPIConfig() {

        self.$configImages.combineLatest(didLoadedSubject).sink(receiveValue: { [weak self] (newConfigImages, didLoaded) in
            if let newConfigImages, didLoaded == true {
                self?.getNowPlaying(configImages: newConfigImages)
            }
        }).store(in: &cancellables)
        
        moviesRepository.getAPIConfig { [weak self] result in
            if let apiConfig = try? result.get() {
                self?.configImages = apiConfig.images
            }
        }
    }
    
    private func getNowPlaying(configImages: APIConfigImages) {
        
        let baseImageURL = URL(string: configImages.secureBaseUrl)
        let posterSizes = configImages.posterSizes
        
        moviesRepository.getNowPlayingMovies(language: languageCode, page: 1) { [weak self] result in
            print("presenter result \(result)")
            switch result {
                case .success(let moviesResults):
                    self?.refreshNowPlayingList(moviesModel: MoviesModel(movieResults: moviesResults, baseURL: baseImageURL, posterSizes: posterSizes))
                    
                case .failure(_):
                    self?.refreshNowPlayingList(moviesModel: .empty)
            }
        }
    }
    
    private func refreshNowPlayingList(moviesModel: MoviesModel) {
        self.moviesModel = moviesModel
        
        self.ui.setTitle(NSLocalizedString("Now playing", comment: ""))
        self.ui.refreshList()
        
        if moviesModel.items.isEmpty {
            let message = NSLocalizedString("Sorry, we could not find any movies playing now.", comment: "")
            self.ui.showFailureInfo(message: message)
        }
    }
}
