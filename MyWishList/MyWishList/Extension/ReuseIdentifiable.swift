//
//  ReuseIdentifiable.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import UIKit

protocol ReuseIdentifiable {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionViewCell: ReuseIdentifiable {}
