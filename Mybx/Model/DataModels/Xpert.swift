//
//  Xpert.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-26.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//
import Foundation

struct Xpert {
    
    let id: String
    let email: String
    let category: BXCategory
    let instaUsername: String
    let fullName: String
    let score: Float
    let about: String?
    let location: Location
    let expertise: String
    let pricing: String
    let sepcialized: String
    let bestPhotos: [InstaItem]
    let numberOfInstaItems: Int
    
    let profileImageUrl: URL?
    let phone: String?
    
}

extension Xpert: Equatable {
    static func ==(lhs: Xpert, rhs: Xpert) -> Bool {
        return (lhs.email == rhs.email) && (lhs.instaUsername == rhs.instaUsername)
    }
}

extension Xpert: JSONDecodable {
    
    enum Keys: String { case _id, email, category, instaname, fullName, photo, score, about, address,
        expertise, phone, pricing, specialized, bestPhotos }
    
    init?(json: JSONDict) {
        guard let id = json.string(key: Keys._id.rawValue),
            let email = json.string(key: Keys.email.rawValue),
            let category = json.category(key: Keys.category.rawValue),
            let instaUsername = json.string(key: Keys.instaname.rawValue),
            let fullName = json.string(key: Keys.fullName.rawValue),
            let score = json.float(key: Keys.score.rawValue),
            let location = Location(json: json),
            let expertise = json.string(key: Keys.expertise.rawValue),
            let pricing = json.string(key: Keys.pricing.rawValue),
            let sepcialized = json.string(key: Keys.specialized.rawValue) else {
                return nil
        }
        
        self.id = id
        self.email = email
        self.category = category
        self.instaUsername = instaUsername
        self.fullName = fullName
        self.score = score
        self.location = location
        self.expertise = expertise
        self.pricing = pricing
        self.sepcialized = sepcialized
        self.numberOfInstaItems = json.int(key: "") ?? 0
        about = json.string(key: Keys.about.rawValue)
        profileImageUrl = json.url(key: Keys.photo.rawValue)
        phone = json.string(key: Keys.phone.rawValue)
        bestPhotos = json.array(key: Keys.bestPhotos.rawValue) ?? []
    }
    
    func convertToJson() -> JSONDict {
        let dict: [String: Any] = [
            Keys._id.rawValue: id,
            Keys.email.rawValue: email,
            Keys.category.rawValue: category.rawValue,
            Keys.instaname.rawValue: instaUsername,
            Keys.fullName.rawValue: fullName,
            Keys.score.rawValue: score,
            Keys.expertise.rawValue: expertise,
            Keys.pricing.rawValue: pricing,
            Keys.specialized.rawValue: self.sepcialized,
            Keys.about.rawValue: about ?? "",
            Keys.photo.rawValue: profileImageUrl?.absoluteString ?? "",
            Keys.phone.rawValue: phone ?? "",
            Location.Keys.address.rawValue: location.address,
            Location.Keys.lat.rawValue: location.lat ?? "",
            Location.Keys.lng.rawValue: location.lng ?? ""
        ]
        return dict
    }
}

extension Xpert {
    
    var locationString: String {
        return "Location: \(location.address)"
    }
    
    var cost: String {
        return "\(pricing) $$"
    }

}


// MARK: - Resources

extension Xpert {
    
    static func xperts(forCategory category: BXCategory) -> Resource<[Xpert]> {
        let payLoad = ["category": category.rawValue, "params": "{}"]
        
        return Resource(url: BXEndPoints.xpertsForCategory(category).url,
                        method: .post(payload: payLoad),
                        parseJSON: { json in
                            return (json => JSONDict.self )?.array(key: "users")
        })
    }
    
    static func infoAndInstaItemsForXpert(withUsername username: String) -> Resource<(xpert: Xpert, items: [InstaItem])> {
        let payLoad = ["user": username]
        return Resource(url: BXEndPoints.itemsForXpert(withUsername: username).url,
                        method: .post(payload: payLoad),
                        parseJSON: { json in
                            let xpert: Xpert? = (json => JSONDict.self)?.dictionary(key: "user")
                            let items: [InstaItem]? = (json => JSONDict.self)?.array(key: "photos")
                            guard let x = xpert, let i = items else { return nil}
                            return (xpert: x, items: i)
        })
    }
}



