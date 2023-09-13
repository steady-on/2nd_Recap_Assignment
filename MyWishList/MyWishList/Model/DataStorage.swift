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
    
    func updateData(for id: String?) {
        guard let index = _webQueryResults.firstIndex(where: { $0.productID == id }) else { return }
        _webQueryResults[index].isInWishList.toggle()
    }
}
