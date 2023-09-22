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
    
    func emptyData() {
        _webQueryResults.removeAll(keepingCapacity: true)
    }
    
    func updateData(for id: String) {
        guard let index = _webQueryResults.firstIndex(where: { $0.productID == id }) else { return }
        _webQueryResults[index].isInWishList.toggle()
    }
    
    func toggleStatusOfIsInWish(for item: Item) -> Result<Item, Error> {
        var item = item
        
        do {
            if item.isInWishList {
                try WishItemRepository().delete(for: item.productID)
            } else {
                try WishItemRepository().createItem(from: item)
            }
            
            item.isInWishList.toggle()
            updateData(for: item.productID)
            
            return .success(item)
        } catch {
            return .failure(error)
        }
    }
}
