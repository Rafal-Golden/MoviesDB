//
//  APIConfig.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import Foundation

struct APIConfigImages: Codable, Equatable {
    var baseUrl: String
    var secureBaseUrl: String
    
    var backdropSizes: [String]
    var logoSizes: [String]
    var posterSizes: [String]
    var profileSizes: [String]
    var stillSizes: [String]
    
    
    enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
        case secureBaseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}

struct APIConfig: Codable, Equatable {
    
    var images: APIConfigImages
    var changeKeys: [String]
    
    enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
}
