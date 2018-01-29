//
//  InstaItem.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-26.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct InstaItem {
    
    let id: String
    let caption: String
    let comments: Int
    let imgUrl: URL
    let instaUrl: URL
    let instaUsername: String
    let likes: Int
    let width: Int
    let height: Int
    let categories: [BXCategory]
    let createdAt: Date?
}

extension InstaItem: JSONDecodable {
   
    enum Keys: String { case _id, caption, category, comments, created, image, instagram_url, instaname, likes, width,  height }
    
    init?(json: JSONDict) {
        guard //let id = json.string(key: Keys._id.rawValue),
            let caption = json.string(key: Keys.caption.rawValue),
            let comments = json.int(key: Keys.comments.rawValue),
            let imgUrl = json.url(key: Keys.image.rawValue),
            let instaUrl = json.url(key: Keys.instagram_url.rawValue),
            let instaUsername = json.string(key: Keys.instaname.rawValue),
            let likes = json.int(key: Keys.likes.rawValue),
            let width = json.int(key: Keys.width.rawValue),
            let height = json.int(key: Keys.height.rawValue) else {
                return nil
        }

        self.id = json.string(key: Keys._id.rawValue) ?? ""
        self.caption = caption
        self.comments = comments
        self.imgUrl = imgUrl
        self.instaUrl = instaUrl
        self.instaUsername = instaUsername
        self.likes = likes
        
        if let d = (json.string(key: Keys.created.rawValue) as NSString?)?.doubleValue {
            self.createdAt = Date(timeIntervalSince1970: d)
        } else {
            self.createdAt = nil
        }
        self.width = width
        self.height = height
        self.categories = json.array(key: Keys.category.rawValue)?.flatMap { BXCategory(rawValue: $0) } ?? []
    }
    
    func convertToJson() -> JSONDict {
        return [
            Keys._id.rawValue: id,
            Keys.caption.rawValue: caption,
            Keys.category.rawValue: categories.map { $0.rawValue },
            Keys.comments.rawValue: comments,
            Keys.instaname.rawValue: instaUsername,
            Keys.likes.rawValue: likes,
            Keys.image.rawValue: imgUrl.absoluteString,
            Keys.instagram_url.rawValue: instaUrl.absoluteString,
            Keys.width.rawValue: width,
            Keys.height.rawValue: height,
            Keys.created.rawValue: NSString(string: String(createdAt?.timeIntervalSince1970 ?? 0))
        ]
    }
}

extension InstaItem: Equatable {
    
    static func ==(lhs: InstaItem, rhs: InstaItem) -> Bool {
        return lhs.id == rhs.id
    }
}


// MARK: - Resources

extension InstaItem {
    
    static func items(forCategory category: BXCategory) -> Resource<[InstaItem]> {
        let payLoad = ["category": category.rawValue, "params": "{}"]
        return Resource(url: BXEndPoints.itemsForCategory(category).url,
                        method: .post(payload: payLoad),
                        parseJSON: { json in
                            return (json => JSONDict.self )?.array(key: "photos")
        })
    }
    
    static func itemsForXpert(withUsername username: String) -> Resource<[InstaItem]> {
        let payLoad = ["user": username]
        return Resource(url: BXEndPoints.itemsForXpert(withUsername: username).url,
                        method: .post(payload: payLoad),
                        parseJSON: { json in
                            return (json => JSONDict.self)?.array(key: "photos")
        })
    }
    
    static func report(item: InstaItem) -> Resource<Bool> {
        let payLoad = ["id": item.id]
        return Resource(url: BXEndPoints.reportItem(withId: item.id).url,
                        method: .post(payload: payLoad),
                        parseJSON: { json in
                            return true
        })
    }
    
}





