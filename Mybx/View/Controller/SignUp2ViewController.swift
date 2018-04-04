//
//  SignUp2ViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-03.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

class SignUp2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setLabel()
        addCancelButton()
        setNameField()
        setPasswordField()
        setNextButton()
    }
    
    func addCancelButton() {
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissScreen))
        btnCancel.tintColor = .white
        navigationItem.rightBarButtonItem = btnCancel
    }
    
    @objc func dismissScreen() {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func setLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.center.x = view.center.x
        label.center.y = 50
        label.text = "Name and Password"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: label.font.fontName, size: 30)
        view.addSubview(label)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        label2.center.x = view.center.x
        label2.center.y = 90
        label2.text = "Add your name so friends can find you"
        label2.textAlignment = NSTextAlignment.center
        label2.font = UIFont(name: label2.font.fontName, size: 14)
        view.addSubview(label2)
        
    }
    
    private func setNameField() {
        let name = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        name.center.y = 140
        name.center.x = view.center.x
        name.backgroundColor = UIColor.white
        name.placeholder = "   Full Name"
        name.layer.cornerRadius = 5.0
        name.layer.borderWidth = 1.0
        name.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(name)
    }
    
    private func setPasswordField() {
        let password = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        password.center.y = 200
        password.center.x = view.center.x
        password.backgroundColor = UIColor.white
        password.placeholder = "   Password"
        password.layer.cornerRadius = 5.0
        password.layer.borderWidth = 1.0
        password.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(password)
    }
    
    private func setNextButton() {
        let next = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        next.backgroundColor = UIColor.rgb(r: 240, g: 98, b: 96)
        next.center.x = view.center.x
        next.center.y = 270
        next.setTitle("Next", for: .normal)
        next.layer.cornerRadius = 12.0
        next.layer.borderWidth = 1.0
        next.layer.borderColor = UIColor.black.cgColor
        next.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        self.view.addSubview(next)
    }
    
    @objc func nextButtonClicked() {
        print("Next Button Clicked!")
        let newViewController = SignUp3ViewController(name: "John")
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
