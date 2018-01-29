//
//  Result.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-25.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

enum Result<T>{
    case success(T)
    case failure(WebServiceError)
}

extension Result {
    
    public init(_ value: T?, or error: WebServiceError) {
        if let value = value {
            self = .success(value)
        } else {
            self = .failure(error)
        }
    }
    
    public var value: T? {
        guard case .success(let v) = self else { return nil }
        return v
    }
}
