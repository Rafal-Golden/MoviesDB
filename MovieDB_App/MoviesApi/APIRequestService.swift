//
//  APIRequestService.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 18/05/2023.
//

import Foundation

protocol APIRequestServiceProtocol {
    
    func request(method: String, path: String, queryItems: [URLQueryItem]) -> URLRequest?
    
    func runJson<T: Codable>(request: URLRequest?, completionQueue: DispatchQueue, completion: @escaping (Result<T, NSError>) -> Void) -> URLSessionDataTask?
    
    func cancelAllOperations()
}

class APIRequestService: APIRequestServiceProtocol {
    
    let errorDomain = "APIRequestService.ErrorDomain"
    let headers = [
        "accept": "application/json",
        ]
    let apiKey = "7a8d1472b94885e375641f85d474ee60"
    
    func request(method: String, path: String, queryItems: [URLQueryItem]) -> URLRequest? {
        var urlComponents = URLComponents(string: path)
        var items = queryItems
        items.append(URLQueryItem(name: "api_key", value: apiKey))
        urlComponents?.queryItems = items
        
        guard let url = urlComponents?.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    func runJson<T: Codable>(request: URLRequest?,
                             completionQueue: DispatchQueue = .main,
                             completion: @escaping (Result<T, NSError>) -> Void) -> URLSessionDataTask?
    {
        return runJson(request: request) { result in
            switch result {
            case .success(let data):
                var object: T?
                if let jsonData = data {
                    do {
                        object = try JSONDecoder().decode(T.self, from: jsonData)
                    } catch(let error) {
                        self.log("Parsing error \(error) request \(request?.url?.absoluteString ?? "nil")")
                    }
                }
                completionQueue.async {
                    if let object {
                        completion(.success(object))
                    } else {
                        let parsingError = self.ourError(code: 991, description: "Can not parse response into object!")
                        completion(.failure(parsingError))
                    }
                }
                
                    
            case .failure(let error):
                completionQueue.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func cancelAllOperations() {
        URLSession.shared.invalidateAndCancel()
    }
    
    // MARK: - private
    
    private func ourError(code: Int, description: String) -> NSError {
        return NSError(domain: errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    private func log(_ message: String) {
        #if DEBUG
            print(message)
        #endif
    }
    
    private func runJson(request: URLRequest?, completion: @escaping (Result<Data?, NSError>) -> Void)  -> URLSessionDataTask? {
        guard let request else {
            let error = ourError(code: 990, description: "Request creation failed!")
            completion(.failure(error))
            return nil
        }
        
        log("URL(\(request.httpMethod ?? "nil")) : \(request.url?.absoluteString ?? "")")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                        
            if statusCode == 200 {
                completion(.success(data))
            }
            else {
                if let error = error as? NSError {
                    completion(.failure(error))
                } else {
                    let dataString = data != nil ? String(data: data!, encoding: .utf8) : "nil"
                    let serverError = self.ourError(code: 992, description: "Server error: \(dataString ?? "nil")")
                    completion(.failure(serverError))
                }
            }
        }
        dataTask.resume()
        
        return dataTask
    }
}
