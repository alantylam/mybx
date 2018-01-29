//
//  SearchBar.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-19.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit


extension UISearchBar {
    
    var textField: UITextField? {
        return subviews.first?.subviews.first(where: { $0.isKind(of: UITextField.self) }) as? UITextField
    }
    
    func setPlaceholderTextColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textAlignment = .center
        
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
        textFieldInsideSearchBarLabel?.font = UIFont.systemFont(ofSize: 10)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        let textfieldOfSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textfieldOfSearchBar?.leftView = nil
    }
    
    func setMagnifyingGlassColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
}
