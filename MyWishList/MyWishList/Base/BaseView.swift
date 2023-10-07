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
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print(#function)
        
        configure()
        setConstraints()
    }
    
    func configure() {}
    func setConstraints() {}
}
