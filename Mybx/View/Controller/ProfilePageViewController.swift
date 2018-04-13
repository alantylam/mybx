//
//  ProfilePageViewController.swift
//  Mybx
//
//  Created by Tsz Yeung Lam on 2018-04-11.
//  Copyright © 2018 Nabil Muthanna. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let picker = UIImagePickerController()
    var profilePic: UIImageView!
    // create the upper part of the profile screen, profile picture favourite xpert for each category.
    private lazy var _topView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        let profilePic = ProfilePicture()
        view.addSubview(profilePic)
        
        let userName = UsersName()
        view.addSubview(userName)
        
        let favXpertsLabel = FavXpertLabel()
        view.addSubview(favXpertsLabel)
        
        addFavXperts(view)
        addCategoryLabels(view)
        
        return view
    }()
    
    private func ProfilePicture() -> UIView {
        // add user's profile picture
        profilePic = UIImageView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        //profilePic.center.x = self.view.center.x
        //profilePic.center.y = 47
        profilePic.image = #imageLiteral(resourceName: "default_profile")
        profilePic.isUserInteractionEnabled = true // enable user to change their profile picture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePic.addGestureRecognizer(tapGesture)
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.rgb(r: 240, g: 98, b: 96).cgColor // UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        let outerView = UIView(frame: profilePic.frame)
        outerView.clipsToBounds = false
        outerView.center.x = self.view.center.x
        outerView.center.y = 47
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 5
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: profilePic.frame.height/2).cgPath
        
        outerView.addSubview(profilePic)
        
        
