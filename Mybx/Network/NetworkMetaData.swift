//
//  MetaData.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-25.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

struct NetworkMetaData {
    
    static var scheme: String {
        get {
            return "https"
        }
    }
    
    static var host: String {
        get {
            //return  "54.146.197.152"
            return "mybeautyxpert.com"
        }
    }
    
    static var port: Int {
        get {
            return 443
        }
    }
    
    static var baseUrl: String {
        get {
            return "\(NetworkMetaData.scheme)://\(NetworkMetaData.host):\(NetworkMetaData.port)"
        }
    }
    
    static var PRINT_NETWORK_RESPONSE = true
}

