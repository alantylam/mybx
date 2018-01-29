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
    
    func createViewController() -> UINavigationController {
        let vm = MyBxViewModel()
        let vc = MyBXViewController(viewModel: vm)
        vc.tabBarItem = UITabBarItem(title: "MyBX", image: #imageLiteral(resourceName: "my_bx"), selectedImage: #imageLiteral(resourceName: "my_bx"))
        return UINavigationController(rootViewController: vc)
    }

}

