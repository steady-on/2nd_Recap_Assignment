//
//  DataStorage.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/12.
//

import Foundation
import RealmSwift

final class DataStorage {
    static let shared = DataStorage()
    
    private var _webQueryResults = [Item]()
    
    var webQueryResults: [Item] {
        wishItemRepository.checkItemsInTable(for: _webQueryResults)
    }
    
    private lazy var wishItemRepository = WishItemRepository()
    
    func storeData(_ items: [Item]) {
        _webQueryResults = items
    }
    
    func addData(_ items: [Item]) {
        _webQueryResults.append(contentsOf: items)
    }
    
    func storeImageData(at indexPath: IndexPath, imageData: Data?) {
        _webQueryResults[indexPath.item].imageData = imageData
    }
}
