//
//  UIViewController.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-29.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit


extension UIViewController {
    
    var topPadding: Float {
        return Float(UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height)
    }
    
    func add(childViewController controller: UIViewController) {
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.layoutTo(edges: [.left, .top, .right, .bottom], ofView: view, withMargin: 0)
        controller.didMove(toParentViewController: self)
    }
    
    func remove(childViewController controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    func updateActiveViewController(activeVC: UIViewController, contentView: UIView) {
        // call before adding child view controller's view as subview
        addChildViewController(activeVC)
        
        activeVC.view.frame = contentView.bounds
        contentView.addSubview(activeVC.view)
        
        // call before adding child view controller's view as subview
        activeVC.didMove(toParentViewController: self)
    }
    
    
    func alertUser(title: String, error: NSError) {
        
        let message = "\(error.userInfo[NSLocalizedDescriptionKey]!)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParentViewController: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}



