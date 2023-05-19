//
//  MovieDetailsInput.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import Foundation

struct MovieDetailsInput {
    var id: Int
    var title: String
    var overview: String
    var releaseDate: String
    var averageRate: Double
    var posterUrl: URL?
    var isFavourite: Bool
    
    static let updatedNotificationName = Notification.Name("MovieDetailsInput.Updated")
}

extension Notification.Name {
    static let movieDetailsInputUpdated = MovieDetailsInput.updatedNotificationName
}
