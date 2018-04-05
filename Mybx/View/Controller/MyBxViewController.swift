//
//  MyBxViewController.swift
//  Mybx
//
//  Created by Amjad Al-Absi on 2017-11-21.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift


private enum Sections {
    case xperts, hair, eyelashes, makeup, eyebrows
}


final class MyBXViewController: UITableViewController {

    
    private let _viewModel: MyBxViewModelType
    
    init(viewModel: MyBxViewModelType) {
        _viewModel =  viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var sections: [Sections] = [.xperts, .hair, .eyelashes, .makeup, .eyebrows]
    private var _selectedSection: Int?
    private var _selectedFrame: CGRect?
    private var _photoSlider: PhotoSlider?
    private var _instaItemIndex = 0
    private var _firstELement = 0
    private var _isFirstElement: Bool {
        return _instaItemIndex == _firstELement
    }
    private var _hasShownFirstELement = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // PLACEHOLDER: sets up table view of favourites
        setupTableView()
        
        let newViewController = LoginOptionsViewController()
        
        self.hideKeyboardWhenTappedAround()
        
        //newViewController.navigationController?.navigationItem.rightBarButtonItem = btnCancel
        self.navigationController?.pushViewController(newViewController, animated: true)
        /*
        if (true) {
            setupLoginOptions()
        }
 */
        let loginButton = UIBarButtonItem(title: "Login", style: .done, target: self, action: #selector(showLogin))
        navigationItem.rightBarButtonItem = loginButton
    }
    
    @objc func showLogin() {
        let newViewController = LoginOptionsViewController()
        
        //newViewController.navigationController?.navigationItem.rightBarButtonItem = btnCancel
        self.navigationController?.pushViewController(newViewController, animated: true)
        //setupLoginOptions()
    }
    
    private func setupLoginOptions() {
        // TODO: google button
        
        let secondViewController:LoginOptionsViewController = LoginOptionsViewController()
        
        secondViewController.tabBarItem = UITabBarItem(title: "MyBX", image: #imageLiteral(resourceName: "my_bx"), selectedImage: #imageLiteral(resourceName: "my_bx"))
        
        let navController = UINavigationController(rootViewController: secondViewController)
        
        let btnDone = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissNav))
        //btnDone.tintColor = UIColor.blue
        navController.topViewController?.navigationItem.rightBarButtonItem = btnDone
        navController.topViewController?.title = "Login Options"
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func dismissNav() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.register(InstaItemsFavouratesCell.self)
        tableView.register(XpertsFavouratesCell.self)
        
        tableView.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        if (true) {
            setupLoginOptions()
        }*/
        _viewModel.inputs.viewWillAppear()
        tableView.reloadData()
    }
    
    
    @objc func removePreviewView() {
        _selectedSection = nil
        _photoSlider?.hide()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .xperts:
            let cell: XpertsFavouratesCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.xperts = _viewModel.outputs.xperts
            cell.delegate = self
            return cell
        case .hair:
            let cell: InstaItemsFavouratesCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.instaItems = _viewModel.outputs.hairs
            cell.delegate = self
            return cell
        case .eyelashes:
            let cell: InstaItemsFavouratesCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.instaItems = _viewModel.outputs.eyelashes
            cell.delegate = self
            return cell
        case .makeup:
            let cell: InstaItemsFavouratesCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.instaItems = _viewModel.outputs.makeup
            cell.delegate = self
            return cell
        case .eyebrows:
            let cell: InstaItemsFavouratesCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.instaItems = _viewModel.outputs.eyebrows
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .xperts:
            return CGFloat(_viewModel.outputs.xpertsHeight)
        case .hair:
            return CGFloat(_viewModel.outputs.hairsHeight)
        case .eyelashes:
            return CGFloat(_viewModel.outputs.eyelashesHeight)
        case .makeup:
            return CGFloat(_viewModel.outputs.makeupHeight)
        case .eyebrows:
            return CGFloat(_viewModel.outputs.eyebrowsHeight)
        }
    }

}

extension MyBXViewController: InstaItemsFavouratesCellDelegate {
    
    func didSelectItem(_ item: InstaItem, in frame: CGRect, withIndex index: Int) {
        
        switch item.categories.first! {
        case .hair:
            _selectedSection = 0
        case .eyelashes:
            _selectedSection = 1
        case .makeup:
            _selectedSection = 2
        case .eyebrows:
            _selectedSection = 3
        default:
            break
        }
        
        _selectedFrame = frame
        _instaItemIndex = index
        _firstELement = index
        showCardPreviewView_v2(forItem: item)
    }
    
}


extension MyBXViewController: XpertsFavouratesCellDelegate {
    
