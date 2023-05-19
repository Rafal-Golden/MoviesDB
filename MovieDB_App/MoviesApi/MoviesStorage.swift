//
//  MoviesStorage.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 19/05/2023.
//

import Foundation

protocol MoviesStorageProtocol {
    func markAs(favourite: Bool, movieId: Int)
    func isFavourite(movieId: Int) -> Bool
}

class MoviesStorage: MoviesStorageProtocol {
    
    private let favouriteMoviesDictKey = "FavouriteMoviesDictKey"
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func markAs(favourite: Bool, movieId: Int) {
        var favouriteMoviesDict = userDefaults.dictionary(forKey: favouriteMoviesDictKey) as? [String : Bool] ?? [:]
        favouriteMoviesDict["\(movieId)"] = favourite
        
        userDefaults.set(favouriteMoviesDict, forKey: favouriteMoviesDictKey)
    }
    
    func isFavourite(movieId: Int) -> Bool {
        var favouriteMoviesDict = userDefaults.dictionary(forKey: favouriteMoviesDictKey) as? [String : Bool] ?? [:]
        return favouriteMoviesDict["\(movieId)"] == true
    }
}
