//
//  MoviesModel.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import Foundation

class MoviesItemCellModel {
    var id: Int
    var title: String
    var releaseDate: String
    var imageURL: URL?
    var isFavourite: Bool
    
    init(id: Int, title: String, releaseDate: String, imageURL: URL? = nil, isFavourite: Bool) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.imageURL = imageURL
        self.isFavourite = isFavourite
    }
}

struct MoviesModel {
    var items: [MoviesItemCellModel]
    var inputs: [MovieDetailsInput]
    var currentPage: Int
    var shouldLoadNextPage: Bool
    
    init(items: [MoviesItemCellModel], currentPage: Int=1, shouldLoadNextPage: Bool = true, inputs: [MovieDetailsInput]=[]) {
        self.items = items
        self.currentPage = currentPage
        self.inputs = inputs
        self.shouldLoadNextPage = shouldLoadNextPage
    }
    
    init(movieResults: MovieResults, baseURL: URL?, posterSizes: [String]) {
        self.items = movieResults.results.map {
            let baseImageURL = baseURL?.appendingPathComponent(posterSizes.first ?? "")
            let imageURL = baseImageURL?.appendingPathComponent($0.posterPath)
            return MoviesItemCellModel(id: $0.id, title: $0.title, releaseDate: $0.releaseDate, imageURL: imageURL, isFavourite: false)
        }
        self.inputs = movieResults.results.map {
            let baseImageURL = baseURL?.appendingPathComponent(posterSizes.last ?? "")
            let posterURL = baseImageURL?.appendingPathComponent($0.posterPath)
            return MovieDetailsInput(id: $0.id, title: $0.title, overview: $0.overview, releaseDate: $0.releaseDate, averageRate: $0.voteAverage, posterUrl: posterURL, isFavourite: false)
        }
        self.currentPage = movieResults.page
        self.shouldLoadNextPage = movieResults.totalPages > movieResults.page
    }
    
    static let empty = MoviesModel(items: [])
    
    func appending(movieResults: MovieResults, baseURL: URL?, posterSizes: [String]) -> MoviesModel {
        let nextMovieModel = MoviesModel(movieResults: movieResults, baseURL: baseURL, posterSizes: posterSizes)
        var items = self.items
        var inputs = self.inputs
        items.append(contentsOf: nextMovieModel.items)
        inputs.append(contentsOf: nextMovieModel.inputs)
        
        return MoviesModel(items: items, currentPage: nextMovieModel.currentPage, shouldLoadNextPage: nextMovieModel.shouldLoadNextPage, inputs: inputs)
    }
}
