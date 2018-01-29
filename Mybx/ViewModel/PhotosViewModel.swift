//
//  XpertPhotosViewModel.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-29.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

protocol PhotosViewModelInputs {
    func viewDidLoad()
    func fetchNextPage()
    func openInInstagram(_ item: InstaItem)
    func addToFav(_ item: InstaItem)
    func removeFromFav(_ item: InstaItem)
    func showXpert(forItem: InstaItem)
    func report(_ item: InstaItem, completion: @escaping (Result<Bool>) -> ())
}

protocol PhotosViewModelOutputs {
    var instaItems: [InstaItem] { get }
    var numberOfItems: Int { get }
    var isLastPage: Bool { get }
    var appendNextPage: (([IndexPath]) -> ()) { get set }
    var nextPageFailed: ((Error) -> ()) { get set }
    
    subscript(index: Int) -> InstaItem { get }
    
    func index(of item: InstaItem) -> Int?
    func isAlreadyFavoured(_ instaItem: InstaItem) -> Bool
}

protocol PhotosViewModelType {
    var inputs: PhotosViewModelInputs { get }
    var outputs: PhotosViewModelOutputs { get set }
}

final class PhotosViewModel: PhotosViewModelType, PhotosViewModelInputs, PhotosViewModelOutputs {
  
    // MARK: - public Properties
    
    var showXpert: ((InstaItem) -> Void) = { _ in }
    
  
    // MARK: - Properties + Inits
    
    private var _instaItems: [InstaItem]
    private let _favManager: InstaFavManager
    private var _pgManager: PaginationManager<[InstaItem]>? = nil
    private var _nextPage: Int
    private var _isLastPage: Bool
    private var _pageSize: Int {
        return PaginationOptions.defaultOptions.pageSize
    }

    
    init(favManager: InstaFavManager, pgManager: PaginationManager<[InstaItem]>) {
        _instaItems = []
        _favManager = favManager
        _pgManager = pgManager
        _nextPage = 1
        _isLastPage = false
    }

    init(instaItems: [InstaItem], favManager: InstaFavManager) {
        _instaItems = instaItems
        _favManager = favManager
        _pgManager = nil
        _nextPage = 1
        _isLastPage = true
    }
    
    //MARK: - inputs
    
    func viewDidLoad() {}
    
    func fetchNextPage() {
        guard !isLastPage else { return }
        let newOptions = PaginationOptions(pageSize: _pageSize, pageNumber: _nextPage)
        _pgManager?.updatePagination(withOptions: newOptions)
        
        _pgManager?.loadNextPage { [weak self] (res) in
            guard let strongSelf = self else { return }
            switch res {
            case .success(let items):
                strongSelf._nextPage += 1
                strongSelf._isLastPage = items.isEmpty

                let indexPaths = items.map { item -> IndexPath in
                    strongSelf._instaItems.append(item)
                    return IndexPath(item: strongSelf._instaItems.count - 1, section: 0)
                }
                mainQueue {
                    strongSelf.appendNextPage(indexPaths)
                }
            case .failure(let error):
                strongSelf.nextPageFailed(error)
                print(error)
            }
        }
    }

    func openInInstagram(_ item: InstaItem) {
        let components = item.instaUrl.absoluteString.components(separatedBy: "/").filter { $0 != "" }
        if let id = components.last {
            InstagramManager.shared.openMedia(withId: id)
        }
    }
    
    func addToFav(_ item: InstaItem) {
        _favManager.appendInstaItem(item)
    }
    
    func removeFromFav(_ item: InstaItem) {
        _favManager.removeInstaItem(item)
    }
    
    func report(_ item: InstaItem, completion: @escaping (Result<Bool>) -> ()) {
        _ = WebServiceInterface.Manager.shared.load(InstaItem.report(item: item), completion: completion)
    }
    
    func showXpert(forItem item: InstaItem) {
        showXpert(item)
    }
    
    
    //MARK: - outputs
    
    var instaItems: [InstaItem] { return _instaItems }
    var numberOfItems: Int { return _instaItems.count }
    var appendNextPage: (([IndexPath]) -> ()) = { _ in }
    var nextPageFailed: ((Error) -> ()) = { _ in }
    var isLastPage: Bool { return _isLastPage }

    subscript(index: Int) -> InstaItem {
        return _instaItems[index]
    }
    
    func isAlreadyFavoured(_ instaItem: InstaItem) -> Bool {
        return _favManager.isAlreadyFavoured(instaItem)
    }
    
    func index(of item: InstaItem) -> Int? {
        return _instaItems.index(of: item)
    }
    

    // MARK: PhotosViewModelType
    
    var inputs: PhotosViewModelInputs { return self }
    var outputs: PhotosViewModelOutputs { get {return self } set {}}
    
}

