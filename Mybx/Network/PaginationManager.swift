//
//  BXWebService.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-25.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import Foundation

struct PaginationOptions {
    let pageSize: Int
    let pageNumber: Int
}

extension PaginationOptions {
    static var defaultOptions: PaginationOptions {
        return PaginationOptions(pageSize: 20, pageNumber: 1)
    }
}


final class PaginationManager<T> {
    
    private let _resource: Resource<T>
    private var _paginationOptions: PaginationOptions
    
    init(resource: Resource<T>, paginationOptions: PaginationOptions =  .defaultOptions) {
        _resource = resource
        _paginationOptions = paginationOptions
    }
    
    func loadNextPage(completion: @escaping (Result<T>)->()){
        let updatedResource = _resource.resourceForNextPage(withOptions: _paginationOptions)
        _ = WebServiceInterface.Manager.shared.load(updatedResource, completion: completion)
    }
    
    func updatePagination(withOptions options: PaginationOptions) {
        _paginationOptions = options
    }
    
    func updateForNextPage() {
        _paginationOptions = PaginationOptions(pageSize: _paginationOptions.pageSize, pageNumber: _paginationOptions.pageNumber + 1)
    }
    
}
