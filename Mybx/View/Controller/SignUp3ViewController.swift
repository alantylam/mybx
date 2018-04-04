//
//  SignUp3ViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-03.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

class SignUp3ViewController: UIViewController {

    var username: String
    
    init(name: String) {
        username = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        // addCancelButton()
        setLabel()
        setNextButton()
    }

    // The below function might not be necessary for this screen
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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        label.center.x = view.center.x
        label.center.y = 100
        label.text = "Welcome to myBeautyXpert, " + username + "!"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: label.font.fontName, size: 30)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        view.addSubview(label)
        
    }
    
    private func setNextButton() {
        let next = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        next.backgroundColor = UIColor.rgb(r: 240, g: 98, b: 96)
        next.center.x = view.center.x
        next.center.y = view.subviews[0].center.y+110
        next.setTitle("Next", for: .normal)
        next.layer.cornerRadius = 12.0
        next.layer.borderWidth = 1.0
        next.layer.borderColor = UIColor.black.cgColor
        next.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        self.view.addSubview(next)
    }
    
    @objc func nextButtonClicked() {
        print("Next Button Clicked!")
        let newViewController = SignUp4ViewController()
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
