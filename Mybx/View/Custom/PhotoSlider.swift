//
//  PhotoSlider.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-12-02.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift

protocol PhotoSliderDelegate: InstaItemPreviewDelegate {
    func nextInstaItem() -> (item: InstaItem, size: CGSize)
    func previousInstaItem() -> (item: InstaItem, size: CGSize)
    func isAlreadyFavoured(_ instaItem: InstaItem) -> Bool
    func hideSlider()
}

class PhotoSlider {
    
    enum Direction {
        case left, right
    }
    
    
    
    // MARK: - API
    
    weak var delegate: PhotoSliderDelegate?
    var topView: UIView? {
        get {
            return _swibeableView?.topView()
        }
    }
    
    func show() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let view = ZLSwipeableView(frame: window.bounds)
        view.numberOfActiveView = 1
        view.allowedDirection = .Horizontal
        view.alpha = 0
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.65)
        let tabGR = UITapGestureRecognizer(target: self, action: #selector(hide))
        view.addGestureRecognizer(tabGR)
        view.nextView = {
            return self.nextImageView()
        }
        view.didTap = {view, location in
            self.dismissTopView()
        }
        view.didSwipe = {view, direction, vector in
            switch direction {
            case .Left:
                self._scrollDirection = .left
            case .Right:
                self._scrollDirection = .right
            default: break
            }
            print(self._scrollDirection)
        }
        
        window.addSubview(view)
        UIView.animate(withDuration: 0.2, animations: {
            view.alpha = 1.0
        })
        self._swibeableView = view
    }
    
    @objc func dismissTopView() {
        _swibeableView?.swipeTopView(inDirection: .Left)
    }
    
    @objc func hide() {
        _swibeableView?.removeFromSuperview()
        delegate?.hideSlider()
    }
    
    // MARK: - Properties + Inits
    
    private var _scrollDirection: Direction = .left
    private let _firstItem: InstaItem
    private let _firstItemFrame: CGRect
    var _firstTimeToShowFirstItem = true
    private let _isProfile: Bool
    private let _rateSize: CGSize
    private var _swibeableView: ZLSwipeableView?
    
    init(firstItem: InstaItem, firstItemFrame: CGRect, isProfile: Bool, rateSize: CGSize = CGSize(width: 1.3, height: 1.3)) {
        _firstItem = firstItem
        _firstItemFrame = firstItemFrame
        _isProfile = isProfile
        _rateSize = rateSize
    }
    
    
    // MARK: - Helper Methods
    
    private func nextImageView() -> UIView {
        var item: (item: InstaItem, size: CGSize)?
        switch _scrollDirection {
        case .left:
            item = delegate?.nextInstaItem()
        case .right:
            item = delegate?.previousInstaItem()
        }
        guard let instaItem = item,
            let window = UIApplication.shared.keyWindow else { return UIView() }
        
        
        let _height = instaItem.size.height
        let width = instaItem.size.width * _rateSize.width + 4
        let height = (_height) * _rateSize.height + 36
        var viewFrame = CGRect.zero
        
        switch _scrollDirection {
        case .left:
            viewFrame = CGRect(x: window.frame.width , y: window.center.y - (_height/2.0), width: width, height: height)
            if instaItem.item == _firstItem && _firstTimeToShowFirstItem == true {
                _firstTimeToShowFirstItem = false
                viewFrame = CGRect(x: _firstItemFrame.origin.x , y: _firstItemFrame.origin.y, width: (_firstItemFrame.width * _rateSize.width + 4) , height: _firstItemFrame.height * _rateSize.height + 36)
            }
            
        case .right:
            viewFrame = CGRect(x: 0 , y: window.center.y - (_height / 2.0), width: width, height: height)
        }
       
        let prevView = InstaItemPreviewView(frame: viewFrame, isProfile: _isProfile)
        prevView.delegate = delegate
        prevView.clipsToBounds = true
        prevView.isFavoured = delegate?.isAlreadyFavoured(instaItem.item)
        prevView.instaItem = instaItem.item
        prevView.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor
        prevView.setAsCardView()
        return prevView
    }
    
}


