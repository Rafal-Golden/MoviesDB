//
//  MovieResults.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 17/05/2023.
//

import Foundation

public struct MovieResults: Codable, Equatable {
    var dates: [String: String]
    var page: Int
    var results: [MovieItem]
    var totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

public struct MovieItem: Codable, Equatable {
    var id: Int
    var adult: Bool
    var title: String
    var overview: String
    var voteAverage: Double
    var releaseDate: String
    var posterPath: String
    var backdropPath: String
    var genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, adult, title, overview
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
