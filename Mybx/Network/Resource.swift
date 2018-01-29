//
//  Resource.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-25.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

struct Resource<T> {
    var url: URL
    let parse: ((Data) -> Result<T>)
    let method: HttpMethod<Data>
}

extension Resource {
    
    func resourceForNextPage(withOptions options: PaginationOptions) -> Resource {
        var dict: [String: Any] = ["page": options.pageNumber, "limit": options.pageSize]
        if case let .post(oldPayload) = method {
            let oldDict = try? JSONSerialization.jsonObject(with: oldPayload, options: [])
            dict += ((oldDict as? [String: Any]) ?? [:])
        }
        return Resource(url: url, method: .post(payload: dict), parse: parse)
    }
    
}

extension Resource {
    
    init(url: URL, method: HttpMethod<Any> = .get, parse: @escaping ((Data) -> Result<T>)) {
        self.url = url
        self.parse = parse
        self.method = method.map { json in
            try! JSONSerialization.data(withJSONObject: json, options: [])
        }
    }
    
    init(url: URL, method: HttpMethod<Any> = .get, parseJSON: @escaping (Any) -> T?) {
        self.url = url
        self.method = method.map { json in
            try! JSONSerialization.data(withJSONObject: json, options: [])
        }
        self.parse = { data in
            
            //convert to json
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if NetworkMetaData.PRINT_NETWORK_RESPONSE {
                if let jsonData = (json => JSONDict.self) {
                    print(jsonData)
                } else {
                    print("Unable to convert the response to JSON Data")
                }
            }
            
            //check for server errors
            if let jsonData = (json => JSONDict.self),
                let err = Resource.checkForError(dict: jsonData) {
                return .failure(.serverError(err))
            }
            
            // parse and return the result
            let parsed = json.flatMap(parseJSON)
            return Result(parsed, or: WebServiceError.other)
        }
    }
    
    static func checkForError(dict: JSONDict) -> NSError? {
        guard let hasError = dict.int(key: "error"),
            hasError > 0 else {
                return nil
        }
        return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "" ])
    }
    
}

extension URLRequest {
    
    init<T>(_ resource: Resource<T>) {
        let  request = NSMutableURLRequest(url: resource.url)
        request.addJSONContentHeader()
        request.httpMethod = resource.method.method
        if case let .post(data) = resource.method { request.addJSONBody(data) }
        self = request as URLRequest
    }
    
}


extension NSMutableURLRequest {
    
    func addJSONContentHeader() {
        addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    func addJSONBody(_ body: Data) {
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        httpBody = body
    }
 
}




