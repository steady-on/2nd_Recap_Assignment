//
//  WishItemRepository.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import Foundation
import RealmSwift

final class WishItemRepository {
    
    private var realm = try! Realm()
    
    func createItem(from data: Item, imageData: Data?) throws {
        let newWish = WishItem(from: data, imageData: imageData)
        do {
            try realm.write { realm.add(newWish) }
        } catch {
            throw RealmError.failToCreateItem
        }
    }
    
    func fetchTable() -> Results<WishItem> {
        let data = realm.objects(WishItem.self).sorted(byKeyPath: "addedAt", ascending: false)
        return data
    }
    
    func queryTable(for keyword: String) -> Results<WishItem> {
        let wishList = fetchTable()
        
        let queryResult = wishList.where {
            $0.title.contains(keyword, options: .caseInsensitive) || $0.title.contains(keyword, options: .diacriticInsensitive)
        }.sorted(byKeyPath: "addedAt", ascending: false)
        
        return keyword.isEmpty ? wishList : queryResult
    }
    
    func checkItemsInTable(for items: [Item]) -> [Item] {
        let syncedItems = items.map { item in
            var item = item
            
            guard let existedItem = checkItemInTable(for: item.productID) else {
                item.isInWishList = false
                return item
            }
            
            item.isInWishList = true
                
            if item.imageData == nil {
                item.imageData = existedItem.imageData
            }

            return item
        }

        return syncedItems
    }
    
    func checkItemInTable(for id: String) -> WishItem? {
        return realm.object(ofType: WishItem.self, forPrimaryKey: id)
    }
    
    func updateItemImageData(for item: WishItem, imageData: Data?) {
        try! realm.write {
            item.imageData = imageData
        }
    }
    
    func delete(_ item: WishItem) throws {
        do {
            try realm.write { realm.delete(item) }
        } catch {
            throw RealmError.failToDelete
        }
    }
    
    func delete(for id: String) throws {
        guard let selectedItem = realm.object(ofType: WishItem.self, forPrimaryKey: id) else { throw RealmError.failToQuery }
        
        do {
            try realm.write { realm.delete(selectedItem) }
        } catch {
            throw RealmError.failToDelete
        }
    }
}
