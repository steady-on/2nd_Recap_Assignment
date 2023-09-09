//
//  MWToggleButton.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/09.
//

import UIKit

class MWToggleButton: UIButton {
    
    private var color: UIColor?
    
    override var isSelected: Bool {
        get { super.isSelected }
        set {
            super.isSelected = newValue
            backgroundColor = newValue ? color : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title: String, color: UIColor?) {
        self.init(frame: .zero)
        
        self.color = color
        configure(title: title, color: color)
    }
    
    private func configure(title: String, color: UIColor?) {
        titleLabel?.font = .preferredFont(forTextStyle: .callout)
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setTitleColor(.systemBackground, for: .selected)
        layer.cornerRadius = 10
        layer.borderColor = color?.cgColor
        layer.borderWidth = 1
        contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
    }
}
