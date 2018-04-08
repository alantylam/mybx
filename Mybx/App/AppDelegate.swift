//
//  AppDelegate.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-15.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
// Google signin documentation https://developers.google.com/identity/sign-in/ios/sign-in?ver=swift
import GoogleSignIn

import FBSDKCoreKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    fileprivate lazy var appCoordinator: AppCoordinator = {
        return  AppCoordinator(window: self.window!)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Initialize Google sign-in
        GIDSignIn.sharedInstance().clientID = "183535692598-avd1hila093b0tr96np5eq2sulcpja8p.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        //FACEBOOK STUFF
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:
            launchOptions)
        
        let image = UIImage(color: StyleSheet.defaultTheme.mainColor)
        UINavigationBar.appearance().shadowImage = image
        UINavigationBar.appearance().setBackgroundImage(image, for: .default)
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        application.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = StyleSheet.defaultTheme.mainColor
        UITabBar.appearance().tintColor = StyleSheet.defaultTheme.mainColor
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        startAppFlow()
        
        
        
        return true
    }
    
    //MARK: FACEBOOK STUFF

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                             annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return facebookHandler
    }
    

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err  = error{
            print("Failed to login to Google ", err)
            return
        }
        
        print("Successfully logged in to Google ", user)
        
        guard let googleName = user.profile.name else {return}
        print("Google user name: \(googleName)")
        guard let googleIdToken = user.authentication.idToken else {return}
        guard let googleAccessToken = user.authentication.accessToken else {return}
        
        
        let uID = user.userID
        
        let fullName = user.profile.name
        let email = user.profile.email
        var imageURL = ""
        if user.profile.hasImage{
            imageURL = user.profile.imageURL(withDimension: 100).absoluteString
        }
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "Success", "googleIdToken": googleIdToken, "googleAccessToken": googleAccessToken,"fullName": fullName, "email": email, "imageURL": imageURL, "ID": uID])
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Google signin: Perform any operations when the user disconnects from app here
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "Disconnected"])
    }
    
    func startAppFlow() {
        appCoordinator.start()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

