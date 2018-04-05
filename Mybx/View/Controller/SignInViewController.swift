//
//  SignInViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-03.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
// TODO: use self.present instead of .push

import UIKit

class SignInViewController: UIViewController , UITextFieldDelegate { // add ", UITextFieldDelegate"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setBackground()
        setLogo()
        setUsernamePasswordFields()
        setSubmitButton()
    }
        /*
     if want to move frame according to the keyboard height, add these codes
     
     
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    deinit {
        // Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
     
    func hideKeyboard(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }*/
    
    
    private func setLogo() {
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        logo.image = #imageLiteral(resourceName: "mybx_logo_full")
        logo.center = CGPoint(x: view.center.x, y: view.center.y-200)
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
        username.placeholder = "Email"
        
        username.addShadow()
        
        self.view.addSubview(username)
        
        let password = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        password.center.y = username.center.y + 70
        password.center.x = view.center.x
        password.backgroundColor = UIColor.white
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        
        password.addShadow()
        
        self.view.addSubview(password)
    }
    
    private func setSubmitButton() {
        let submit = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        submit.backgroundColor = UIColor.rgb(r: 240, g: 98, b: 96) // 94.12, 38.43, 37.65
        submit.center.x = view.center.x
        submit.center.y = view.subviews[3].center.y + 70
        submit.setTitle("Sign In", for: .normal)
        submit.addTarget(self, action: #selector(submitButtonClicked), for: .touchUpInside)
        
        submit.addShadow()
        
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
