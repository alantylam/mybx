//
//  FavouratesCell.swift
//  Mybx
//
//  Created by Amjad Al-Absi on 2017-11-21.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

protocol InstaItemsFavouratesCellDelegate: class {
    func didSelectItem(_ item: InstaItem, in frame: CGRect, withIndex index: Int)
}

final class InstaItemsFavouratesCell: BaseTableViewCell, ReusableView {
    
    var instaItems: [InstaItem]? {
        didSet {
            _collectionView.reloadData()
            _headerLabel.text = "Favorites \(instaItems?.first?.categories.first?.rawValue ?? "" )"
        }
    }
    
    weak var delegate: InstaItemsFavouratesCellDelegate?
    
    
    private var _selectedCell: ImageCell? {
        didSet {
            oldValue?.hidePreviewView()
            if oldValue != _selectedCell {
                _selectedCell?.showPreviewView()
            } else {
                if let frame = _selectedCell?.globalFrame,
                    let item = _selectedCell?.instaItem,
                    let index = instaItems?.index(of: item){
                    
                    delegate?.didSelectItem(item, in: frame, withIndex: index)
                }
            }
        }
    }
    
    // MARK: - UI
    
    private lazy var _headerLabel: UILabel = {
        let label = UILabel(type: .header)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var _collectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ImageCell.self)
        cv.dataSource = self
        cv.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        return cv
    }()
    
    
    override func setupUI() {
        self.addSubviews([_headerLabel, _collectionView])
        
        _headerLabel.layoutTo(edges: [.left, .right], ofView: self, withMargin: 8)
        _collectionView.layoutTo(edges: [.left, .right, .bottom], ofView: self, withMargin: 0)
        
        NSLayoutConstraint.activate([
            _headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            _collectionView.topAnchor.constraint(equalTo: _headerLabel.bottomAnchor, constant: 12)
            ])
        
        backgroundColor = StyleSheet.defaultTheme.backgroundColor
    }
    
}

extension InstaItemsFavouratesCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instaItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.instaItem = self.instaItems?.at(index: indexPath.item)
        cell.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _selectedCell = collectionView.cell(forIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
