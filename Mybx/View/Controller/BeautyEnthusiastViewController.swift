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

final class BeautyEnthusiastViewController: UIViewController, GIDSignInUIDelegate {
    var signInButton: GIDSignInButton!
    var signOutButton: UIButton!
    var disconnectButton: UIButton!
    var statusText: UILabel!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor
        
        // TODO: check if user is logged in here?
        // setup login
        setupLoginUI()
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        // redefine CGRectMake for newer version
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // Mark : - GOOGLE SIGN IN METHODS
    private func setupOtherButtons() {
        // add other buttons to screen
        
        signOutButton = UIButton(frame: CGRectMake(0,0,230,48))
        signOutButton.backgroundColor = UIColor.black
        signOutButton.center = CGPoint(x: view.center.x, y: 200)
        signOutButton.setTitle("Sign Out", for: UIControlState.normal)
        signOutButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        signOutButton.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        signOutButton.addTarget(self, action: #selector(BeautyEnthusiastViewController.didTapSignOut(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(signOutButton)
        
        disconnectButton = UIButton(frame: CGRectMake(0,0,230,48))
        disconnectButton.backgroundColor = UIColor.black
        disconnectButton.center = CGPoint(x: view.center.x, y: 300)
        disconnectButton.setTitle("Disconnect", for: UIControlState.normal)
        disconnectButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        disconnectButton.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        disconnectButton.addTarget(self, action: #selector(BeautyEnthusiastViewController.didTapDisconnect(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(disconnectButton)
        
        statusText = UILabel(frame: CGRectMake(0,0,200,100))
        statusText.center = CGPoint(x: view.center.x, y: 100)
        statusText.numberOfLines = 0 //Multi-lines
        statusText.text = "Please Sign in."
        statusText.textAlignment = NSTextAlignment.center
        view.addSubview(statusText)
        
    }
    
    private func setupLoginUI() {
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Configure the sign-in button look/feel
        signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        signInButton.center = view.center
        signInButton.style = GIDSignInButtonStyle.standard
        view.addSubview(signInButton)
        // add signout, disconnect, status text buttons
        setupOtherButtons()
        
        // TODO problem here
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BeautyEnthusiastViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        
        toggleAuthUI()
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
    
    func toggleAuthUI() {
        print("BEFORE SIGN IN CHECK")
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            print("YOU ARE SIGNED IN")
            print(GIDSignIn.sharedInstance().clientID)
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
            GIDSignIn.sharedInstance().signInSilently()
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            statusText.text = "Google Sign in\niOS Demo"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
