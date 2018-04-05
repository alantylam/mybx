//
//  UIButton.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-04.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

extension UIButton {
    func addShadow() {
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
}
