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
    var navController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        title = "Login Options"
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        setBackground()
        
        setLogo()
        setButtons()
        signUpOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Check if the user is logged in?
        
        // if so, go back to the profile page.
        // self.navigationController?.popToRootViewController(animated: true)
    }
    
    // set and align the Logo
    private func setLogo() {
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        logo.image = #imageLiteral(resourceName: "mybx_logo_full")
        logo.center = CGPoint(x: view.center.x, y: view.center.y-200)
        view.addSubview(logo)
    }
    
    // create label and sign-up button.
    private func signUpOptions() {
        // creating label
        let question = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        question.center = CGPoint(x: view.center.x-25, y: myBXButton.center.y+50)
        question.text = "Don't have an account?"
        question.textColor = .white
        question.textAlignment = NSTextAlignment.center
        question.font = UIFont(name: question.font.fontName, size: 12)
        // add to view
        self.view.addSubview(question)
        
        // creating label
        let signUp = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        let yourAttributes : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "Sign Up",attributes: yourAttributes)
        signUp.setAttributedTitle(attributeString, for: .normal)
        signUp.backgroundColor = UIColor.clear
        signUp.center = CGPoint(x: view.center.x + 65, y: myBXButton.center.y+50)
        signUp.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        // add to view
        self.view.addSubview(signUp)
    }
    
    // Action that gets trigger after "Sign Up" button is pressed
    @objc func signUpButtonAction(sender: UIButton!) {
        print("Sign Up Button tapped!")
        let signUpVC = SignUpViewController()
        
        // "Pop up" a VC
        navController = UINavigationController(rootViewController: signUpVC)
        self.present(navController, animated: true, completion: (signUpCompletion))
    }
    
    // Action gets trigger after the sign-up process is completed or cancelled
    func signUpCompletion() {
        // check if the user created an account. If so, then switch to profile screen, else, maintain login screen.
        // for now we assume user finished the sign up process.
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // set the back ground picture
    private func setBackground() {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "mobile-home-college")
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
        
        let imageSize = CGSize(width: 30.0 , height: 30.0)
        let icon = ResizeImage(image: #imageLiteral(resourceName: "google"), targetSize: imageSize)
        button.setImage(icon, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOG IN WITH GOOGLE", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -47, bottom: 5, right: 5)
        //button.titleEdgeInsets = UIEdgeInsets(top: 5, left: (-(button.bounds.width*2-120)), bottom: 5, right: 5)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.addShadow()
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
        
        let imageSize = CGSize(width: 25.0, height: 25.0)
        let icon = ResizeImage(image: #imageLiteral(resourceName: "facebook"), targetSize: imageSize)
        
        button.setImage(icon, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOG IN WITH FACEBOOK", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -30, bottom: 5, right: 5)
        //button.titleEdgeInsets = UIEdgeInsets(top: 11, left: (-(button.bounds.width*2-200)), bottom: 11, right: 5)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.addShadow()
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
    
    // used to resize images. ** potentially move to extension
    // will keep here for now
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width*heightRatio, height: size.height*heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func setMyBXButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: view.center.x, y: 100, width: 300, height: 50))
        button.center = CGPoint(x: view.center.x, y: (fbButton.center.y + 70))
        button.backgroundColor = UIColor.rgb(r: 105, g: 105, b: 105)
        button.addTarget(self, action: #selector(myBXButtonAction), for: .touchUpInside)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOG IN VIA EMAIL", for: .normal)
        
        button.addShadow()
        
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
