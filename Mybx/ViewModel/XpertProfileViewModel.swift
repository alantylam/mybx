//
//  XpertProfileViewModel.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-27.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

protocol XpertProfileViewModelInputs {
    func addToFav(_ xpert: Xpert)
    func removeFromFav(_ xpert: Xpert)
}

protocol XpertProfileViewModelOutputs {
    var xpert: Xpert { get }
    var instaItems: [InstaItem] { get }
    func isAlreadyFavoured(_ xpert: Xpert) -> Bool
    
}

protocol XpertProfileViewModelType {
    var inputs: XpertProfileViewModelInputs { get }
    var outputs: XpertProfileViewModelOutputs { get }
}

final class XpertProfileViewModel: XpertProfileViewModelType, XpertProfileViewModelInputs, XpertProfileViewModelOutputs {
    

    // MARK: - properties + inits

    private let _xpert: Xpert
    private let _instaItems: [InstaItem]
    private let _favManager: XpertsFavManager
    
    init(xpert: Xpert, instaItems: [InstaItem] = []) {
        self._xpert = xpert
        self._instaItems = instaItems
        _favManager = UserDefaultManager()
    }
    
    // MARK: - inputs

    func addToFav(_ xpert: Xpert) {
        _favManager.appendXpert(xpert)
    }
    
    func removeFromFav(_ xpert: Xpert) {
        _favManager.removeXpert(xpert)
    }
    
    // MARK: - outputs
    
    var xpert: Xpert { return _xpert }
    var instaItems: [InstaItem] { return _instaItems }
    
    func isAlreadyFavoured(_ xpert: Xpert) -> Bool {
        return _favManager.isAlreadyFavoured(xpert)
    }
   
    
    // MARK: - XpertProfileViewModelType
    
    var inputs: XpertProfileViewModelInputs { return self }
    var outputs: XpertProfileViewModelOutputs { return self }
    

}






