//
//  BaseCollectionView.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import UIKit

class BaseCollectionView: UICollectionView {

    init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .systemGroupedBackground
    }
}
