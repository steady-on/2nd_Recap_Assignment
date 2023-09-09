//
//  MWIndicatorViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import UIKit

class MWIndicatorView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        backgroundColor = .systemBackground.withAlphaComponent(0.4)
        
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
