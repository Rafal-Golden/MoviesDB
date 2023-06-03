//
//  ImageDownloaderTests.swift
//  MovieDB_AppTests
//
//  Created by Rafal Korzynski on 03/06/2023.
//

import XCTest
@testable import MovieDB_App

final class ImageDownloaderTests: XCTestCase {

    var sut: ImageDownloader!
    
    private var imageDataTaskMock: ImageDataTaskMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        imageDataTaskMock = ImageDataTaskMock()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
        imageDataTaskMock = nil
    }
    
    // MARK: Mocks
    
    class ImageDataTaskMock: ImageDataTaskProtocol {
        
        enum DownloadDataError: Error {
            case invalidURL
        }
        
        var returnedError: DownloadDataError?
        var returnedData: Data?
        var downloadDataCompleted: Bool = false
        
        func downloadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
            downloadDataCompleted = true
            completion(returnedData, returnedError)
        }
    }
    
    // MARK: Tests
    
    func makeImageDownloader(url: URL?) -> ImageDownloader {
        return ImageDownloader(url: url, imageDataTask: imageDataTaskMock)
    }

    func testImageDownloader_initWithEmptyURL_returnsNil() throws {
        // Given
        let emptyURL: URL? = nil
        var downloadCalled = false
        sut = makeImageDownloader(url: emptyURL)
        
        var returnedImage: UIImage? = nil
        // then
        sut.download { downloadedImage in
            returnedImage = downloadedImage
            downloadCalled = true
        }
        
        // expected
        XCTAssertNil(returnedImage)
        XCTAssertTrue(downloadCalled)
        XCTAssertFalse(imageDataTaskMock.downloadDataCompleted)
    }
    
    func testImageDownloader_initWithInvalidURL_returnsNil() throws {
        // Given
        let invalidURL = URL(string: "http://images.com/invalidUrl")
        var downloadCalled = false
        imageDataTaskMock.returnedError = .invalidURL
        sut = makeImageDownloader(url: invalidURL)
        
        var returnedImage: UIImage? = nil
        // then
        sut.download { downloadedImage in
            returnedImage = downloadedImage
            downloadCalled = true
        }
        
        // expected
        XCTAssertNil(returnedImage)
        XCTAssertTrue(downloadCalled)
        XCTAssertTrue(imageDataTaskMock.downloadDataCompleted)
    }
    
    func testImageDownloader_initWithValidURL_returnsImage() throws {
        // Given
        let validURL = URL(string: "http://images.com/validUrl")
        var downloadCalled = false
        imageDataTaskMock.returnedData = UIImage(systemName: "star")?.pngData()
        sut = makeImageDownloader(url: validURL)
        
        var returnedImage: UIImage? = nil
        // then
        sut.download { downloadedImage in
            returnedImage = downloadedImage
            downloadCalled = true
        }
        
        // expected
        XCTAssertNotNil(returnedImage)
        XCTAssertTrue(downloadCalled)
        XCTAssertTrue(imageDataTaskMock.downloadDataCompleted)
    }

}
