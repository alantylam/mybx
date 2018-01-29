//
//  XpertViewModel.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-26.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

protocol XpertListViewModelInputs {
    func selectedProfileFor(xpert: Xpert)
    func fetchNextPage()
    func viewDidLoad()
}

protocol XpertListViewModelOutputs {

    var xperts: [Xpert] { get }
    var numberOfItems: Int { get }
    var isLastPage: Bool { get }
    subscript(x:Int) -> Xpert? {get }
    var appendNextPage: (([IndexPath]) -> ()) { get set }
    var nextPageFailed: ((Error) -> ()) { get set }
}

protocol XpertListViewModelType {
    var inputs: XpertListViewModelInputs { get }
    var outputs: XpertListViewModelOutputs { get set }
}

final class XpertListViewModel: XpertListViewModelType, XpertListViewModelInputs, XpertListViewModelOutputs {
  
    
    // MARK: - public properties
    
    var selectedXpert: ((Xpert) -> ()) = { _ in }
    
   
    // MARK: - properties + inits
    
    private var _xperts: [Xpert]
    private let _pgManager: PaginationManager<[Xpert]>
    private let _xpertsFavManager: XpertsFavManager
    private var _isLastPage = false
    private var _nextPage = 1
    
    init(pgManager: PaginationManager<[Xpert]>, xpertsFavManager: XpertsFavManager = UserDefaultManager()) {
        _xperts = []
         _pgManager = pgManager
        _xpertsFavManager = xpertsFavManager
    }
    
    
    // MARK: - Inputs
    
    func viewDidLoad() {}
    
    func fetchNextPage() {
        
        let newPage = PaginationOptions(pageSize: PaginationOptions.defaultOptions.pageSize, pageNumber: _nextPage)
        _pgManager.updatePagination(withOptions: newPage)
        
        _pgManager.loadNextPage { [weak self] (res) in
            guard let strongSelf = self else { return }
            switch res {
            case .success(let items):
                var indexPaths = [IndexPath]()
                for item in items {
                    strongSelf._xperts.append(item)
                    indexPaths.append(IndexPath(item: strongSelf._xperts.count - 1, section: 0))
                }
                strongSelf._nextPage += 1
                strongSelf._isLastPage = items.isEmpty
                strongSelf.appendNextPage(indexPaths)
                
            case .failure(let error):
                strongSelf.nextPageFailed(error)
                print(error)
            }
        }
    }
    
    func selectedProfileFor(xpert: Xpert) {
        selectedXpert(xpert)
    }
    

    // MARK: - outputs
    
    var numberOfItems: Int { return _xperts.count }
    subscript(x: Int) -> Xpert? { return _xperts.at(index: x) }
    var xperts: [Xpert] { return _xperts }
    var isLastPage: Bool { return _isLastPage }
    var appendNextPage: (([IndexPath]) -> ()) = { _ in }
    var nextPageFailed: ((Error) -> ()) = { _ in }
    
    
    // MARK: XpertListViewModelType
    
    var inputs: XpertListViewModelInputs { return self }
    var outputs: XpertListViewModelOutputs { get { return self } set {} }
    
}

