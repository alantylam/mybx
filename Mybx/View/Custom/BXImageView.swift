//
//  BXImageView.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-18.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit


class BXImageView: UIImageView {
    
    // MARK: - API
    
    var instaItem: InstaItem? {
        didSet {
            _postLabel.text = instaItem?.caption
            let iconsSize = CGRect(x: 0, y: 0, width: 12, height: 12)
            let attributedString = NSMutableAttributedString(string: "\(instaItem?.likes ?? 0) ")
            let likesAttachment = NSTextAttachment()
            likesAttachment.image = #imageLiteral(resourceName: "heart_icon").withRenderingMode(.alwaysTemplate)
            likesAttachment.bounds = iconsSize
            attributedString.append(NSAttributedString(attachment: likesAttachment))
            attributedString.append(NSAttributedString(string: ", \(instaItem?.comments ?? 0) "))
            let commentsAttachment = NSTextAttachment()
            commentsAttachment.image = #imageLiteral(resourceName: "comment_icon").withRenderingMode(.alwaysTemplate)
            commentsAttachment.bounds = iconsSize
            attributedString.append(NSAttributedString(attachment: commentsAttachment))
            _likesAndCommentsLabel.attributedText = attributedString
        }
    }
    
    // MARK: - private properties
    
    private var preivewViewIsShown: Bool = false
    
    
    // MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var _previewView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        return view
    }()
    
    private lazy var _postLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont (name: "Cochin", size: 15)
        label.textColor = StyleSheet.defaultTheme.mainColor
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private lazy var _likesAndCommentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = StyleSheet.defaultTheme.mainColor
        label.tintColor = StyleSheet.defaultTheme.mainColor
        label.font = UIFont (name: "Cochin", size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - Layout
    
    private func setupUI() {
       
        _previewView.addSubviews([_postLabel, _likesAndCommentsLabel])
        addSubviews([_previewView])

        _postLabel.center()
        _postLabel.layoutTo(edges: [.left, .right], ofView: _previewView, withMargin: 8)
        _likesAndCommentsLabel.center(axis: .horizontal)
        _likesAndCommentsLabel.layout(edges: [.top], toEdges: [.bottom], ofViews: [_postLabel], withMargins: [8])
        _previewView.layoutTo(edges: [.left, .top, .right, .bottom], ofView: self, withMargin: -2)
    }
    
    // MARK: - Event Handlers
    
    @objc func togglePreviewView() {
        preivewViewIsShown = !preivewViewIsShown
        if(preivewViewIsShown) {
            showPreviewView()
        } else {
            hidePreviewView()
        }
    }
    
    func hidePreviewView() {
        UIView.animate(withDuration: 0.33, animations: { [weak self] in
            self?._previewView.alpha = 0.0
        })
    }
    
    func showPreviewView() {
        UIView.animate(withDuration: 0.33, animations: { [weak self] in
            self?._previewView.alpha = 1.0
        })
    }
   
}
