//
//  Coordinator.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-30.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit


/* Router Job
 
     - Router
     - Modules factory - (dependency injection)
     - Coordinators factory
     - Storage
 
 */


protocol Coordinator: class {
    
    associatedtype ViewController: UIViewController
    associatedtype RootViewController: UIViewController
    
    var viewController: ViewController? { get set}
    var root: RootViewController { get }
    
    func createViewController() -> ViewController
    func configure(vc: ViewController)
    func show(vc: ViewController)
    func dismiss()
    
}

extension Coordinator {
    
    func configure(vc: ViewController) {}
    
    func show(vc: ViewController) {
        root.show(vc, sender: self)
    }
    
    func dismiss() {
        root.dismiss(animated: true, completion: nil)
    }
}


extension Coordinator {

    func start() {
        let vc = createViewController()
        configure(vc: vc)
        show(vc: vc)
        self.viewController = vc
    }
    
    func stop() {
        dismiss()
        viewController = nil
    }
}



protocol NavigationCoordinator: Coordinator where RootViewController == UINavigationController {}

extension NavigationCoordinator {
    
    func show(_ viewController: Self.ViewController) {
        root.pushViewController(viewController, animated: true)
    }
    
    func dismiss() {
        viewController >>>= {
            root.popToViewController($0, animated: true)
        }
    }
}


extension Coordinator {
    
    func append<T: Coordinator>(childCoordinator coordinator: T?) {
        coordinator?.start()
    }
    
    func remove<T: Coordinator>(childCoordinator coordinator: T?) {
        coordinator?.stop()
    }
}


// MARK: - TabBarCoordinator

protocol TabBarCoordinator: Coordinator where  RootViewController == UITabBarController {}

extension TabBarCoordinator {
    
    func show(_ viewController: Self.ViewController) {
        var vcs = root.viewControllers ?? []
        vcs.append(viewController)
        root.setViewControllers(vcs, animated: true)
    }
    
    func dismiss() {
        viewController >>>= {
            var vcs = root.viewControllers ?? []
            vcs.remove($0)
            root.setViewControllers(vcs, animated: true)
        }
    }
}










