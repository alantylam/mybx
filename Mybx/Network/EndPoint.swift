//
//  EndPoint.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-25.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

protocol EndPoint {
    
    var scheme: String { get }
    var host: String { get }
    var port: Int { get }
    var basePath: String { get }
    var extendedPath: String { get }
    var queryItems: [String:Any] { get }
    var url: URL { get }
    
    // used for testing
    var sampleTestData: JSONDict { get }
}

extension EndPoint {
    
    var scheme: String {
        return NetworkMetaData.scheme
    }
    
    var host: String {
        return  NetworkMetaData.host
    }
    
    var port: Int {
        return NetworkMetaData.port
    }
    
    var basePath: String {
        return "/api"
    }
    
    var queryItems: [String : Any] {
        get {
            return [:]
        }
    }
    
    var url: URL {
        get {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.port = port
            components.path = basePath + extendedPath
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in queryItems {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
            
            print(components.url!)
            return components.url!
        }
    }
    
    var sampleTestData: JSONDict {
        get {
            return [:]
        }
    }
}

// isLastPage

enum BXEndPoints: EndPoint {

    case xpertsForCategory(BXCategory)
    case itemsForCategory(BXCategory)
    case itemsForXpert(withUsername: String)
    case reportItem(withId: String)
    case googleLogin(withId: String, withEmail: String)
    case getEnthusiast(withToken: String)
    
    var extendedPath: String {
        switch self {
        case .xpertsForCategory(_):
            return "/find_users"
        case .itemsForCategory(_):
            return "/find_photos"
        case .itemsForXpert(_):
            return "/load_user"
        case .reportItem(_):
            return "/report"
        case .googleLogin(_):
            return "/login/google"
        case .getEnthusiast(_):
            return "/enthusiast/get"
        }
    }
    
}










