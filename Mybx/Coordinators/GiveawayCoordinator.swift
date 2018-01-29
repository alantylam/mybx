//
//  GiveawayCoordinators.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-12-05.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

final class GiveawaysCoordinator: TabBarCoordinator {
    
    let root: UITabBarController
    var viewController: UINavigationController?
    
    init(root: UITabBarController) {
        self.root = root
    }
    
    func createViewController() -> UINavigationController {
        
        let pgManage = PaginationManager(resource: InstaItem.items(forCategory: .giveaway), paginationOptions: .defaultOptions)
        let vm = PhotosViewModel(favManager: UserDefaultManager(), pgManager: pgManage)
        vm.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc = PhotosVC(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: "Giveaway", image: #imageLiteral(resourceName: "giveaways_icon"), selectedImage: #imageLiteral(resourceName: "giveaways_icon"))
        return UINavigationController(rootViewController: vc)
    }
    
    private func showProfile(forItem item: InstaItem) {
        let coordinator = XpertWithUsernameRemote(xpertInstaUsername: item.instaUsername)
        let vc = LoadingViewController(coordinator: coordinator)
        viewController?.pushViewController(vc, animated: true)
    }
}

