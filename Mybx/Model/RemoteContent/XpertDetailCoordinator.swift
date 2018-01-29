//
//  XpertDetailCoordinator.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-01.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//


import UIKit


struct XpertWithUsernameRemote: RemoteContent {
    
    private let _xpertInstaUsername: String
    
    
    init(xpertInstaUsername: String) {
        _xpertInstaUsername = xpertInstaUsername
    }
    
    var loadingText: String { return "Loading \(self._xpertInstaUsername) Xpert Profile Information" }
    
    func fetchContent(completion: @escaping ((Result<(xpert: Xpert, items: [InstaItem])>) -> ())) {
        _ = WebServiceInterface.Manager.shared.load(Xpert.infoAndInstaItemsForXpert(withUsername: _xpertInstaUsername),
                                                completion: completion)
    }
    
    func viewControllerForContent(content: Result<(xpert: Xpert, items: [InstaItem])>) -> UIViewController {
        switch content {
        case .success(let data):
            let viewModel = XpertProfileViewModel(xpert: data.xpert, instaItems: data.items)
            let xperVC = XpertProfileScreenVC(viewModel: viewModel)
            return xperVC
        case .failure(let error):
            return ErrorVC(error: error)
        }
    }
}


