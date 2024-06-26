//
//  WishItem.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import Foundation
import RealmSwift

final class WishItem: Object {
    @Persisted(primaryKey: true) var productID: String
    @Persisted var title: String
    @Persisted var mallName: String
    @Persisted var link: String
    @Persisted var priceInt: Int
    @Persisted var priceString: String
    @Persisted var imageLink: String
    @Persisted var addedAt: Date
    
    convenience init(
        productID: String,
        title: String,
        mallName: String,
        link: String,
        priceInt: Int,
        priceString: String,
        imageLink: String) {
            
        self.init()

        self.productID = productID
        self.title = title
        self.mallName = mallName
        self.link = link
        self.priceInt = priceInt
        self.priceString = priceString
        self.imageLink = imageLink
        self.addedAt = Date()
    }
    
    convenience init(from item: Item) {
        self.init(
            productID: item.productID,
            title: item.title,
            mallName: item.mallName,
            link: item.link,
            priceInt: item.priceInt,
            priceString: item.priceString,
            imageLink: item.image
        )
    }
}
