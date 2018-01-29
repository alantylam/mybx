//
//  LoadingViewController.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-29.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit


final class LoadingViewController<T: RemoteContent>: UIViewController {
    
    fileprivate let coordinator: T
    fileprivate weak var loadedViewController: UIViewController?
    weak var delegate: RemoteViewDelegate?
    
    // MARK: - UI
    
    fileprivate lazy var loadingIndicator: LoadingViewIndicator = {
        let view = LoadingViewIndicator()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(coordinator: T) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = StyleSheet.defaultTheme.backgroundColor
        loadContent()
    }
    
    
    fileprivate func loadContent() {
        addLoadingView()
        
        loadingIndicator.startAnimating()
        loadingIndicator.text = coordinator.loadingText
        
        coordinator.fetchContent { [weak self] content in
            guard let strongSelf = self else { return }
            strongSelf.removeLoadingView()
            let vc = strongSelf.coordinator.viewControllerForContent(content: content)
            strongSelf.loadedViewController = vc
            strongSelf.delegate?.willAddContent()
            strongSelf.add(childViewController: vc)
            strongSelf.delegate?.didAddContent()
            strongSelf.title = vc.title
        }
    }
    
    fileprivate func addLoadingView() {
        view.addSubview(loadingIndicator)
        
        loadingIndicator.center()
        loadingIndicator.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loadingIndicator.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    fileprivate func removeLoadingView() {
        loadingIndicator.removeFromSuperview()
    }
}

extension LoadingViewController: Refreshable {

    func refresh() {
        
        loadedViewController >>>= {
            remove(childViewController: $0)
        }
        
        loadContent()
    }
    
}




