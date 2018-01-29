//
//  XpertListCoordinator.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-30.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

final class XpertListCoordinator: TabBarCoordinator {

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
        let vc = BXPageMenuController(getXpertList(),
                                       menuItems: menuItemsLabels,
                                       initialViewControllerIndex: 0)
        vc.tabBarItem = UITabBarItem(title: "Xperts", image: #imageLiteral(resourceName: "xperts_icon"), selectedImage: #imageLiteral(resourceName: "xperts_icon"))
        let nav = UINavigationController(rootViewController: vc)
        viewController = nav
        return nav
    }
    
    private func getXpertList() -> [UIViewController] {
        
        let pgManager_hair = PaginationManager(resource: Xpert.xperts(forCategory: .hair), paginationOptions: .defaultOptions)
        let vm_hair = XpertListViewModel(pgManager: pgManager_hair)
        vm_hair.selectedXpert = { [weak self] xpert in
            self?.showProfile(forXpert: xpert)
        }
        let vc_hair = XpertListViewController(viewModel: vm_hair)
        
        let pgManager_eyelash = PaginationManager(resource: Xpert.xperts(forCategory: .eyelashes), paginationOptions: .defaultOptions)
        let vm_eyelash = XpertListViewModel(pgManager: pgManager_eyelash)
        vm_eyelash.selectedXpert = { [weak self] xpert in
            self?.showProfile(forXpert: xpert)
        }
        let vc_eyelash = XpertListViewController(viewModel: vm_eyelash)
        
        let pgManager_makeup = PaginationManager(resource: Xpert.xperts(forCategory: .makeup), paginationOptions: .defaultOptions)
        let vm_makeup = XpertListViewModel(pgManager: pgManager_makeup)
        vm_makeup.selectedXpert = { [weak self] xpert in
            self?.showProfile(forXpert: xpert)
        }
        let vc_makeup = XpertListViewController(viewModel: vm_makeup)
        
        let pgManager_eyebrow = PaginationManager(resource: Xpert.xperts(forCategory: .eyebrows), paginationOptions: .defaultOptions)
        let vm_eyebrow = XpertListViewModel(pgManager: pgManager_eyebrow)
        vm_eyebrow.selectedXpert = { [weak self] xpert in
            self?.showProfile(forXpert: xpert)
        }
        let vc_eyebrow = XpertListViewController(viewModel: vm_eyebrow)
        
        return [vc_hair, vc_eyelash, vc_makeup, vc_eyebrow]
    }
    
    private func showProfile(forXpert xpert: Xpert) {
        let coordinator = XpertWithUsernameRemote(xpertInstaUsername: xpert.instaUsername)
        let vc = LoadingViewController(coordinator: coordinator)
        viewController?.pushViewController(vc, animated: true)
    }
    
    
}

