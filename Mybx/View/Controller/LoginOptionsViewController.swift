//
//  LoginOptionsViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-03.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

class LoginOptionsViewController: UIViewController {

    var googleButton: UIButton!
    var fbButton: UIButton!
    var myBXButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        setLogo()
        setButtons()
        signUpOptions()
    }
    
    private func setLogo() {
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        logo.image = #imageLiteral(resourceName: "mybx_logo_full")
        logo.center = CGPoint(x: view.center.x, y: view.center.y-175)
        view.addSubview(logo)
    }
    
    private func signUpOptions() {
        let question = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        question.center = CGPoint(x: view.center.x-30, y: myBXButton.center.y+50)
        question.text = "Don't have an account?"
        question.textColor = .white
        question.textAlignment = NSTextAlignment.center
        question.font = UIFont(name: question.font.fontName, size: 12)
        
        self.view.addSubview(question)
        
        let signUp = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        let yourAttributes : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "Sign Up",attributes: yourAttributes)
        signUp.setAttributedTitle(attributeString, for: .normal)
        //signUp.setTitle("Sign Up", for: .normal)
        //signUp.setTitleColor(.white, for: .normal)
        signUp.backgroundColor = UIColor.clear
        signUp.center = CGPoint(x: view.center.x + 60, y: myBXButton.center.y+50)
        signUp.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        //signUp.titleLabel?.font = UIFont(name: (signUp.titleLabel?.font.fontName)!, size: 12)
        
        self.view.addSubview(signUp)
    }
    
    @objc func signUpButtonAction(sender: UIButton!) {
        print("Sign Up Button tapped!")
        let newViewController = SignUpViewController()
        
        //newViewController.navigationController?.navigationItem.rightBarButtonItem = btnCancel
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    private func setBackground() {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "mobile-home-college") //if its in images.xcassets
        self.view.addSubview(imageView)
    }
    
    private func setButtons() {
        googleButton = setGoogleButton()
        fbButton = setFBButton()
        myBXButton = setMyBXButton()
    }
    
    private func setGoogleButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: view.center.x, y: 100, width: 300, height: 50))
        button.center = CGPoint(x: view.center.x, y: view.center.y)
        button.backgroundColor = UIColor.rgb(r: 221, g: 75, b: 57)
        button.addTarget(self, action: #selector(googleButtonAction), for: .touchUpInside)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOG IN WITH GOOGLE", for: .normal)
        
        button.setImage(#imageLiteral(resourceName: "google"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: (button.bounds.width - 45))
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: (-(button.bounds.width*2-120)), bottom: 5, right: 5)
        
        self.view.addSubview(button)
        return button
    }
    
    @objc func googleButtonAction(sender: UIButton!) {
        print("Google Button tapped!")
    }
    
    private func setFBButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: view.center.x, y: 200, width: 300, height: 50))
        
        button.center = CGPoint(x: view.center.x, y: (googleButton.center.y+70))
        button.backgroundColor = UIColor.rgb(r: 59, g: 89, b: 152)
        button.addTarget(self, action: #selector(fbButtonAction), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOG IN WITH FACEBOOK", for: .normal)
        button.setImage(#imageLiteral(resourceName: "facebook"), for: .normal)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 13, left: 15, bottom: 13, right: (button.bounds.width - 40))
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: (-(button.bounds.width*2-120)), bottom: 5, right: 5)
        
        self.view.addSubview(button)
        return button
    }
    
    @objc func fbButtonAction(sender: UIButton!) {
        print("Facebook Button tapped!")
    }
    
    private func setMyBXButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: view.center.x, y: 100, width: 300, height: 50))
        button.center = CGPoint(x: view.center.x, y: (fbButton.center.y + 70))
        button.backgroundColor = UIColor.rgb(r: 105, g: 105, b: 105)
        button.addTarget(self, action: #selector(myBXButtonAction), for: .touchUpInside)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOG IN VIA EMAIL", for: .normal)
        
        self.view.addSubview(button)
        return button
    }
    
    @objc func myBXButtonAction(sender: UIButton!) {
        print("MyBX Button tapped!")
        let newViewController = SignInViewController()
        
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
