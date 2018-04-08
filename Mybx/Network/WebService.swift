//
//  WebService.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-25.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

public enum WebServiceInterface {
    
    struct Manager {
        static let shared = WebService()
    }
    
    @discardableResult static func load<T>(_ resource: Resource<T>, completion: @escaping CompletionHandler<T>) -> URLSessionDataTask {
        return Manager.shared.load(resource, completion: completion)
    }
   
}


final class WebService {
    
    public let session = URLSession.shared
    
    // MARK: - API
    
    
    func load<T>(_ resource: Resource<T>, completion: @escaping CompletionHandler<T>) -> URLSessionDataTask {
        
        let req = URLRequest(resource)
        
        let task = session.dataTask(with: req) { data, response, error in
            let result: Result<T>
            
            if let error = error {
                result = Result.failure(WebServiceError.networkError(error))
            } else {
                if let httpResponse = response as? HTTPURLResponse ,
                    httpResponse.statusCode == 401 {
                    result = Result.failure(WebServiceError.notAuthenticated)
                } else {
                    result = data.flatMap(resource.parse) ?? Result.failure(WebServiceError.other)
                }
            }
            mainQueue {
                completion(result)
            }
        }
        task.resume()
        return task
    }
    
    
    func load_enth<T>(_ resource: Resource<T>, completion: @escaping CompletionHandler<T>) -> URLSessionDataTask {
        
        let req = URLRequest(resource)
        
        let task = session.dataTask(with: req) { data, response, error in
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print(dataString!)
            
        }
        task.resume()
        return task
    }
}

