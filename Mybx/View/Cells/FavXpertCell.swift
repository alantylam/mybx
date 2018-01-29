//
//  FavXpertCell.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-28.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import SDWebImage


protocol XpertsFavouratesCellDelegate: class {
    func didSelectItem(_ item: Xpert, in frame: CGRect, withIndex index: Int)
}

final class XpertsFavouratesCell: BaseTableViewCell, ReusableView {
    
    var xperts: [Xpert]? {
        didSet {
            _collectionView.reloadData()
        }
    }
    
    weak var delegate: XpertsFavouratesCellDelegate?
    
    
    private var _selectedCell: FavXpertCell? {
        didSet {
            if let frame = _selectedCell?.globalFrame,
                let xpert = _selectedCell?.xpert,
                let index = xperts?.index(of: xpert) {
                delegate?.didSelectItem(xpert, in: frame, withIndex: index)
            }
        }
    }
    
    // MARK: - UI
    
    private lazy var _headerLabel: UILabel = {
        let label = UILabel(type: .header)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Favorites Xperts"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var _collectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FavXpertCell.self)
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = StyleSheet.defaultTheme.backgroundColor
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

extension XpertsFavouratesCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return xperts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavXpertCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.xpert = xperts?.at(index: indexPath.item)
        cell.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _selectedCell = collectionView.cell(forIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height)
    }
}


final class FavXpertCell: UICollectionViewCell, ReusableView {
    
    var xpert: Xpert? {
        didSet {
            
            _fullNameLabel.text = xpert?.fullName
            _specialistLabel.text = xpert?.sepcialized
            
            xpert >>>= {
                _profileImageView.sd_setImage(with: $0.profileImageUrl, placeholderImage: nil, options: [.progressiveDownload])
            }
        }
    }
    
    private lazy var _profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.setAsCardView()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5
        return imgView
    }()
    private lazy var _fullNameLabel: UILabel = {
        let label = UILabel(type: .header)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = StyleSheet.defaultTheme.mainColor
        return label
    }()
    private lazy var _specialistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubviews([_profileImageView, _fullNameLabel, _specialistLabel])
        
        _profileImageView.layoutTo(edges: [.left, .top, .right], ofView: self, withMargin: 8)
        _fullNameLabel.layoutTo(edges: [.left, .right], ofView: self, withMargin: 8)
        _specialistLabel.layoutTo(edges: [.left, .right], ofView: self, withMargin: 8)

        NSLayoutConstraint.activate([
            _profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            _fullNameLabel.topAnchor.constraint(equalTo: _profileImageView.bottomAnchor, constant: 8),
            _specialistLabel.topAnchor.constraint(equalTo: _fullNameLabel.bottomAnchor, constant: 4),
        ])
        
    }
    
}
