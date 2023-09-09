//
//  MWIndicatorViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import UIKit

class MWIndicatorView: BaseView {
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.tintColor = .label
        indicator.style = .large
        return indicator
    }()
    
    override var isHidden: Bool {
        get { super.isHidden }
        set {
            super.isHidden = newValue
            newValue ? indicatorView.stopAnimating() : indicatorView.startAnimating()
        }
    }
    
    override func configure() {
        backgroundColor = .systemBackground.withAlphaComponent(0.4)
        
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
