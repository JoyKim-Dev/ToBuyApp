//
//  ShoppingBagRepository.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation
import RealmSwift

final class ShoppingBagRepository {
    
    let realm = try! Realm()
    
    func detectRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
    func createItem(_ item: ShoppingBagItemTable, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try realm.write {
                realm.add(item)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
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
    
    func deleteItem(productId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let item = realm.object(ofType: ShoppingBagItemTable.self, forPrimaryKey: productId) {
                try realm.write {
                    realm.delete(item)
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

