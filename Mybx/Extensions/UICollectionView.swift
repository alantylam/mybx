//
//  UICollectionView.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-26.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func cell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = cellForItem(at: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func allCellsVisible(inSection section: Int = 0) -> Bool {
        let totalItems = numberOfItems(inSection: section)
        return (cellIsCompletelyVisible(atIndexPath: IndexPath(row: 0, section: section))
            && cellIsCompletelyVisible(atIndexPath: IndexPath(row: totalItems - 1, section: section)))
    }
    
    func cellIsCompletelyVisible(atIndexPath indexPath: IndexPath) -> Bool {
        if let cell = cellForItem(at: indexPath) {
            let cellRect = convert(cell.frame, to: superview)
            if frame.contains(cellRect) {
                //completely visible
                return true
            }
        }
        return false
    }
    
}
