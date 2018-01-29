//
//  ProfileImageView.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-19.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

protocol XpertInfoViewDelegate: class {
    func clickedOnMoreBtn(with expert: Xpert)
}

class XpertInfoView: UIView {
    
    var xpert: Xpert? {
        didSet {
            _nameLabel.text = xpert?.fullName
            _specializationLabel.text = xpert?.sepcialized
            _locationLabel.text = xpert?.locationString
            _costLabel.text = xpert?.cost
            _profileImageView.profileImageUrl = xpert?.profileImageUrl
        }
    }
    weak var delegate: XpertInfoViewDelegate?
    
    init(frame: CGRect, showInstagramIcon: Bool = false) {
        super.init(frame: frame)
        setupUI(showInstagramIcon: showInstagramIcon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var _profileImageView: BXProfileImageView = {
        let view = BXProfileImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var _nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    private lazy var _specializationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    private lazy var _locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    private lazy var _costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    private lazy var _stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [_nameLabel, _specializationLabel, _locationLabel, _costLabel])
        stackView.axis = .vertical
        stackView.spacing =  4
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        return stackView
    }()
    private lazy var _moreBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setFAIcon(icon: FAType.FAEllipsisV, iconSize: 15, forState: .normal)
        btn.setTitleColor(StyleSheet.defaultTheme.mainColor, for: .normal)
        btn.addTarget(self, action: #selector(showMoreMenue), for: .touchUpInside)
        return btn
    }()
    
    
    private func setupUI(showInstagramIcon: Bool) {
        addSubviews([_profileImageView, _stackView])

        _profileImageView.layoutTo(edges: [.left, .top, .bottom], ofView: self, withMargin: 8)
        _stackView.center(axis: .vertical)

        NSLayoutConstraint.activate([
            _profileImageView.widthAnchor.constraint(equalToConstant: 100),
            _stackView.leftAnchor.constraint(equalTo: _profileImageView.rightAnchor, constant: 8),
        ])
        
        
        if showInstagramIcon {
            addSubviews([_moreBtn])
            _stackView.rightAnchor.constraint(equalTo: _moreBtn.leftAnchor, constant: -4)
            _moreBtn.layoutTo(edges: [.top, .right], ofView: self, withMargin: 4)
        } else {
            _stackView.rightAnchor.constraint(equalTo: leftAnchor, constant: -4)
        }
        
        _locationLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -8).isActive = true
    }
    
    @objc func showMoreMenue() {
        guard let xpert = xpert else { return }
        delegate?.clickedOnMoreBtn(with: xpert)
    }
    
}


