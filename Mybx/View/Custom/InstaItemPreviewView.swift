//
//  InstaItemPreviewView.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-01.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

protocol InstaItemPreviewDelegate: class {
    func clickedInstagramBtn(forItem item: InstaItem)
    func addToFavourates(_ instaItem: InstaItem)
    func removeFromFavourates(_ instaItem: InstaItem)
    func clickedReportBtn(forItem item: InstaItem)
    func clickedOnXpertBtn(forItem item: InstaItem)
}

final class InstaItemPreviewView: UIView {
    
    var image: UIImage? {
        didSet {
            _imageView.image = image
        }
    }
    
    var instaItem: InstaItem? {
        didSet {
            instaItem >>>= {
                _imageView.sd_setImage(with: $0.imgUrl, placeholderImage: nil, options: [.progressiveDownload])
            }
        }
    }
    
    var isFavoured: Bool? {
        didSet {
            guard let isF = isFavoured else { return }
            
            if isF {
                _favBtn.setFAIcon(icon: FAType.FAHeart, iconSize: 20, forState: .normal)
            } else {
                _favBtn.setFAIcon(icon: FAType.FAHeartO, iconSize: 20, forState: .normal)
            }
        }
    }
    
    weak var delegate: InstaItemPreviewDelegate?
    
    lazy var _imageView: BXImageView = {
        let imageView = BXImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.setAsCardView()
        return imageView
    }()
    
    private lazy var _roportBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(report), for: .touchUpInside)
        btn.tintColor = StyleSheet.defaultTheme.mainColor
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        btn.layer.cornerRadius = 5.0
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setFAIcon(icon: FAType.FAExclamationCircle, iconSize: 23, forState: .normal)
        return btn
    }()
    private lazy var _instagramBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = StyleSheet.defaultTheme.mainColor
        btn.addTarget(self, action: #selector(openInInstagram), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        btn.setFAIcon(icon: FAType.FAInstagram, iconSize: 15, forState: .normal)
        btn.layer.cornerRadius = 5.0
        btn.clipsToBounds = true
        return btn
    }()
    private lazy var _favBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = StyleSheet.defaultTheme.mainColor
        btn.addTarget(self, action: #selector(addToFavourate), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        btn.layer.cornerRadius = 5.0
        btn.clipsToBounds = true
        return btn
    }()
    private lazy var _xpertBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = StyleSheet.defaultTheme.mainColor
        btn.addTarget(self, action: #selector(showXpert), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        btn.setFAIcon(icon: FAType.FAUserO, iconSize: 20, forState: .normal)
        btn.layer.cornerRadius = 5.0
        btn.clipsToBounds = true
        return btn
    }()
    private lazy var _stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self._roportBtn,  self._favBtn])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        return stackView
    }()
    
    init(frame: CGRect, isProfile: Bool) {
        super.init(frame: frame)
        
        if isProfile {
            _stackView.addArrangedSubview(self._instagramBtn)
        } else {
            _stackView.addArrangedSubview(self._xpertBtn)
        }
        setupUI()
    }
    
    @objc func openInInstagram() {
        guard let instaItem = self.instaItem else { return }
        delegate?.clickedInstagramBtn(forItem: instaItem)
    }
    
    @objc func addToFavourate() {
        guard let instaItem = self.instaItem, let isF = isFavoured  else { return }
        
        if isF {
            delegate?.removeFromFavourates(instaItem)
        } else {
            delegate?.addToFavourates(instaItem)
        }
        isFavoured = !isF
    }
    
    @objc func report() {
        guard let instaItem = self.instaItem else { return }
        delegate?.clickedReportBtn(forItem: instaItem)
    }
    
    @objc func showXpert() {
        guard let instaItem = self.instaItem else { return }
        delegate?.clickedOnXpertBtn(forItem: instaItem)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        addSubviews([_imageView, _stackView])
        _imageView.layoutTo(edges: [.left, .top, .right], ofView: self, withMargin: 2)
        _stackView.layoutTo(edges: [.left, .right, .bottom], ofView: self, withMargin: 2)
        
        NSLayoutConstraint.activate([
            _stackView.heightAnchor.constraint(equalToConstant: 30),
            _imageView.bottomAnchor.constraint(equalTo: _stackView.topAnchor, constant: -2)
        ])
    }
    
}
