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
    
    func createItem(from data: Item) throws {
        let newWish = WishItem(from: data)
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
            
            guard checkItemInTable(for: item.productID) != nil else {
                item.isInWishList = false
                return item
            }
            
            item.isInWishList = true

            return item
        }

        return syncedItems
    }
    
    func checkItemInTable(for id: String) -> WishItem? {
        return realm.object(ofType: WishItem.self, forPrimaryKey: id)
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
