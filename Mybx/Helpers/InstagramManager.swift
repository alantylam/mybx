//
//  InstagramHelper.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-01.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit


final class InstagramManager {
    
    static let shared: InstagramManager = InstagramManager()
    
    private var instagramUrl: String {
        return "instagram://"
    }
    
    func openUserAccount(withUsername username: String) {
        let url = URL(string: "\(instagramUrl)user?username=\(username)")
        if UIApplication.shared.canOpenURL(url!) {
            openURL(url: url!)
        } else {
            // open it on the web
            let url = URL(string: "https://www.instagram.com/\(username)")
            openURL(url: url!)
        }
    }
    
    func openMedia(withId id: String) {
        let url = URL(string: "\(instagramUrl)media?id=\(id)")
        if UIApplication.shared.canOpenURL(url!) {
            openURL(url: url!)
        } else {
            // open it on the web
            let url = URL(string: "https://www.instagram.com/p/\(id)")
            openURL(url: url!)
        }
    }
    
    private func openURL(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
