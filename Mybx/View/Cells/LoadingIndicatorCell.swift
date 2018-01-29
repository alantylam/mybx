//
//  LoadingIndicatorTableCell.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-26.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit


final class LoadingIndicatorTableCell: BaseTableViewCell, ReusableView {
    
    // API
    
    func startAnimating() {
        _spinner.startAnimating()
    }
    
    func stopAnimating() {
        _spinner.stopAnimating()
    }
    
    fileprivate var _spinner: UIActivityIndicatorView =  {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = StyleSheet.defaultTheme.mainColor
        return spinner
    }()
    
    override func setupUI() {
        super.setupUI()
        addSubview(_spinner)
        _spinner.center()
        backgroundCardView.isHidden = true
    }
    
}

final class LoadingIndicatorCollectionViewCell: BaseCollectionViewCell, ReusableView {
    
    // API
    
    func startAnimating() {
        _spinner.startAnimating()
    }
    
    func stopAnimating() {
        _spinner.stopAnimating()
    }
    
    fileprivate var _spinner: UIActivityIndicatorView =  {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = StyleSheet.defaultTheme.mainColor
        return spinner
    }()
    
    override func setupUI() {
        super.setupUI()
        addSubview(_spinner)
        _spinner.center()
        backgroundCardView.isHidden = true
        
    }
    
}
