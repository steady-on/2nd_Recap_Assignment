//
//  MWCollectionView.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import UIKit

class MWCollectionView: BaseCollectionView {

    convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        self.collectionViewLayout = setCollectionViewLayout()
    }
    
    override func configure() {
        super.configure()
        
        register(MWCollectionViewCell.self, forCellWithReuseIdentifier: MWCollectionViewCell.identifier)
    }
    
    private func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        let width = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.itemSize = .init(width: width, height: width * 1.6)
        
        return layout
    }
}
