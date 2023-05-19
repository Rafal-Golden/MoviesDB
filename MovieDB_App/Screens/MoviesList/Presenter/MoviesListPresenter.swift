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
    weak var ui: MoviesListInterfaceIn!
    var coordinator: Coordinator!
    
    private(set) var moviesModel: MoviesModel
    
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
        configureObserver()
    }
    
    // MARK: MoviesListInterfaceOut
    
    func didLoad() {
        didLoadedSubject.send(true)
    }
    
    func didSelectedCell(index: Int) {
        guard moviesModel.inputs.count > index && index >= 0 else { return }
        
        var input = moviesModel.inputs[index]
        input.isFavourite = moviesRepository.isFavourite(movieId: input.id)
        coordinator.navigate(to: .movieDetails(input: input))
    }
    
    func selectedButton(favourite: Bool, movieId: Int) {
        moviesRepository.markAs(favourite: favourite, movieId: movieId) { _ in }
    }
    
    func loadNextPage() {
        guard configImages != nil else { return }
        
        self.ui.startLoading()
        let currPage = moviesModel.currentPage + 1
        
        moviesRepository.getNowPlayingMovies(language: languageCode, page: currPage) { [weak self] result in
            guard let self else { return }
            
            if let moviesResults = try? result.get() {
                self.refreshNowPlayingList(moviesResults: moviesResults)
            } else {
                self.ui.refreshList()
            }
        }
    }
    
    // MARK: private
    
    private func configureObserver() {
        NotificationCenter.default.publisher(for: .movieDetailsInputUpdated).sink { [weak self] notif in
            if let movieDetailsInput = notif.object as? MovieDetailsInput {
                self?.refreshNowPlayingListForInput(movieDetailsInput)
            }
        }.store(in: &cancellables)
    }
    
    private func getAPIConfig() {

        self.$configImages.combineLatest(didLoadedSubject).sink(receiveValue: { [weak self] (newConfigImages, didLoaded) in
            if newConfigImages != nil, didLoaded == true {
                self?.getNowPlaying()
            }
        }).store(in: &cancellables)
        
        moviesRepository.getAPIConfig { [weak self] result in
            if let apiConfig = try? result.get() {
                self?.configImages = apiConfig.images
            }
        }
    }
    
    private func getNowPlaying() {
        
        self.ui.startLoading()
        
        moviesRepository.getNowPlayingMovies(language: languageCode, page: 1) { [weak self] result in
            switch result {
                case .success(let moviesResults):
                    self?.refreshNowPlayingList(moviesResults: moviesResults)
                    
                case .failure(_):
                    self?.refreshNowPlayingList(moviesModel: .empty)
            }
        }
    }
    
    private func refreshNowPlayingList(moviesResults: MovieResults) {
        guard let configImages else { print("config images missing!"); return }
        
        let baseImageURL = URL(string: configImages.secureBaseUrl)
        let posterSizes = configImages.posterSizes
        
        let model = self.moviesModel.appending(movieResults: moviesResults, baseURL: baseImageURL, posterSizes: posterSizes)
        
        for i in 0..<model.items.count {
            let id = model.items[i].id
            model.items[i].isFavourite = moviesRepository.isFavourite(movieId: id)
        }
        
        refreshNowPlayingList(moviesModel: model)
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
    
    private func refreshNowPlayingListForInput(_ input: MovieDetailsInput) {
        guard let selectedItem = moviesModel.items.filter({ $0.id == input.id }).first else { return }
                
        selectedItem.isFavourite = input.isFavourite
        
        self.ui.refreshList()
    }
}
