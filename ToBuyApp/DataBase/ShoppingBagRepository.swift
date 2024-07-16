//
//  ShoppingBagRepository.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation
import RealmSwift

final class ShoppingBagRepository {
    
   static let shared = ShoppingBagRepository()
    private init() {}
    
    let realm = try! Realm()
    
    func detectRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
    func createItem(_ item: ShoppingBagItemTable, category: Category) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm save succeed")}
        } catch {
            print("catch error")
        }
    }
    
    func isAddedItem(_ productId: String) -> Bool {
        let value = realm.objects(ShoppingBagItemTable.self).where {
            $0.id == productId
        }
        if value.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func fetchAlls() -> Results<ShoppingBagItemTable> {
        return realm.objects(ShoppingBagItemTable.self).sorted(byKeyPath: "likedDate", ascending: true)
    }
    
    func deleteItem(id: String) {
        do {
            if let item = realm.object(ofType: ShoppingBagItemTable.self, forPrimaryKey: id) {
                try realm.write {
                    realm.delete(item)
                    print("Realm delete succeed")
                }
            } else {
                print("Item not found in Realm")
            }
        } catch {
            print("catch error: \(error.localizedDescription)")
        }
    }
    
    func deleteAll() {
        do{
            try realm.write{
                realm.deleteAll()
            }
        } catch {
            print("삭제 실패")
        }
    }
}
