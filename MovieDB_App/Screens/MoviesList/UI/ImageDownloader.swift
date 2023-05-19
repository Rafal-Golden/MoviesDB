//
//  ImageDownloader.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import UIKit

class ImageDownloader {
    
    let url: URL?
    
    init(imageUrl: String) {
        self.url = URL(string: imageUrl)
    }
    
    init(url: URL?) {
        self.url = url
    }
    
    func download(completed: @escaping (UIImage?) -> Void) {
        guard let url = self.url else {
            completed(nil)
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { imgData, _, error in
            DispatchQueue.main.async {
                if let imgData, error == nil {
                    completed(UIImage(data: imgData))
                } else {
                    completed(nil)
                }
            }
        }
        task.resume()
    }
}
