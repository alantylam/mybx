//
//  XpertPreviewView.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-18.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

final class XpertPreviewView: UIView {
    
    private let constant: Float = 4

    // MARK: - API
    
    var firstImageUrl: URL? {
        didSet {
            assign(url: firstImageUrl, toImageView: _firstImageView)
        }
    }
    
    var secondImageUrl: URL? {
        didSet {
            assign(url: secondImageUrl, toImageView: _secondImageView)
        }
    }
    
    var thirdImageUrl: URL? {
        didSet {
            assign(url: thirdImageUrl, toImageView: _thirdImageView)
        }
    }
    
    private func assign(url: URL?, toImageView imageView: UIImageView) {
        imageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveDownload], completed: nil)
    }
    
    var xpert: Xpert? {
        didSet {
            _usernameLabel.text = xpert?.instaUsername
            _instagramPhotosLabel.text = "Instagram Photos"
            _instagramCountLabel.text = "\(String(describing: xpert?.numberOfInstaItems ?? 0))"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var _firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    private lazy var _secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    private lazy var _thirdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    private lazy var _stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [_firstImageView, _secondImageView, _thirdImageView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.spacing = 2
        return stackView
    }()
    private lazy var _usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    private lazy var _instagramPhotosLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .right
        return label
    }()
    private lazy var _instagramCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .right
        return label
    }()
    private lazy var _shadowLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.white, UIColor.clear.cgColor]
        layer.frame = self.frame
        return layer
    }()
    
    private func setupUI() {
        
        addSubviews([_stackView])
        layer.addSublayer(_shadowLayer)
        addSubviews([_usernameLabel, _instagramPhotosLabel, _instagramCountLabel])
        
        _stackView.layoutTo(edges: [.left, .top, .right, .bottom], ofView: self, withMargin: 0)
        _usernameLabel.layoutTo(edges: [.left, .top], ofView: self, withMargin: constant)
        _instagramPhotosLabel.layoutTo(edges: [.right, .top], ofView: self, withMargin: constant)
        _instagramCountLabel.layout(edges: [.right, .top], toEdges: [.right, .bottom], ofViews: [self, _instagramPhotosLabel], withMargins: [constant, constant])

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _shadowLayer.frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bounds.height))
        _shadowLayer.startPoint = CGPoint(x: 0, y: 0)
        _shadowLayer.endPoint = CGPoint(x: 0, y: 1)
        
    }

}
