//
//  File.swift
//  Mybx
//
//  Created by Amjad Al-Absi on 2017-11-20.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation


protocol XpertsFavManager {
    
    func appendXpert(_ xpert: Xpert)
    func removeXpert(_ xpert: Xpert)
    func loadXperts() -> [Xpert]
    func isAlreadyFavoured(_ xpert: Xpert) -> Bool
}

protocol InstaFavManager {
    
    func appendInstaItem(_ item: InstaItem)
    func removeInstaItem(_ item: InstaItem)
    func loadInstaItems(forCategory category: BXCategory) -> [InstaItem]
    func removeInstaItems(forCategory category: BXCategory) -> [InstaItem]?
    func isAlreadyFavoured(_ instaItem: InstaItem) -> Bool
}

final class UserDefaultManager: InstaFavManager, XpertsFavManager {
    
    private let _instaItemsKey = "BXFAVOURATEITEMS"
    private let _xpertsKey = "XPERT_KEY_SHALL_BE_RANDOM"
    private let _userDefault = UserDefaults.standard
    
    
    func appendInstaItem(_ item: InstaItem) {
        var newItems = [InstaItem]()
        if let oldItems = (_userDefault.value(forKey: _instaItemsKey) as? [JSONDict])?.flatMap(InstaItem.init) {
            newItems = oldItems
        }
        
        if !newItems.contains(item) {
            newItems.append(item)
            _userDefault.set(newItems.map { $0.convertToJson() }, forKey: _instaItemsKey)
        }
    }
    
    func removeInstaItem(_ item: InstaItem) {
        if let oldInstaItems = (_userDefault.object(forKey: _instaItemsKey) as? [JSONDict])?.flatMap(InstaItem.init) {
            var newItems = oldInstaItems
            newItems.remove(item)
            _userDefault.set(newItems.map { $0.convertToJson() }, forKey: _instaItemsKey)
        }
    }
    
    func loadInstaItems(forCategory category: BXCategory) -> [InstaItem] {
        if let instaItems = (_userDefault.object(forKey: _instaItemsKey) as? [JSONDict])?.flatMap(InstaItem.init) {
            return instaItems.filter { $0.categories.contains(category) }
        }
        return []
    }
    
    func removeInstaItems(forCategory category: BXCategory) -> [InstaItem]? {
        if let instaItems = (_userDefault.object(forKey: _instaItemsKey) as? [JSONDict])?.flatMap(InstaItem.init) {
            var newItems = instaItems
            let removedItems = newItems.remove { $0.categories.contains(category) }
            _userDefault.set(newItems.map { $0.convertToJson() }, forKey: _instaItemsKey)
            return removedItems
        }
        return nil
    }
    
    func isAlreadyFavoured(_ instaItem: InstaItem) -> Bool {
        let items = loadInstaItems(forCategory: instaItem.categories.first!)
        return items.contains(instaItem)
    }
    
    
    // MARK: - Xperts
    
    func appendXpert(_ xpert: Xpert) {
        var newXperts = [Xpert]()
        if let oldXperts = (_userDefault.value(forKey: _xpertsKey) as? [JSONDict])?.flatMap(Xpert.init) {
            newXperts = oldXperts
        }
        if !newXperts.contains(xpert) {
            newXperts.append(xpert)
            _userDefault.set(newXperts.map { $0.convertToJson() }, forKey: _xpertsKey)
        }
    }
    
    func removeXpert(_ xpert: Xpert) {
        if let oldXperts = (_userDefault.object(forKey: _xpertsKey) as? [JSONDict])?.flatMap(Xpert.init) {
            var newXperts = oldXperts
            newXperts.remove(xpert)
            _userDefault.set(newXperts.map { $0.convertToJson() }, forKey: _xpertsKey)
        }
    }
    
    func loadXperts() -> [Xpert] {
        let x = (_userDefault.object(forKey: _xpertsKey) as? [JSONDict])?.flatMap(Xpert.init)
        return x ?? []
    }
    
    func isAlreadyFavoured(_ xpert: Xpert) -> Bool {
        return loadXperts().contains(xpert)
    }
}
