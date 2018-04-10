//
//  MyBxCoordinator.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-12-05.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

final class MyBxCoordinator: TabBarCoordinator {
    
    let root: UITabBarController
    var viewController: UINavigationController?
    
    init(root: UITabBarController) {
        self.root = root
    }
    var temp: BXPageMenuController?
    func createViewController() -> UINavigationController {
        
        
        /*
        let vm = MyBxViewModel()
        // load MyBXViewController inside the tab
        //let vc = BeautyEnthusiastViewController()
        let vc = MyBXViewController(viewModel: vm)
        
        // add tab at the bottom
        vc.tabBarItem = UITabBarItem(title: "MyBX", image: #imageLiteral(resourceName: "my_bx"), selectedImage: #imageLiteral(resourceName: "my_bx"))
        return UINavigationController(rootViewController: vc)
        */
        
        let menuItemsLabels: [BXMenuBarCellType] = [
            .label("Hair"),
            .label("Eyelashes"),
            .label("Makeup"),
            .label("Eyebrows")
        ]
        
        let vc = BXPageMenuController(getCategoryVC(),
                                      menuItems: menuItemsLabels,
                                      initialViewControllerIndex: 0)
        vc.tabBarItem = UITabBarItem(title: "MyBX", image: #imageLiteral(resourceName: "my_bx"), selectedImage: #imageLiteral(resourceName: "my_bx"))
        temp = vc
        let loginButton = UIBarButtonItem(title: "Login", style: .done, target: self, action: #selector(showLogin))
        vc.navigationItem.rightBarButtonItem = loginButton
        let nav = UINavigationController(rootViewController: vc)
        
        self.viewController = nav
        return nav
    }
    
    @objc func showLogin() {
        let newViewController = LoginOptionsViewController()
        temp?.navigationController?.pushViewController(newViewController, animated: true)
        //self.viewController?.pushViewController(newViewController, animated: true)
    }

    private func getCategoryVC() -> [UIViewController] {
        let favManager = UserDefaultManager()
        // sets up each category tab, loaded into PhotosVC view controller (grid of photos)
        
        let pgManager_hair = favManager.loadInstaItems(forCategory: .hair)
        let vm_hair = PhotosViewModel(instaItems: pgManager_hair, favManager: favManager)
        vm_hair.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_hair = ProfileVC(viewModel: vm_hair, cat: .hair)
        
        // it pulls from server
        let pgManager_eyelash = favManager.loadInstaItems(forCategory: .eyelashes)
        let vm_eyelash = PhotosViewModel(instaItems: pgManager_eyelash, favManager: favManager)
        vm_eyelash.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_eyelash = ProfileVC(viewModel: vm_eyelash, cat: .eyelashes)
        
        let pgManager_makeup = favManager.loadInstaItems(forCategory: .makeup)
        let vm_makeup = PhotosViewModel(instaItems: pgManager_makeup, favManager: favManager)
        vm_makeup.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_makeup = ProfileVC(viewModel: vm_makeup, cat: .makeup)
        
        let pgManager_eyebrow = favManager.loadInstaItems(forCategory: .eyebrows)
        let vm_eyebrow = PhotosViewModel(instaItems: pgManager_eyebrow, favManager: favManager)
        vm_eyebrow.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_eyebrow = ProfileVC(viewModel: vm_eyebrow, cat: .eyebrows)
        return [vc_hair, vc_eyelash, vc_makeup, vc_eyebrow]
    }
    
    private func showProfile(forItem item: InstaItem) {
        let coordinator = XpertWithUsernameRemote(xpertInstaUsername: item.instaUsername)
        let vc = LoadingViewController(coordinator: coordinator)
        viewController?.pushViewController(vc, animated: true)
    }
}

