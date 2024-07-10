//
//  SearchRepository.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation
import RealmSwift

final class SearchRepository {
    
    let realm = try! Realm()
    
    func detectRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
    func createItem(_ searchData: SearchTable, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try realm.write {
                realm.add(searchData)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func isSearchedKeyword(_ keyword: String) -> Bool {
        let value = realm.objects(SearchTable.self).where {
            $0.searchKeyWord == keyword
        }
        if value.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func fetchAlls() -> Results<SearchTable> {
        return realm.objects(SearchTable.self).sorted(byKeyPath: "searchKeyWord", ascending: true)
    }
    
    func deleteItem(keyword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let item = realm.object(ofType: SearchTable.self, forPrimaryKey: keyword) {
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
