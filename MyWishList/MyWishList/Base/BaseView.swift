//
//  BaseView.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import UIKit

class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        
        configure()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
    func setConstraints() {}
}
