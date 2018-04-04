//
//  SignInViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-03.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setLogo()
        setUsernamePasswordFields()
        setSubmitButton()
        // Do any additional setup after loading the view.
    }
    
    private func setLogo() {
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        logo.image = #imageLiteral(resourceName: "mybx_logo_full")
        logo.center = CGPoint(x: view.center.x, y: view.center.y-175)
        view.addSubview(logo)
    }
    
    private func setBackground() {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "mobile-home-college") //if its in images.xcassets
        self.view.addSubview(imageView)
    }
    
    private func setUsernamePasswordFields() {
        let username = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        username.center.y = view.subviews[1].center.y+150
        username.center.x = view.center.x
        username.backgroundColor = UIColor.white
        username.placeholder = "   Email"
        username.layer.cornerRadius = 5.0
        username.layer.borderWidth = 1.0
        username.layer.borderColor = UIColor.black.cgColor
        
        /*
        let arbitraryValue: Int = 5
        if let newPosition = username.position(from: username.beginningOfDocument, offset: arbitraryValue) {
            
            username.selectedTextRange = username.textRange(from: newPosition, to: newPosition)
        }
        */
        
        self.view.addSubview(username)
        
        let password = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        password.center.y = username.center.y + 70
        password.center.x = view.center.x
        password.backgroundColor = UIColor.white
        password.placeholder = "   Password"
        password.layer.cornerRadius = 5.0
        password.layer.borderWidth = 1.0
        password.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(password)
    }
    
    private func setSubmitButton() {
        let submit = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        submit.backgroundColor = UIColor.rgb(r: 240, g: 98, b: 96) // 94.12, 38.43, 37.65
        submit.center.x = view.center.x
        submit.center.y = view.subviews[3].center.y + 70
        submit.setTitle("Sign In", for: .normal)
        submit.layer.cornerRadius = 12.0
        submit.layer.borderWidth = 1.0
        submit.layer.borderColor = UIColor.black.cgColor
        submit.addTarget(self, action: #selector(submitButtonClicked), for: .touchUpInside)
        
        self.view.addSubview(submit)
        
    }
    
    @objc func submitButtonClicked() {
        print("Log In Button Clicked!")
        self.navigationController?.popToRootViewController(animated: true)
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
