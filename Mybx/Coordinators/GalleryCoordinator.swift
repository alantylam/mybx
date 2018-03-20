//
//  GalleryCoordinator.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-30.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

final class GalleryCoordinator: TabBarCoordinator {
    
    let root: UITabBarController
    var viewController: UINavigationController?
    
    init(root: UITabBarController) {
        self.root = root
    }
    
    func createViewController() -> UINavigationController {
        
        let menuItemsLabels: [BXMenuBarCellType] = [
            .label("Hair"),
            .label("Eyelashes"),
            .label("Makeup"),
            .label("Eyebrows")
        ]
        
        let vc = BXPageMenuController(getCategoryVC(),
                                       menuItems: menuItemsLabels,
                                       initialViewControllerIndex: 0)
        vc.tabBarItem = UITabBarItem(title: "Gallery", image: #imageLiteral(resourceName: "gallery_icon"), selectedImage: #imageLiteral(resourceName: "gallery_icon"))
        let nav = UINavigationController(rootViewController: vc)
        self.viewController = nav
        return nav
    }
    
    private func getCategoryVC() -> [UIViewController] {
        
        let favManager = UserDefaultManager()
        
        // sets up each category tab, loaded into PhotosVC view controller (grid of photos)
        let pgManager_hair = PaginationManager(resource: InstaItem.items(forCategory: .hair), paginationOptions: .defaultOptions)
        let vm_hair = PhotosViewModel(favManager: favManager, pgManager: pgManager_hair)
        vm_hair.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_hair = PhotosVC(viewModel: vm_hair)
        
        let pgManager_eyelash = PaginationManager(resource: InstaItem.items(forCategory: .eyelashes), paginationOptions: .defaultOptions)
        let vm_eyelash = PhotosViewModel(favManager: favManager, pgManager: pgManager_eyelash)
        vm_eyelash.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_eyelash = PhotosVC(viewModel: vm_eyelash)
        
        let pgManager_makeup = PaginationManager(resource: InstaItem.items(forCategory: .makeup), paginationOptions: .defaultOptions)
        let vm_makeup = PhotosViewModel(favManager: favManager, pgManager: pgManager_makeup)
        vm_makeup.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_makeup = PhotosVC(viewModel: vm_makeup)
        
        let pgManager_eyebrow = PaginationManager(resource: InstaItem.items(forCategory: .eyebrows), paginationOptions: .defaultOptions)
        let vm_eyebrow = PhotosViewModel(favManager: favManager, pgManager: pgManager_eyebrow)
        vm_eyebrow.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_eyebrow = PhotosVC(viewModel: vm_eyebrow)
        return [vc_hair, vc_eyelash, vc_makeup, vc_eyebrow]
    }
    
    private func showProfile(forItem item: InstaItem) {
        let coordinator = XpertWithUsernameRemote(xpertInstaUsername: item.instaUsername)
        let vc = LoadingViewController(coordinator: coordinator)
        viewController?.pushViewController(vc, animated: true)
    }
    
}

