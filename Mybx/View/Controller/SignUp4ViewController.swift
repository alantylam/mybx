//
//  SignUp4ViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-03.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

class SignUp4ViewController: UIViewController, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {

    let picker=UIImagePickerController()
    var profilePicture:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate=self
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setProfilePicture()
        setLabel()
        setSaveButton()
        setSkipButton()
    }

    private func setProfilePicture() {
        profilePicture = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        profilePicture.center = CGPoint(x: view.center.x, y: 120)
        profilePicture.image = #imageLiteral(resourceName: "default_profile")
        profilePicture.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePicture.addGestureRecognizer(tapGesture)
        
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        view.addSubview(profilePicture)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        profilePicture.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.center.x = view.center.x
        label.center.y = view.center.y-120
        label.text = "Add Profile Photo"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: label.font.fontName, size: 30)
        view.addSubview(label)
    }
    
    private func setSaveButton() {
        let save = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        save.backgroundColor = UIColor.rgb(r: 240, g: 98, b: 96)
        save.center.x = view.center.x
        save.center.y = view.center.y-70
        save.setTitle("Save", for: .normal)
        save.layer.cornerRadius = 12.0
        save.layer.borderWidth = 1.0
        save.layer.borderColor = UIColor.black.cgColor
        save.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        self.view.addSubview(save)
    }
    
    @objc func saveButtonClicked() {
        print("Save Button Clicked!")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func setSkipButton() {
        let skip = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        let yourAttributes : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor : UIColor.rgb(r: 240, g: 98, b: 96),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "Skip",attributes: yourAttributes)
        skip.setAttributedTitle(attributeString, for: .normal)
        skip.backgroundColor = UIColor.clear
        skip.center = CGPoint(x: view.center.x, y: view.center.y+250)
        skip.addTarget(self, action: #selector(skipButtonClicked), for: .touchUpInside)
        
        self.view.addSubview(skip)
    }
    
    @objc func skipButtonClicked() {
        print("Skip Button Clicked!")
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