    func didSelectItem(_ xpert: Xpert, in frame: CGRect, withIndex index: Int) {
        let coordinator = XpertWithUsernameRemote(xpertInstaUsername: xpert.instaUsername)
        let vc = LoadingViewController(coordinator: coordinator)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyBXViewController {

    private func updateNextIndicies() {
        switch _selectedSection {
        case .some(0):
            _instaItemIndex = _instaItemIndex >= (_viewModel.outputs.hairs.count - 1) ? 0 : (_instaItemIndex + 1)
        case .some(1):
            _instaItemIndex = _instaItemIndex >= (_viewModel.outputs.eyelashes.count - 1) ? 0 : (_instaItemIndex + 1)
        case .some(2):
            _instaItemIndex = _instaItemIndex >= (_viewModel.outputs.makeup.count - 1) ? 0 : (_instaItemIndex + 1)
        case .some(3):
            _instaItemIndex = _instaItemIndex >= (_viewModel.outputs.eyebrows.count - 1) ? 0 : (_instaItemIndex + 1)
        default:
            break
        }
    }
    
    private func updatePrevIndicies() {
        switch _selectedSection {
        case .some(0):
            _instaItemIndex = _instaItemIndex == 0 ? (_viewModel.outputs.hairs.count - 1) : _instaItemIndex - 1
        case .some(1):
            _instaItemIndex = _instaItemIndex == 0 ? (_viewModel.outputs.eyelashes.count - 1) : _instaItemIndex - 1
        case .some(2):
            _instaItemIndex = _instaItemIndex == 0 ? (_viewModel.outputs.makeup.count - 1) : _instaItemIndex - 1
        case .some(3):
            _instaItemIndex = _instaItemIndex == 0 ? (_viewModel.outputs.eyebrows.count - 1) : _instaItemIndex - 1
        default:
            break
        }
    }
    
}


extension MyBXViewController: InstaItemPreviewDelegate {
    
    func clickedOnXpertBtn(forItem item: InstaItem) {
        removePreviewView()
        
        let coordinator = XpertWithUsernameRemote(xpertInstaUsername: item.instaUsername)
        let vc = LoadingViewController(coordinator: coordinator)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addToFavourates(_ instaItem: InstaItem) {
        
        guard let prev = _photoSlider?.topView, let window = UIApplication.shared.keyWindow else { return }
        UserDefaultManager().appendInstaItem(instaItem)

        // animate the dismissals
        
        UIView.animate(withDuration: 0.33, animations: {
            prev.transform = CGAffineTransform(scaleX: 0.35, y: 0.2)
            prev.center = CGPoint(x: window.frame.width - 50, y: window.frame.height - 20)
            prev.alpha = 0.0
        }) { (done) in
            self._photoSlider?.dismissTopView()
        }
    }
    
    func removeFromFavourates(_ instaItem: InstaItem) {
        UserDefaultManager().removeInstaItem(instaItem)
    }
    
    func clickedInstagramBtn(forItem item: InstaItem) {
        let components = item.instaUrl.absoluteString.components(separatedBy: "/").filter { $0 != "" }
        if let id = components.last {
            InstagramManager.shared.openMedia(withId: id)
        }
    }
    
    func clickedReportBtn(forItem item: InstaItem) {
        _ = WebServiceInterface.Manager.shared.load(InstaItem.report(item: item)){ [weak self] res in
            switch res {
                case .success(let bool):
                    print("Success \(bool)")
            case .failure(let error):
                print(error)
            }
            self?.removePreviewView()
        }
        
    }
    
}


extension MyBXViewController: PhotoSliderDelegate {
    
    func previousInstaItem() -> (item: InstaItem, size: CGSize) {
        if !_isFirstElement || _hasShownFirstELement {
            updatePrevIndicies()
        } else {
            _hasShownFirstELement = true
        }
        
        return (item: _viewModel.outputs.getNextInstaItem(forSection: _selectedSection, andIndex: _instaItemIndex)!, size: _selectedFrame!.size)
    }
    
    func hideSlider() {
        _hasShownFirstELement = false
    }

    private func showCardPreviewView_v2(forItem item: InstaItem) {
        guard let cellFrame = _selectedFrame else { return }

        _photoSlider = PhotoSlider(firstItem: item, firstItemFrame: cellFrame, isProfile: false, rateSize: CGSize(width: 2, height: 2))
        _photoSlider?.delegate = self
        _photoSlider?.show()
    }

    func isAlreadyFavoured(_ instaItem: InstaItem) -> Bool {
        return true
    }

    func nextInstaItem() -> (item: InstaItem, size: CGSize) {
        if !_isFirstElement || _hasShownFirstELement {
            updateNextIndicies()
        } else {
            _hasShownFirstELement = true
        }
        return (item:  _viewModel.outputs.getNextInstaItem(forSection: _selectedSection, andIndex: _instaItemIndex)!, size: _selectedFrame!.size)
    }

}

