//
//  UITextField.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-04.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

extension UITextField {
    func addShadow() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
}



