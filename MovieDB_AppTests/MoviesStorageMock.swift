//
//  MoviesStorageMock.swift
//  MovieDB_AppTests
//
//  Created by Rafal Korzynski on 19/05/2023.
//

import Foundation

@testable import MovieDB_App

class MoviesStorageMock: MoviesStorageProtocol {
    
    var favouriteDict: [Int : Bool] = [:]
    
    var markAsFavouriteCalled = false
    
    func markAs(favourite: Bool, movieId: Int) {
        markAsFavouriteCalled = true
        favouriteDict[movieId] = favourite
    }
    
    var isFavouriteCalled = false
    
    func isFavourite(movieId: Int) -> Bool {
        isFavouriteCalled = true
        return favouriteDict[movieId] == true
    }
}