//        NSLayoutConstraint.activate([
//            profilePic.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
//
//            ])
        
        return outerView
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        profilePic.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func UsersName() -> UILabel {
        // add user's name
        let userName = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        userName.center.x = view.center.x
        userName.center.y = 94
        userName.text = "User Name"
        userName.textColor = .black
        userName.textAlignment = NSTextAlignment.center
        //userName.font = UIFont(name: userName.font.fontName, size: 14)
        userName.font = UIFont.boldSystemFont(ofSize: 14)
        
        return userName
    }
    
    private func FavXpertLabel() -> UILabel {
        // add label for Favourite Xperts
        let favXperts = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        favXperts.center.x = view.center.x
        favXperts.center.y = 124
        favXperts.text = "Favourite Xperts"
        favXperts.textColor = .black
        favXperts.textAlignment = NSTextAlignment.center
        //favXperts.font = UIFont(name: favXperts.font.fontName, size: 11)
        favXperts.font = UIFont.boldSystemFont(ofSize: 11)
        
        return favXperts
    }
    
    private func addFavXperts(_ view: UIView) {
        // add pictures of favourite xpert from each category
        let height:CGFloat = 160
        let gap = self.view.frame.width / 5
        
        let hair = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        hair.center.x = self.view.center.x - (gap*1.5)
        hair.center.y = height
        hair.image = #imageLiteral(resourceName: "default_profile")
        hair.layer.borderWidth = 1
        hair.layer.masksToBounds = false
        hair.layer.borderColor = UIColor.rgb(r: 240, g: 98, b: 96).cgColor
        hair.layer.cornerRadius = hair.frame.height/2
        hair.clipsToBounds = true
        
        view.addSubview(hair)
        
        let eyelashes = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        eyelashes.center.x = self.view.center.x - (gap/2)
        eyelashes.center.y = height
        eyelashes.image = #imageLiteral(resourceName: "default_profile")
        eyelashes.layer.borderWidth = 1
        eyelashes.layer.masksToBounds = false
        eyelashes.layer.borderColor = UIColor.rgb(r: 240, g: 98, b: 96).cgColor
        eyelashes.layer.cornerRadius = eyelashes.frame.height/2
        eyelashes.clipsToBounds = true
        
        view.addSubview(eyelashes)
        
        let makeup = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        makeup.center.x = self.view.center.x + (gap/2)
        makeup.center.y = height
        makeup.image = #imageLiteral(resourceName: "default_profile")
        makeup.layer.borderWidth = 1
        makeup.layer.masksToBounds = false
        makeup.layer.borderColor = UIColor.rgb(r: 240, g: 98, b: 96).cgColor
        makeup.layer.cornerRadius = makeup.frame.height/2
        makeup.clipsToBounds = true
        
        view.addSubview(makeup)

        let eyebrows = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        eyebrows.center.x = self.view.center.x + (gap*1.5)
        eyebrows.center.y = height
        eyebrows.image = #imageLiteral(resourceName: "default_profile")
        eyebrows.layer.borderWidth = 1
        eyebrows.layer.masksToBounds = false
        eyebrows.layer.borderColor = UIColor.rgb(r: 240, g: 98, b: 96).cgColor
        eyebrows.layer.cornerRadius = eyebrows.frame.height/2
        eyebrows.clipsToBounds = true

        view.addSubview(eyebrows)
    }
    
    private func addCategoryLabels(_ view: UIView) {
        // add Label for the declared category
        let height:CGFloat = 192
        let gap = self.view.frame.width / 5
        
        let hair = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        hair.center.x = self.view.center.x - (gap*1.5)
        hair.center.y = height
        hair.text = "Hair"
        hair.textColor = .black
        hair.textAlignment = NSTextAlignment.center
        hair.font = UIFont(name: hair.font.fontName, size: 11)
        view.addSubview(hair)
        
        let eyelashes = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        eyelashes.center.x = self.view.center.x - (gap/2)
        eyelashes.center.y = height
        eyelashes.text = "Eyelashes"
        eyelashes.textColor = .black
        eyelashes.textAlignment = NSTextAlignment.center
        eyelashes.font = UIFont(name: eyelashes.font.fontName, size: 11)
        view.addSubview(eyelashes)
        
        let makeup = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        makeup.center.x = self.view.center.x + (gap/2)
        makeup.center.y = height
        makeup.text = "Makeup"
        makeup.textColor = .black
        makeup.textAlignment = NSTextAlignment.center
        makeup.font = UIFont(name: makeup.font.fontName, size: 11)
        view.addSubview(makeup)
        
        let eyebrows = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        eyebrows.center.x = self.view.center.x + (gap*1.5)
        eyebrows.center.y = height
        eyebrows.text = "Eyebrows"
        eyebrows.textColor = .black
        eyebrows.textAlignment = NSTextAlignment.center
        eyebrows.font = UIFont(name: eyebrows.font.fontName, size: 11)
        view.addSubview(eyebrows)
    }
    
    // create the bottom part of the profile screen, favourite item(s) for each category
    private lazy var _menuVC: BXPageMenuController = {
        
        let menuItemsLabels: [BXMenuBarCellType] = [
            .label("Hair"),
            .label("Eyelashes"),
            .label("Makeup"),
            .label("Eyebrows")
        ]
        
        let vc = BXPageMenuController(getCategoryVC(),
                                      menuItems: menuItemsLabels,
                                      initialViewControllerIndex: 0)
        return vc
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if the user is logged in. if so show profile page, otherwise prompt login options
        // hardcoded true for now, so will always show when the app is first launched.
        if true {
            let loginOptions = LoginOptionsViewController()
            self.navigationController?.pushViewController(loginOptions, animated: true)
        }
        
        navigationItem.title = "MY BEAUTY XPERT"
        view.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        let logoutButton = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(showLogin))
        // set the login button
        navigationItem.rightBarButtonItem = logoutButton
        setupUI()
    }
    
    @objc func showLogin() {
        let newViewController = LoginOptionsViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    private func setupUI(){
        
        // adding the upper half of profile screen into VC's view
        view.addSubviews([_topView])
        
        
        addChildViewController(_menuVC)
        // adding the lower half of profile screen into VC's view
        view.addSubview(_menuVC.view)
        
        _menuVC.view.translatesAutoresizingMaskIntoConstraints = false // this line is used to enable our constraints
        _menuVC.view.layoutTo(edges: [.left, .right], ofView: view, withMargin: 0)
        _menuVC.didMove(toParentViewController: self) // this line ensures child VC's viewWillAppear() will get call
        
        _topView.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor
        
        // The following is used to set up the constraint for both upper and lower half of the profile screen
        NSLayoutConstraint.activate([
            
            _topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _topView.leftAnchor.constraint(equalTo: view.leftAnchor),
            _topView.rightAnchor.constraint(equalTo: view.rightAnchor),
            _topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            _menuVC.view.topAnchor.constraint(equalTo: _topView.bottomAnchor),
            _menuVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getCategoryVC() -> [UIViewController] {
        let favManager = UserDefaultManager()
        // sets up each category tab, loaded into PhotosVC view controller (grid of photos)
        
        let pgManager_hair = favManager.loadInstaItems(forCategory: .hair)
        let vm_hair = PhotosViewModel(instaItems: pgManager_hair, favManager: favManager)
        vm_hair.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_hair = ProfileVC(viewModel: vm_hair, cat: .hair)
        
        // it pulls from server
        let pgManager_eyelash = favManager.loadInstaItems(forCategory: .eyelashes)
        let vm_eyelash = PhotosViewModel(instaItems: pgManager_eyelash, favManager: favManager)
        vm_eyelash.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_eyelash = ProfileVC(viewModel: vm_eyelash, cat: .eyelashes)
        
        let pgManager_makeup = favManager.loadInstaItems(forCategory: .makeup)
        let vm_makeup = PhotosViewModel(instaItems: pgManager_makeup, favManager: favManager)
        vm_makeup.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_makeup = ProfileVC(viewModel: vm_makeup, cat: .makeup)
        
        let pgManager_eyebrow = favManager.loadInstaItems(forCategory: .eyebrows)
        let vm_eyebrow = PhotosViewModel(instaItems: pgManager_eyebrow, favManager: favManager)
        vm_eyebrow.showXpert = { [weak self] item in
            self?.showProfile(forItem: item)
        }
        let vc_eyebrow = ProfileVC(viewModel: vm_eyebrow, cat: .eyebrows)
        return [vc_hair, vc_eyelash, vc_makeup, vc_eyebrow]
    }
    
    private func showProfile(forItem item: InstaItem) {
        let coordinator = XpertWithUsernameRemote(xpertInstaUsername: item.instaUsername)
        let vc = LoadingViewController(coordinator: coordinator)
        // viewController?.pushViewController(vc, animated: true)
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
