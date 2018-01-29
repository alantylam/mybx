//
//  JSONDecodable.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-26.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias JSONDict = [String: Any]

protocol JSONDecodable {
    init?(json: JSONDict)
    func convertToJson() -> JSONDict
}


extension JSONDecodable {
    
    func convertToJson() -> JSONDict {
        return [:]
    }
}
