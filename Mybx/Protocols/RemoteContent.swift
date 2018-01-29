//
//  RemoteContent.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-01.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

public protocol RemoteViewDelegate: class {
    func willAddContent()
    func didAddContent()
}

protocol RemoteContent {
    associatedtype Content
    
    var loadingText: String { get }
    
    func fetchContent(completion: @escaping (Result<Content>) -> Void)
    func viewControllerForContent(content: Result<Content>) -> UIViewController
}
