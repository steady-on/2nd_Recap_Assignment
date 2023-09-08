//
//  MWCollectionViewCell.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import UIKit

class MWCollectionViewCell: BaseCollectionViewCell {
    var item: Item? {
        didSet {
            guard let item else { return }
            productImageView.loadImage(from: item.image)
            
            let buttonImage = item.isInWishList ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            toggleWishButton.setImage(buttonImage, for: .normal)
            mallNameLabel.text = item.mallName
            titleLabel.text = item.title
            priceLabel.text = item.priceString
        }
    }
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.tintColor = .placeholderText
        return imageView
    }()
    
    private lazy var toggleWishButton: UIButton = {
        let button = UIButton()
        button.frame = .init(x: 0, y: 0, width: 30, height: 30)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemPink
        button.layer.cornerRadius = button.frame.width * 0.5
        return button
    }()
    
    private lazy var infoTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3).bold()
        return label
    }()
    
    override func configureView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.directionalLayoutMargins = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let components = [productImageView, toggleWishButton, infoTextStackView]
        components.forEach { component in
            contentView.addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let stackComponents = [mallNameLabel, titleLabel, priceLabel]
        stackComponents.forEach { component in
            infoTextStackView.addArrangedSubview(component)
        }
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            toggleWishButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            toggleWishButton.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: -8),
            toggleWishButton.heightAnchor.constraint(equalTo: toggleWishButton.widthAnchor, multiplier: 1),
            toggleWishButton.widthAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 0.2),
        ])
        
        NSLayoutConstraint.activate([
            infoTextStackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            infoTextStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            infoTextStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            infoTextStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}