//
//  SignUpViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-03.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    var signedUp:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor.white
        setBackground()
        setLabel()
        addCancelButton()
        setEmailField()
        setNextButton()
    }
    
    private func setBackground() {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "mobile-home-college") //if its in images.xcassets
        self.view.addSubview(imageView)
    }
    
    func addCancelButton() {
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissScreen))
        btnCancel.tintColor = .white
        navigationItem.rightBarButtonItem = btnCancel
    }
    
    @objc func dismissScreen() {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popToRootViewController(animated: true)
    }

    private func setLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.center.x = view.center.x
        label.center.y = 50
        label.textColor = .white
        label.text = "Sign up with email"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: label.font.fontName, size: 30)
        
        view.addSubview(label)
    }
    
    private func setEmailField() {
        let email = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        email.center.y = 110
        email.center.x = view.center.x
        email.backgroundColor = UIColor.white
        email.placeholder = "Email"
        
        email.addShadow()
        
        self.view.addSubview(email)
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
        let newViewController = SignUp2ViewController()
        //newViewController.navigationController?.navigationItem.rightBarButtonItem = btnCancel
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
