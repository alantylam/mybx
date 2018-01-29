//
//  MyBxViewModel.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-12-14.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

protocol MyBxViewModelInputs {
  
    func viewWillAppear()
    func selected(xpert: Xpert)
    func selected(item: InstaItem)
}

protocol MyBxViewModelOutputs {

    var xperts: [Xpert] { get }
    var hairs: [InstaItem] { get }
    var eyelashes: [InstaItem] { get }
    var makeup: [InstaItem] { get }
    var eyebrows: [InstaItem] { get }
    
    var xpertsHeight: Float { get }
    var hairsHeight: Float { get }
    var eyelashesHeight: Float { get }
    var makeupHeight: Float { get }
    var eyebrowsHeight: Float { get }
    
    func getNextInstaItem(forSection section: Int?, andIndex index: Int) -> InstaItem?
}

protocol MyBxViewModelType {
    var inputs: MyBxViewModelInputs { get }
    var outputs: MyBxViewModelOutputs { get }
}

final class MyBxViewModel: MyBxViewModelType, MyBxViewModelInputs, MyBxViewModelOutputs {
    
    
    // MARK: - Inits + Properties
    
    private var _xperts = [Xpert]()
    private var _hairs = [InstaItem]()
    private var _eyelashes = [InstaItem]()
    private var _makeup = [InstaItem]()
    private var _eyebrows = [InstaItem]()
    
    // MARK: - MyBxViewModelInputs
    
    func viewWillAppear() {
        let favManager = UserDefaultManager()
        
        _xperts = favManager.loadXperts()
        _hairs = favManager.loadInstaItems(forCategory: .hair)
        _eyelashes = favManager.loadInstaItems(forCategory: .eyelashes)
        _makeup = favManager.loadInstaItems(forCategory: .makeup)
        _eyebrows = favManager.loadInstaItems(forCategory: .eyebrows)
    }
    
    func selected(xpert: Xpert) {
        
    }
    
    func selected(item: InstaItem) {
        
    }
    
    // MARK: - MyBxViewModelOutputs
    
    var xperts: [Xpert] { return _xperts }
    var hairs: [InstaItem] { return _hairs }
    var eyelashes: [InstaItem] { return _eyelashes}
    var makeup: [InstaItem] { return _makeup }
    var eyebrows: [InstaItem] { return _eyebrows }
    
    var xpertsHeight: Float {
        return _xperts.count > 0 ? 240 : 0
    }
    var hairsHeight: Float {
        return _hairs.count > 0 ? 200 : 0
    }
    var eyelashesHeight: Float {
        return _eyelashes.count > 0 ? 200 : 0
    }
    var makeupHeight: Float {
        return _makeup.count > 0 ? 200 : 0
    }
    var eyebrowsHeight: Float {
        return _eyebrows.count > 0 ? 200 : 0
    }
    
    func getNextInstaItem(forSection section: Int?, andIndex index: Int) -> InstaItem? {
        switch section {
        case .some(0):
            return _hairs.at(index: index)
        case .some(1):
            return _eyelashes.at(index: index)
        case .some(2):
            return _makeup.at(index: index)
        case .some(3):
            return _eyebrows.at(index: index)
        default:
            return nil
        }
        
    }
    
    
    // MARK: - MyBxViewModelType
    
    var inputs: MyBxViewModelInputs { return self }
    var outputs: MyBxViewModelOutputs { return self }
    
    
}






