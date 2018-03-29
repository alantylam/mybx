//
//  BeautyEnthusiastViewController.swift
//  Mybx
//
//  Created by Ana Paulina on 2018-03-20.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit
// Google signin methods from https://github.com/googlesamples/google-services/blob/master/ios/signin/SignInExampleSwift/ViewController.swift#L33-L51
import GoogleSignIn

import FacebookCore
import FacebookLogin
import FBSDKLoginKit

final class BeautyEnthusiastViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    var signInButton: GIDSignInButton!
    var signOutButton: UIButton!
    var disconnectButton: UIButton!
    var statusText: UILabel!
    
    var imageView : UIImageView!
    var label: UILabel!
    var ID: UILabel!

    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor
        
        super.viewDidLoad()
        
        setupFacebookButtons()
       
        
        // TODO: check if user is logged in here?
        // setup login
        setupLoginUI()
    }
    
    //MARK: FACEBOOK STUFF
    
    func setupFacebookButtons(){
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.center = CGPoint(x: view.center.x, y: 200)
        imageView.image = UIImage(named: "fb-art.jpg")
        view.addSubview(imageView)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.center = CGPoint(x: view.center.x, y: 300)
        label.text = "Not Logged In"
        label.textAlignment = NSTextAlignment.center
        view.addSubview(label)
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile" , "email"]
        loginButton.center = CGPoint(x: view.center.x, y: 400)
        loginButton.delegate = self
        view.addSubview(loginButton)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out with Facebook")
        imageView.image = UIImage(named: "fb-art.jpg")
        label.text = "Not Logged In"
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        print("Successfully logged in with facebook")
        getFacebookUserInfo()
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
                print("User email is: \(data["email"]!)")
                self.label.text = data["name"] as? String
                
                let FBid = data["id"] as? String
                //self.ID.text = "User email is: \(data["email"]!)"
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.imageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            })
            connection.start()
        }
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        // redefine CGRectMake
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // Mark : - GOOGLE SIGN IN METHODS
    
    private func setupOtherButtons() {
        // add other buttons to screen
        
        signOutButton = UIButton(frame: CGRectMake(0,0,100,30))
        signOutButton.center = CGPoint(x: view.center.x, y: 100)
        signOutButton.setTitle("Sign Out", for: UIControlState.normal)
        signOutButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        signOutButton.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        signOutButton.addTarget(self, action: #selector(BeautyEnthusiastViewController.didTapSignOut(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(signOutButton)
        
        disconnectButton = UIButton(frame: CGRectMake(0,0,100,30))
        disconnectButton.center = CGPoint(x: view.center.x, y: 200)
        disconnectButton.setTitle("Sign Out", for: UIControlState.normal)
        disconnectButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        disconnectButton.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        disconnectButton.addTarget(self, action: #selector(BeautyEnthusiastViewController.didTapDisconnect(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(disconnectButton)
        
        statusText = UILabel(frame: CGRectMake(0,0,200,100))
        statusText.center = CGPoint(x: view.center.x, y: 400)
        statusText.numberOfLines = 0 //Multi-lines
        statusText.text = "Please Sign in."
        statusText.textAlignment = NSTextAlignment.center
        view.addSubview(statusText)
        
    }
    
    private func setupLoginUI() {
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO Configure the sign-in button look/feel
        signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        signInButton.center = view.center
        signInButton.style = GIDSignInButtonStyle.standard
        view.addSubview(signInButton)
        // add signout, disconnect, status buttons
        setupOtherButtons()
        
        // [START_EXCLUDE]
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BeautyEnthusiastViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        
        statusText.text = "Initialized Swift app..."
        toggleAuthUI()
        // [END_EXCLUDE]
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        statusText.text = "Signed out."
        toggleAuthUI()
        // [END_EXCLUDE]
    }
    
    @IBAction func didTapDisconnect(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().disconnect()
        // [START_EXCLUDE silent]
        statusText.text = "Disconnecting."
        // [END_EXCLUDE]
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                self.statusText.text = userInfo["statusText"]!
            }
        }
    }
    
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            statusText.text = "Google Sign in\niOS Demo"
        }
    }
}
