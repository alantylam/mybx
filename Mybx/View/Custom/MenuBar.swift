//
//  MenuBar.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-12-04.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

@IBDesignable
class HighlighterView: UIView {
    
    @IBInspectable
    var menuText: String = "" {
        didSet {
            _menuLabel.text = menuText.uppercased()
        }
    }
    
    fileprivate lazy var _menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = StyleSheet.defaultTheme.mainColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        addSubview(_menuLabel)
        _menuLabel.center()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
    }
    
}


@IBDesignable
class MenuBar: UIView {
    
    @IBInspectable
    var st: String = "" {
        didSet {
            let _dd = st.components(separatedBy: ",")
            self.items = _dd
        }
    }
    
    var items: [String] = [] {
        didSet {
            _collectionView.reloadData()
        }
    }
    
    fileprivate lazy var _highlighterView: HighlighterView = {
        let view = HighlighterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var _collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.register(MenuCell.self)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    private func setup() {
        addSubview(_collectionView)
        _collectionView.layoutTo(edges: [.left, .top, .right, .bottom], ofView: self, withMargin: 8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _collectionView.layer.cornerRadius = _collectionView.frame.height / 2.0
    }
    
}

extension MenuBar: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MenuCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.menuText = items[indexPath.item]
        return cell
    }
    
}

@IBDesignable
class MenuCell: UICollectionViewCell, ReusableView {
    
    var menuText: String = "" {
        didSet {
            _menuLabel.text = menuText.uppercased()
        }
    }
    
    fileprivate lazy var _menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(_menuLabel)
        _menuLabel.center()
        backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupUI()
    }
    
}




