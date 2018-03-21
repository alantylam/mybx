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
