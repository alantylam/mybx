//
//  LoadingIndicator.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-29.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

class LoadingViewIndicator: UIView {
    
    // MARK: - API
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    func startAnimating() {
        spinner.startAnimating()
    }
    
    func stopAnimating() {
        spinner.stopAnimating()
    }
    
    // MARK: - UI
    
    fileprivate var spinner: UIActivityIndicatorView =  {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = StyleSheet.defaultTheme.mainColor
        return spinner
    }()
    fileprivate lazy var label: UILabel = {
        let label = UILabel(type: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = StyleSheet.defaultTheme.mainColor
        return label
    }()
    
    
    // MARK: - LifeCycles
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews([spinner, label])
        spinner.center(inView: self)
        label.layout(edges: [.left, .top, .right, .bottom],
                     toEdges: [.left, .bottom, .right, .bottom],
                     ofViews: [self, spinner, self, self],
                     withMargins: [8, 8, 8, 8])
    }
    
}

