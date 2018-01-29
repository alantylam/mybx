//
//  XpertProfileScreen.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-24.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import XLActionController

final class XpertProfileScreenVC: UIViewController {
    
    private let _viewModel: XpertProfileViewModelType
    
    private var _profileInfoViewTopConstraint: NSLayoutConstraint?
    
    private lazy var _profileInfoView: XpertInfoView = {
        let view = XpertInfoView(frame: .zero, showInstagramIcon: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor
        view.setAsCardView()
        view.xpert = self._viewModel.outputs.xpert
        view.delegate = self
        return view
    }()
    
    private lazy var _imagesVC: PhotosVC = {
        let fv = UserDefaultManager()
        let vm = PhotosViewModel(instaItems: _viewModel.outputs.instaItems, favManager: fv)
        return PhotosVC(viewModel: vm, isProfile: true)
    }()
    
    init(viewModel: XpertProfileViewModelType) {
        _viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        view.addSubviews([_profileInfoView])
        
        _profileInfoViewTopConstraint = _profileInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        _profileInfoViewTopConstraint?.isActive = true
        
        _profileInfoView.layoutTo(edges: [.left, .right], ofView: self.view, withMargin: 8)
        _profileInfoView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        addChildViewController(_imagesVC)
        view.addSubview(_imagesVC.view)
        view.setAsCardView()
        _imagesVC.view.translatesAutoresizingMaskIntoConstraints = false
        _imagesVC.view.layoutTo(edges: [.left, .right, .bottom], ofView: view, withMargin: 4)
        _imagesVC.view.topAnchor.constraint(equalTo: _profileInfoView.bottomAnchor, constant: 8).isActive = true
        _imagesVC.didMove(toParentViewController: self)
    }
}


extension XpertProfileScreenVC: XpertInfoViewDelegate {
    func clickedOnMoreBtn(with expert: Xpert) {

        let actionController = YoutubeActionController()
        let action = Action<ActionData>(ActionData(title: "View In Instagram"), style: .default) { i in
            InstagramManager.shared.openUserAccount(withUsername: expert.instaUsername)
        }
        actionController.addAction(action)
        
        let isAlr = _viewModel.outputs.isAlreadyFavoured(expert)
        let title = isAlr ? "Remove From Favorites" : "Add To Favorites"
        let action2 = Action<ActionData>(ActionData(title: title), style: .default) { i in
            if isAlr {
                self._viewModel.inputs.removeFromFav(expert)
            } else {
                self._viewModel.inputs.addToFav(expert)
            }
        }
        actionController.addAction(action2)
        
        let cancelAction = ActionData(title: "Cancel")
        actionController.addSection(Section())
        actionController.addAction(Action(cancelAction, style: .cancel, handler:nil))

        present(actionController, animated: true, completion: nil)
    }
}
