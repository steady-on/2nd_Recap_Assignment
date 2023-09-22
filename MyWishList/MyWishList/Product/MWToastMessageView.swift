//
//  MWToastMessageView.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/11.
//

import UIKit

final class MWToastMessageView: BaseView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout).bold()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(toastType: ToastType) {
        super.init()
        
        messageLabel.text = toastType.message
        symbolImageView.image = UIImage(systemName: toastType.imageName)
        symbolImageView.tintColor = toastType.imageColor
    }
    
    override func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black.withAlphaComponent(0.4)
        layer.cornerRadius = 15
        clipsToBounds = true
        
        let components = [messageLabel, symbolImageView]
        
        components.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            symbolImageView.heightAnchor.constraint(equalTo: symbolImageView.widthAnchor, multiplier: 1),
            symbolImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            symbolImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8),
            symbolImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    enum ToastType {
        case save
        case delete
        
        var message: String {
            switch self {
            case .save: return "위시리스트에 저장되었습니다."
            case .delete: return "위시리스트에서 삭제되었습니다."
            }
        }
        
        var imageName: String {
            switch self {
            case .save: return "heart.fill"
            case .delete: return "heart.slash"
            }
        }
        
        var imageColor: UIColor? {
            switch self {
            case .save: return .systemPink
            case .delete: return .white
            }
        }
    }
}
