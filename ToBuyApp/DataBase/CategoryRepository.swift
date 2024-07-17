//
//  CategoryRepository.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/14/24.
//

import Foundation
import RealmSwift


final class CategoryRepository {
    
    static let shared = CategoryRepository()
    private init() {}
    
    let realm = try! Realm()
 
    func createItem(_ data: ShoppingBagItemTable, category: Category) {
        do {
            try realm.write {
                category.detail.append(data)
                realm.add(data)
                print("Realm save succeed")}
        } catch {
            print("catch error")
        }
    }
    
    func createCategory(_ data: Category) {
        do {
            try realm.write {
                realm.add(data)
                print("Realm save succeed")
            }
        } catch {
            print("catch error")
        }
    }
    
    func detectRealmURL() {
        print(realm.configuration.fileURL ?? "")
    }
    
    
    func fetchAllCategoryInArray() -> [Category] {
        let value = realm.objects(Category.self)
        return Array(value)
    }
    
    func fetchAlls() -> Results<Category> {
        return realm.objects(Category.self).sorted(byKeyPath: "category", ascending: true)
    }
    
    func removeCategory(_ category: Category) {
        do{
            try realm.write {
                realm.delete(category.detail)
                realm.delete(category)
                print("Realm remove succeed")
            }
        } catch {
            print("Category remove failed")
        }
    }
}
