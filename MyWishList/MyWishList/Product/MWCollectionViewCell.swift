//
//  MWCollectionViewCell.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import UIKit
import Kingfisher

final class MWCollectionViewCell: BaseCollectionViewCell {
    
    var item: Item! {
        didSet {
            toggleWishButton.setImage(wishButtonImage, for: .normal)
            mallNameLabel.text = "[" + item.mallName + "]"
            titleLabel.text = item.title
            priceLabel.text = item.priceString
            
            guard let url = URL(string: item.image) else { return }
            productImageView.kf.indicatorType = .activity
            productImageView.kf.setImage(with: url)
        }
    }
    
    private var wishButtonImage: UIImage? {
        item.isInWishList ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    var completionHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)!
    
    var toggleWishButtonCompletionHandler: ((Result<Bool,Error>) -> ())!
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.tintColor = .placeholderText
        return imageView
    }()
    
    private let toggleWishButton: UIButton = {
        let button = UIButton()
        button.frame = .init(x: 0, y: 0, width: 35, height: 35)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemPink
        button.layer.cornerRadius = button.frame.width * 0.5
        return button
    }()
    
    private let infoTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private let mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3).bold()
        return label
    }()
    
    override func prepareForReuse() {
        productImageView.image = nil
        mallNameLabel.text = nil
        titleLabel.text = nil
        priceLabel.text = nil
        toggleWishButton.setImage(nil, for: .normal)
    }
    
    override func configureView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        let components = [productImageView, toggleWishButton, infoTextStackView]
        components.forEach { component in
            contentView.addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let stackComponents = [mallNameLabel, titleLabel, priceLabel]
        stackComponents.forEach { component in
            infoTextStackView.addArrangedSubview(component)
        }
        
        toggleWishButton.addTarget(self, action: #selector(toggleWishButtonTapped), for: .touchUpInside)
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
    
    @objc private func toggleWishButtonTapped() {
        let result = DataStorage.shared.toggleStatusOfIsInWish(for: item)
        
        switch result {
        case .success(let item):
            self.item = item
            completionHandler?()
        case .failure(let error):
            errorHandler(error)
        }
    }
}
