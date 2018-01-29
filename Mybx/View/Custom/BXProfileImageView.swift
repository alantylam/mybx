//
//  BXProfileImageView.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-27.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import SDWebImage

class BXProfileImageView: UIView {
    
    var profileImageUrl: URL? {
        didSet {
            profileImageUrl >>>= {
                _imageView.sd_setImage(with: $0, placeholderImage: nil, options: [.continueInBackground, .progressiveDownload], completed: nil)
            }
        }
    }
    
    private lazy var _imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var _circularLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = StyleSheet.defaultTheme.mainColor.cgColor
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.addSublayer(_circularLayer)
        addSubview(_imageView)
        
        _imageView.center()
        
        let dim = ((frame.size.width < frame.size.height) ? frame.size.width : frame.size.height)
        let updatedDim = dim - 15
        
        NSLayoutConstraint.activate([
            _imageView.widthAnchor.constraint(equalToConstant: updatedDim),
            _imageView.heightAnchor.constraint(equalToConstant: updatedDim),
            ])
        
        _imageView.layer.cornerRadius = updatedDim / 2.0
        
        let radius = dim / 2.0
        _circularLayer.frame = bounds
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius)
        let circlePathBounds = _circularLayer.bounds
        circleFrame.origin.x = circlePathBounds.midX - circleFrame.midX
        circleFrame.origin.y = circlePathBounds.midY - circleFrame.midY
        let path = UIBezierPath(ovalIn: circleFrame)
        _circularLayer.path = path.cgPath
    }
    
}
