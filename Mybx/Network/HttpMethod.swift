//
//  HttpMethod.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-25.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

enum HttpMethod<T>{
    case get
    case post(payload: T)
}

extension HttpMethod where T == Data {
    
    var payLoad: JSONDict {
        switch self {
        case .get:
            return [:]
        case .post(let data):
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json as? JSONDict ?? [:]
        }
    }
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
   
}

extension HttpMethod {
    
    func map<B>(f: (T) throws -> B) rethrows -> HttpMethod<B> {
        switch self {
        case .get: return .get
        case .post(let payload):
            return .post(payload: try f(payload))
        }
    }
}
