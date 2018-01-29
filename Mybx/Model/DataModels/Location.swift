//
//  Location.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-27.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import FirebaseDatabase

struct Location {

    let address: String
    let lat: Float?
    let lng: Float?
}

extension Location: JSONDecodable {
    
    enum Keys: String { case address,lat, lng }
    
    init?(json: JSONDict) {
        guard let address = json.string(key: Keys.address.rawValue) else {
                return nil
        }
        
        self.address = address
        lat = json.float(key: Keys.lat.rawValue)
        lng = json.float(key: Keys.lng.rawValue)
        
    }
    
    init?(snapshot: DataSnapshot) {
        guard let json = snapshot.value => JSONDict.self else {
            return nil
        }
        self.init(json: json)
    }
}
