//
//  MWCollectionView.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import UIKit

final class MWCollectionView: BaseCollectionView {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    override func configure() {
        super.configure()
        
        self.collectionViewLayout = setCollectionViewLayout()
        
        register(MWCollectionViewCell.self, forCellWithReuseIdentifier: MWCollectionViewCell.identifier)
    }
    
    private func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let width = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.itemSize = .init(width: width, height: width * 1.65)
        
        return layout
    }
}
