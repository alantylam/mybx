//
//  BaseTableViewCell.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-19.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    lazy var backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setAsCardView()
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = StyleSheet.defaultTheme.backgroundColor
        contentView.addSubview(backgroundCardView)
        backgroundCardView.layoutTo(edges: [.left, .top, .right, .bottom], ofView: contentView, withMargin: 8)
    }

}


class BaseCollectionViewCell: UICollectionViewCell {
    
    lazy var backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setAsCardView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = StyleSheet.defaultTheme.backgroundColor
        contentView.addSubview(backgroundCardView)
        backgroundCardView.layoutTo(edges: [.left, .top, .right, .bottom], ofView: contentView, withMargin: 4)
    }
    
}



