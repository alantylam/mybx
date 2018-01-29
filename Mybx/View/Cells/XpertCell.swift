//
//  XpertCell.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-27.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

final class XpertCell: BaseTableViewCell, ReusableView  {
    
    // MARK: API
    
    var xpert: Xpert? {
        didSet {
            _previewView.xpert = xpert
            _userInfoView.xpert = xpert
            _previewView.firstImageUrl = xpert?.bestPhotos.at(index: 0)?.imgUrl
            _previewView.secondImageUrl = xpert?.bestPhotos.at(index: 1)?.imgUrl
            _previewView.thirdImageUrl = xpert?.bestPhotos.at(index: 2)?.imgUrl
        }
    }
    
    
    // MARK: - UI
    
    private lazy var _previewView: XpertPreviewView = {
        let view = XpertPreviewView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var _userInfoView: XpertInfoView = {
        let view = XpertInfoView(frame: .zero, showInstagramIcon: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupUI() {
        super.setupUI()
        
        backgroundCardView.addSubviews([_previewView, _userInfoView])
        
        _previewView.layoutTo(edges: [.left, .top, .right], ofView: backgroundCardView, withMargin: 8)
        _userInfoView.layoutTo(edges: [.bottom, .right], ofView: backgroundCardView, withMargin: 8)
        _userInfoView.layoutTo(edges: [.left], ofView: backgroundCardView, withMargin: -8)

        NSLayoutConstraint.activate([
            _previewView.heightAnchor.constraint(equalTo: backgroundCardView.heightAnchor, multiplier: 0.55),
            _userInfoView.heightAnchor.constraint(equalTo: backgroundCardView.heightAnchor, multiplier: 0.35)
        ])
    }
}

