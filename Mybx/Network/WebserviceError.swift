//
//  WebserviceError.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-25.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

public enum WebServiceError: Error {
    case networkError(Error)
    case serverError(Error)
    case notAuthenticated
    case unsuccessStatusCode(Int)
    case missingHttpResponse
    case other
}

extension WebServiceError {
    
    var errorDescription: String {
        switch self {
        case .networkError(let err):
            return err.localizedDescription
        case .serverError(let err):
            return err.localizedDescription
        case .notAuthenticated:
            return "Not Authenticated"
        default:
            return "Unknown error"
        }
    }
}


extension WebServiceError {
    //TODO: - Refactor to use appropriate codes and supply good user info
    var error: Error {
        return NSError(domain: "MYBX", code: 10, userInfo: [:])
    }
}
