//
//  ErrorVC.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-01.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

final class ErrorVC: UIViewController {
    
    private let _error: Error
    private weak var _vc: UIViewController?
    
    private lazy var _errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = StyleSheet.defaultTheme.mainColor
        label.numberOfLines = 0
        return label
    }()

    init(error: Error) {
        self._error = error
        super.init(nibName: nil, bundle: nil)
        _errorLabel.text = error.localizedDescription
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubviews([_errorLabel])
        _errorLabel.center()
    }
    
}
