//
//  PhotoCollectionView.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-18.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout


final class PhotosVC: UICollectionViewController {
    
    private enum PhotosVCSections {
        case photos, loadingIndicator
    }

    //MARK: - Navigating Photos
    
    private var _photoSlider: PhotoSlider?
    private var _instaItemIndex = 0
    private var _firstELement = 0
    private var _isFirstElement: Bool {
        return _instaItemIndex == _firstELement
    }
    private var _hasShownFirstELement = false
    private var _selectedCell: ImageCell? {
        didSet {
            oldValue?.hidePreviewView()
            if oldValue != _selectedCell {
                _selectedCell?.showPreviewView()
            } else {
                if let instaItem = _selectedCell?.instaItem, let index = self._viewModel.outputs.index(of: instaItem) {
                    self._instaItemIndex = index
                    self._firstELement = index
                    showCardPreviewView(forItem: instaItem)
                }
            }
        }
    }
    // MARK: - Properties + Inits
    
    private var _noCols: Int { return 2 }
    private let _sections: [PhotosVCSections] = [.photos, .loadingIndicator]
    private let _isProfile: Bool
    private var _viewModel: PhotosViewModelType
    private lazy var _layout: CHTCollectionViewWaterfallLayout = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = self._noCols
        layout.minimumColumnSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    init(viewModel: PhotosViewModelType, isProfile: Bool = false) {
        _viewModel = viewModel
        _isProfile = isProfile
        
        var _layout: CHTCollectionViewWaterfallLayout = {
            let layout = CHTCollectionViewWaterfallLayout()
            layout.columnCount = 2
            layout.minimumColumnSpacing = 0
            layout.minimumInteritemSpacing = 0
            return layout
        }()
        
        super.init(collectionViewLayout: _layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setViewModel()
        _viewModel.inputs.viewDidLoad()
    }
    
    private func setupCollectionView() {
        
        collectionView?.register(ImageCell.self)
        collectionView?.register(LoadingIndicatorCollectionViewCell.self)
        collectionView?.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        view.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        collectionView?.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
    }
    
    private func setViewModel() {
        _viewModel.outputs.appendNextPage = { [weak self] indexPaths in
            guard let strongSelf = self else { return }
            
            strongSelf.collectionView?.insertItems(at: indexPaths)
            strongSelf.collectionView?.reloadItems(at: [IndexPath(item: 0, section: 1)]) // to load the next page
        }
        _viewModel.outputs.nextPageFailed = { error in print("Error Loading the next page \(error.localizedDescription)")}
    }
    
    
    @objc func removePreviewView() {
        _photoSlider?.hide()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension PhotosVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch _sections[section] {
        case .photos:
            return _viewModel.outputs.numberOfItems
        case .loadingIndicator:
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch _sections[indexPath.section] {
        case .photos:
            let cell: ImageCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.instaItem = _viewModel.outputs[indexPath.row]
            return cell
        case .loadingIndicator:
            let cell: LoadingIndicatorCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if _viewModel.outputs.isLastPage{
                cell.stopAnimating()
            } else {
                cell.startAnimating()
                _viewModel.inputs.fetchNextPage()
            }
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch _sections[indexPath.section] {
        case .photos:
            let cell: ImageCell = collectionView.cell(forIndexPath: indexPath)
            _selectedCell = cell
        case .loadingIndicator:
            break
        }
    }
    
}


extension PhotosVC : CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        switch _sections[indexPath.section] {
        case .photos:
            let item = _viewModel.outputs[indexPath.row]
            let height = (Float(item.height) / Float(item.width)) * Float((collectionView.frame.width / 2.0))
            return CGSize(width: collectionView.frame.width / CGFloat(_noCols), height: CGFloat(height))
        case .loadingIndicator:
            return CGSize(width: collectionView.frame.width / 2.0, height: Dimension(traitCollection: traitCollection).loadCell)
        }
    }
    
}


extension PhotosVC {
    
    private func showCardPreviewView(forItem item: InstaItem) {
        guard let cellFrame = collectionView?.cellForItem(at: IndexPath(item: _instaItemIndex, section: 0))?.globalFrame else { return }
        
        _photoSlider = PhotoSlider(firstItem: item, firstItemFrame: cellFrame, isProfile: _isProfile)
        _photoSlider?.delegate = self
        _photoSlider?.show()
        _selectedCell = nil
    }
    
}


extension PhotosVC: PhotoSliderDelegate {
    
    func isAlreadyFavoured(_ instaItem: InstaItem) -> Bool {
        return _viewModel.outputs.isAlreadyFavoured(instaItem)
    }
    
    func nextInstaItem() -> (item: InstaItem, size: CGSize) {
        if !_isFirstElement || _hasShownFirstELement {
            _instaItemIndex = _instaItemIndex >= (_viewModel.outputs.numberOfItems - 1) ? 0 : (_instaItemIndex + 1)
        } else {
            _hasShownFirstELement = true
        }
        
        let item = _viewModel.outputs[_instaItemIndex]
        // TODO - REFACTOR
        let height = (Float(item.height) / Float(item.width)) * Float((collectionView!.frame.width / 2.0))
        let size = CGSize(width: collectionView!.frame.width / CGFloat(_noCols), height: CGFloat(height))
        return (item: item, size: size)
    }
    
    func previousInstaItem() -> (item: InstaItem, size: CGSize) {
        if !_isFirstElement || _hasShownFirstELement {
             _instaItemIndex = _instaItemIndex == 0 ? (_viewModel.outputs.numberOfItems - 1) : _instaItemIndex - 1
        } else {
            _hasShownFirstELement = true
        }
        let item = _viewModel.outputs[_instaItemIndex]
        // TODO - REFACTOR
        let height = (Float(item.height) / Float(item.width)) * Float((collectionView!.frame.width / 2.0))
        let size = CGSize(width: collectionView!.frame.width / CGFloat(_noCols), height: CGFloat(height))
        return (item: item, size: size)
    }
    
    func clickedOnXpertBtn(forItem item: InstaItem) {
        removePreviewView()
        _viewModel.inputs.showXpert(forItem: item)
    }
    
    func addToFavourates(_ instaItem: InstaItem) {
        
        guard let prev = _photoSlider?.topView, let window = UIApplication.shared.keyWindow else { return }
        _viewModel.inputs.addToFav(instaItem)
        
        // animate the dismissals
       
        UIView.animate(withDuration: 0.33, animations: {
            prev.transform = CGAffineTransform(scaleX: 0.35, y: 0.2)
            prev.center = CGPoint(x: window.frame.width - 50, y: window.frame.height - 20)
            prev.alpha = 0.0
        }) { (done) in
            self._photoSlider?.dismissTopView()
        }
    }
    
    func removeFromFavourates(_ instaItem: InstaItem) {
        _viewModel.inputs.removeFromFav(instaItem)
    }
    
    func clickedInstagramBtn(forItem item: InstaItem) {
        _viewModel.inputs.openInInstagram(item)
    }
    
    func clickedReportBtn(forItem item: InstaItem) {
        _viewModel.inputs.report(item) { [weak self] res in
            switch res {
            case .success(let bool):
                print("Success \(bool)")
            case .failure(let error):
                print(error)
            }
            self?.removePreviewView()
        }
    }
    
    func hideSlider() {
        _hasShownFirstELement = false
    }
  
}
