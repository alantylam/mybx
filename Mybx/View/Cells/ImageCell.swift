//
//  ImageCell.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-27.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import SDWebImage
import Font_Awesome_Swift

final class ImageCell: BaseCollectionViewCell, ReusableView {
    
    var onImageDownloaded: ((CGFloat, InstaItem) -> Void) = { _, _ in }
    
    var instaItem: InstaItem? {
        didSet {
            _imageView.instaItem = instaItem
            instaItem >>>= {
                _imageView.sd_setImage(with: $0.imgUrl, placeholderImage: nil, options: [.progressiveDownload])
            }
        }
    }
    
    var image: UIImage? {
        get {
            return _imageView.image
        }
        set {
            _imageView.image = newValue
        }
    }
    
    func hidePreviewView() {
        _imageView.hidePreviewView()
    }
    
    func showPreviewView() {
        _imageView.showPreviewView()
    }
    
    private lazy var _imageView: BXImageView = {
        let imageView = BXImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupUI() {
        super.setupUI()
        backgroundCardView.addSubview(_imageView)
        _imageView.layoutTo(edges: [.left, .top, .right, .bottom], ofView: backgroundCardView, withMargin: 4)
    }
    
}


