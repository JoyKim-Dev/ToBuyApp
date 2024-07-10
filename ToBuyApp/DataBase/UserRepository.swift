//
//  UserRepository.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation
import RealmSwift

final class UserRepository {
    
    let realm = try! Realm()
    
    func createItem(_ shoppingData: ShoppingBagItemTable, _ searchData: SearchTable, for user: UserTable, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try realm.write {
                user.shoppingBagDetail.append(shoppingData)
                realm.add([shoppingData, searchData])
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func detectRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
    func fetchUser(_ nickname: String) -> Results<UserTable> {
        let value = realm.objects(UserTable.self).where {
            $0.nickname == nickname
        }
        return value
    }
    
    func fetchAlls() -> Results<UserTable> {
        return realm.objects(UserTable.self).sorted(byKeyPath: "nickname", ascending: true)
    }
    
    func removeUser(_ user: UserTable, completion: @escaping (Result<Void, Error>) -> Void) {
        do{
            try realm.write {
                realm.delete(user.shoppingBagDetail)
                realm.delete(user.searchHistory)
                realm.delete(user)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
