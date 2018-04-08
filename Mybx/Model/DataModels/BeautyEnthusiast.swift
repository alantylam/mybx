//
//  BeautyEnthusiast.swift
//  Mybx
//
//  Created by Ana Paulina on 2018-03-20.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import Foundation

struct BeautyEnthusiast{
    
    let token: String
    
}

extension BeautyEnthusiast: JSONDecodable {
    
    enum Keys: String { case token}
    
    init?(json: JSONDict) {
        guard //let id = json.string(key: Keys._id.rawValue),
            let token = json.string(key: Keys.token.rawValue)
            else {
                return nil
        }
        
        self.token = token
        
    }
    
    func convertToJson() -> JSONDict {
        return [
            Keys.token.rawValue: token,
            
        ]
    }
}

extension BeautyEnthusiast: Equatable {
    
    static func ==(lhs: BeautyEnthusiast, rhs: BeautyEnthusiast) -> Bool {
        return lhs.token == rhs.token
    }
}


// MARK: - Resources

extension BeautyEnthusiast {
    
    static func googleLogin(id: String, email: String) -> Resource<[BeautyEnthusiast]> {
        let payLoad = ["id": id, "email": email]
        
        return Resource(url: BXEndPoints.googleLogin(withId: id, withEmail: email).url,
                        method: .post(payload: payLoad),
                        parseJSON: { json in
                            return (json => JSONDict.self )?.array(key: "user")
        })
    }
    
    static func getEnthusiast(token: String) -> Resource<[BeautyEnthusiast]> {
        let payLoad = ["token": token]
        
        return Resource(url: BXEndPoints.getEnthusiast(withToken: token).url,
                        method: .post(payload: payLoad),
                        parseJSON: { json in
                            return (json => JSONDict.self )?.array(key: "user")
        })
    }
    
}
