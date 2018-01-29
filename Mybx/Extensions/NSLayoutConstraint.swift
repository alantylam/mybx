//
//  NSLayoutConstraint.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-12.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

func equal<L, Axis>(_ to: KeyPath<UIView, L>) -> Constraint where L: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: to].constraint(equalTo: parent[keyPath: to])
    }
}

func equal<L>(_ keyPath: KeyPath<UIView, L>, to constant: CGFloat) -> Constraint where L: NSLayoutDimension {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}

func equal<L, Axis>(_ from: KeyPath<UIView, L>, _ to: KeyPath<UIView, L>) -> Constraint where L: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: from].constraint(equalTo: parent[keyPath: to])
    }
}


