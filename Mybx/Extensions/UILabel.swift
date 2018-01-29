//
//  UILabel.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-27.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

enum LabelType {
    case header, subheader, detail
}

extension UILabel {
    
    convenience init(type: LabelType) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        self.lineBreakMode = .byWordWrapping
        
        switch type {
        case .header:
            self.font = UIFont.boldSystemFont(ofSize: 14)
            self.textColor = UIColor.black
        case .subheader:
            self.font =  UIFont.systemFont(ofSize: 10)
            self.textColor = .gray
        case .detail:
            self.textColor = .black
            self.font =  UIFont.systemFont(ofSize: 10)
        }
    }
    
    var isEmpty: Bool {
        get {
            return text?.isEmpty ?? true
        }
    }
    
    var isNotEmpty: Bool {
        get {
            return !isEmpty
        }
    }
}


