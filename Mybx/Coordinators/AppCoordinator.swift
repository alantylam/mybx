//
//  AppCoordinator.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-30.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    typealias ViewController = UITabBarController

    private let _window: UIWindow
    let root: UIViewController
    var viewController: UITabBarController?
    
    // Coordinators
    private var _galleryCoord: GalleryCoordinator?
    private var _xpertListCoord: XpertListCoordinator?
    private var _giveawaysCoord: GiveawaysCoordinator?
    private var _myBxCoord: MyBxCoordinator?
    
    init(window: UIWindow) {
        _window = window
        root = UIViewController()
    }
    
    func createViewController() -> UITabBarController {
        let vc = BXTabViewController()
        return vc
    }
    
    func show(vc: UITabBarController) {
        _window.rootViewController = vc
        
        var vcs = [UIViewController]()
        
        // add the other coords
        _galleryCoord = GalleryCoordinator(root: vc)
        vcs.append(_galleryCoord!.createViewController())
        
        _xpertListCoord = XpertListCoordinator(root: vc)
        vcs.append(_xpertListCoord!.createViewController())

        _giveawaysCoord = GiveawaysCoordinator(root: vc)
        vcs.append(_giveawaysCoord!.createViewController())
        
        _myBxCoord = MyBxCoordinator(root: vc)
        vcs.append(_myBxCoord!.createViewController())
        
        vc.viewControllers = vcs
    }
    
}

