//
//  MoviesModel.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import Foundation

struct MoviesItemCellModel {
    var id: Int
    var title: String
    var releaseDate: String
    var imageURL: URL?
}

struct MoviesModel {
    var items: [MoviesItemCellModel]
    var inputs: [MovieDetailsInput]
    var currentPage: Int
    var shouldLoadNextPage: Bool = true
    
    init(items: [MoviesItemCellModel], currentPage: Int=1) {
        self.items = items
        self.currentPage = currentPage
        self.inputs = []
    }
    
    init(movieResults: MovieResults, baseURL: URL?, posterSizes: [String]) {
        self.items = movieResults.results.map {
            let baseImageURL = baseURL?.appendingPathComponent(posterSizes.first ?? "")
            let imageURL = baseImageURL?.appendingPathComponent($0.posterPath)
            return MoviesItemCellModel(id: $0.id, title: $0.title, releaseDate: $0.releaseDate, imageURL: imageURL)
        }
        self.inputs = movieResults.results.map {
            let baseImageURL = baseURL?.appendingPathComponent(posterSizes.last ?? "")
            let posterURL = baseImageURL?.appendingPathComponent($0.posterPath)
            return MovieDetailsInput(id: $0.id, title: $0.title, overview: $0.overview, posterUrl: posterURL)
        }
        self.currentPage = movieResults.page
        self.shouldLoadNextPage = movieResults.totalPages > movieResults.page
    }
    
    static let empty = MoviesModel(items: [])
}
