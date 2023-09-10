//
//  WishItemRepository.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import Foundation
import RealmSwift

final class WishItemRepository {
    
    private var realm: Realm? = try? Realm()
    
    func createItem(from data: Item, imageData: Data?) throws {
        guard let realm else { throw RealmError.notInitialized }
        
        let newWish = WishItem(from: data, imageData: imageData)
        do {
            try realm.write { realm.add(newWish) }
        } catch {
            throw RealmError.failToCreateItem
        }
    }
    
    func fetchTable() throws -> Results<WishItem> {
        guard let realm else { throw RealmError.notInitialized }
        
        let data = realm.objects(WishItem.self).sorted(byKeyPath: "addedAt", ascending: false)
        return data
    }
    
    func checkItemInTable(for id: String) throws -> Bool {
        guard let realm else { throw RealmError.notInitialized }
        
        if realm.object(ofType: WishItem.self, forPrimaryKey: id) != nil {
            return true
        }
        
        return false
    }
    
    func updateItem(for changes: [String : String]) throws {
        guard let realm else { throw RealmError.notInitialized }
        
        do {
            try realm.write {
                realm.create(WishItem.self, value: changes, update: .modified)
            }
        } catch {
            throw RealmError.failToUpdateItem
        }
    }
    
    func delete(_ item: WishItem) throws {
        guard let realm else { throw RealmError.notInitialized }
        
        do {
            try realm.write { realm.delete(item) }
        } catch {
            throw RealmError.failToDelete
        }
    }
    
    func delete(for id: String) throws {
        guard let realm else { throw RealmError.notInitialized }
        guard let selectedItem = realm.object(ofType: WishItem.self, forPrimaryKey: id) else { throw RealmError.failToQuery }
        
        do {
            try realm.write { realm.delete(selectedItem) }
        } catch {
            throw RealmError.failToDelete
        }
    }
}
