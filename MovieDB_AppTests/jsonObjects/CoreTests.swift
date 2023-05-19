//
//  CoreTests.swift
//  MovieDB_AppTests
//
//  Created by Rafal Korzynski on 17/05/2023.
//

import XCTest

@testable import MovieDB_App

struct CoreTests {
    struct NSErrors {
        static let unknown = NSError(domain: "Unknown domain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Unknown description"])
        static let generalError = NSError(domain: "UnitTest.Error", code: 111, userInfo: [NSLocalizedDescriptionKey: "General Error used for unit testing"])
    }
    
    struct Movies {
        static let sampleNowPlayingResults: MovieResults = decodeObject(fileName: "obj_movie_results")
    }
    
    struct API {
        static let sampleApiConfig: APIConfig = decodeObject(fileName: "obj_api_config")
    }
}

extension CoreTests {
    
    class DummyClass {}
    
    static func decodeObject<T: Codable>(fileName: String) -> T
    {
        do
        {
            let data = try dataFromFile(fileName)
            return try JSONDecoder().decode(T.self, from: data)
        }
        catch(let error)
        {
            XCTFail("Test error : Failed during decoding dummy object from JSON!")
            fatalError("Failed during decoding dummy object from JSON! Error \(error)")
        }
    }
    
    
    static func dataFromFile(_ fileName: String) throws -> Data
    {
        let url = Bundle(for: DummyClass.self).url(forResource: fileName, withExtension: "json")!
        
        return try Data(contentsOf: url)
    }
}
