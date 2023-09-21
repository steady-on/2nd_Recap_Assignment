//
//  PlaceholderForProductSearchingView.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import UIKit

final class MWPlaceholderView: BaseView {

    private lazy var symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var guideTextLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 상품을 검색해 주세요!"
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(symbolName: String, guideText: String) {
        super.init()
        
        symbolImageView.image = UIImage(systemName: symbolName)
        guideTextLabel.text = guideText
    }
    
    override func configure() {
        backgroundColor = .systemGroupedBackground
        
        let components = [symbolImageView, guideTextLabel]
        components.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            guideTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            guideTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            symbolImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            symbolImageView.bottomAnchor.constraint(equalTo: guideTextLabel.topAnchor, constant: -8),
            symbolImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            symbolImageView.heightAnchor.constraint(equalTo: symbolImageView.widthAnchor, multiplier: 1)
        ])
    }
}
