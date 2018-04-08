//
//  SignUp2ViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-03.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

class SignUp2ViewController: UIViewController {

    var name:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setBackground()
        setLabel()
        addCancelButton()
        setNameField()
        setPasswordField()
        setNextButton()
    }
    
    // set the back ground picture
    private func setBackground() {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "mobile-home-college")
        self.view.addSubview(imageView)
    }
    
    func addCancelButton() {
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissScreen))
        btnCancel.tintColor = .white
        navigationItem.rightBarButtonItem = btnCancel
    }
    
    @objc func dismissScreen() {
        //self.dismiss(animated: true, completion: nil)
        print("Cancel Button Clicked")
        //TODO change this line to login options
        //self.navigationController?.popToRootViewController(animated: true)
        
        self.dismiss(animated: true, completion: nil)
        
        /*
         If it is pushed, use this code to revert back to login options screen
         
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is LoginOptionsViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
         */
    }
    
    private func setLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.center.x = view.center.x
        label.center.y = 50
        label.text = "Name and Password"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: label.font.fontName, size: 30)
        label.textColor = .white
        view.addSubview(label)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        label2.center.x = view.center.x
        label2.center.y = 90
        label2.text = "Add your name so friends can find you"
        label2.textAlignment = NSTextAlignment.center
        label2.font = UIFont(name: label2.font.fontName, size: 14)
        label2.textColor = .white
        view.addSubview(label2)
        
    }
    
    private func setNameField() {
        name = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        name.center.y = 140
        name.center.x = view.center.x
        name.backgroundColor = UIColor.white
        name.placeholder = "Full Name"
        
        name.addShadow()
        
        self.view.addSubview(name)
    }
    
    private func setPasswordField() {
        let password = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        password.center.y = 200
        password.center.x = view.center.x
        password.backgroundColor = UIColor.white
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        
        password.addShadow()
        
        self.view.addSubview(password)
    }
    
    private func setNextButton() {
        let next = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        next.backgroundColor = UIColor.rgb(r: 240, g: 98, b: 96)
        next.center.x = view.center.x
        next.center.y = view.frame.maxY-140
        next.setTitle("Next", for: .normal)
        next.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        next.addShadow()
        
        self.view.addSubview(next)
    }
    
    @objc func nextButtonClicked() {
        print("Next Button Clicked!")
        let newViewController = SignUp3ViewController(name: name.text!)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
