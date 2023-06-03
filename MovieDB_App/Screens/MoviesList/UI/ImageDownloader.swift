//
//  ImageDownloader.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import UIKit

protocol ImageDataTaskProtocol {
    func downloadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
}

class ImageDataTask: ImageDataTaskProtocol {
    
    func downloadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { imgData, _, error in
            DispatchQueue.main.async {
                completion(imgData, error)
            }
        }
        task.resume()
    }
}

class ImageDownloader {
    
    let url: URL?
    let imageDataTask: ImageDataTaskProtocol
    
    init(url: URL?, imageDataTask: ImageDataTaskProtocol) {
        self.url = url
        self.imageDataTask = imageDataTask
    }
    
    func download(completed: @escaping (UIImage?) -> Void) {
        guard let url = self.url else {
            completed(nil)
            return
        }
        
        let request = URLRequest(url: url)
        imageDataTask.downloadData(with: request) { imgData, error in
            if let imgData, error == nil {
                completed(UIImage(data: imgData))
            } else {
                completed(nil)
            }
        }
    }
}

extension ImageDownloader {
    
    convenience init(url: URL?) {
        self.init(url: url, imageDataTask: ImageDataTask())
    }
    
    convenience init(imageUrl: String) {
        self.init(url: URL(string: imageUrl))
    }
}
