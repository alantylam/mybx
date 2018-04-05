//
//  LoginOptionsViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-03.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class LoginOptionsViewController: UIViewController, GIDSignInUIDelegate {

    var googleButton: UIButton!
    var fbButton: UIButton!
    var myBXButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
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
        question.center = CGPoint(x: view.center.x-25, y: myBXButton.center.y+50)
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
        signUp.center = CGPoint(x: view.center.x + 65, y: myBXButton.center.y+50)
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginOptionsViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        return button
    }
    
    @objc func googleButtonAction(sender: UIButton!) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        // handles data received from server
        if notification.name.rawValue == "ToggleAuthUINotification" {
            guard let userInfo = notification.userInfo as? [String:String] else { return }
            if notification.userInfo != nil {
                
                if userInfo["statusText"] == "Success"{
                    let name = userInfo["fullName"]!
                    let email = userInfo["email"]!
                    let googleIdToken = userInfo["googleIdToken"]!
                    let url = NSURL(string: userInfo["imageURL"]!)!
                    //self.imageView.image = UIImage(data: NSData(contentsOf: url as URL)! as Data)
                    
                    // TODO send data to server
                    self.navigationController?.popToRootViewController(animated: true)
                }
                else if userInfo["statusText"] == "Disconnected"{
                    // TODO handle ui signout here
                }
            }
        }
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        print("Successfully logged out of Google")
    }
    
    // MARK: Facebook
    private func setFBButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: view.center.x, y: 100, width: 300, height: 50))
        
        button.center = CGPoint(x: view.center.x, y: (googleButton.center.y+70))
        button.backgroundColor = UIColor.rgb(r: 59, g: 89, b: 152)
        button.addTarget(self, action: #selector(fbButtonAction), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOG IN WITH FACEBOOK", for: .normal)
        
        //button.setImage(#imageLiteral(resourceName: "facebook"), for: .normal)
        //button.imageEdgeInsets = UIEdgeInsets(top: 13, left: 15, bottom: 13, right: (button.bounds.width - 40))
        //button.titleEdgeInsets = UIEdgeInsets(top: 11, left: (-(button.bounds.width*2-200)), bottom: 11, right: 5)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(button)
        return button
    }
    
    @objc func fbButtonAction(sender: UIButton!) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    print("Successfully logged in to facebook")
                    self.getFacebookUserInfo()
                }
            }
        }
    }
//
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil{
//            print(error)
//            return
//        }
//        print("Successfully logged in with facebook")
//        getFacebookUserInfo()
//    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out with Facebook")
//        loginView.isHidden = false
    }
    
    func getFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                print(result!)
                let data = result as! [String : Any]
                
                let name = data["name"] as? String
                let email = data["email"] as? String
                let FBid = data["id"] as? String
                let url = "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1"
                let accessToken = FBSDKAccessToken.current().tokenString!
                // TODO send token to server
                
                self.navigationController?.popToRootViewController(animated: true)
            })
            connection.start()
        }
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
