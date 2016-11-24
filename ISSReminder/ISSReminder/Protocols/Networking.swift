//
//  Networking.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import Foundation

enum NetworkingResult {
    case success(Data)
    case error(Error)
}

enum NetworkingError: Error {
    case unknown
    case unexpectedCode
}

protocol Networking: class {}

extension Networking {
    
    func fetchData(at url: URL, completion: @escaping (NetworkingResult) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
        
            self?.handleResponse(networking: (data: data, response: response, error: error), completion: completion)
        })
        
        task.resume()
        
        return task
    }
    
    func handleResponse(networking: (data: Data?, response: URLResponse?, error: Error?), completion: @escaping (NetworkingResult) -> Void) {
        
        if let error = networking.error {
            return completion(NetworkingResult.error(error))
        }
        
        guard let data = networking.data, let response = networking.response as? HTTPURLResponse else {
            return completion(NetworkingResult.error(NetworkingError.unknown))
        }
        
        switch response.statusCode {
        case 200:
            return completion(NetworkingResult.success(data))
        default:
            return completion(NetworkingResult.error(NetworkingError.unexpectedCode))
        }
    }
}
