//
//  RealmModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

// database를 왜 사용할까? UserDefault를 써도 될텐데...

import Foundation
import RealmSwift

//final class UserTable: Object {
//    
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted (indexed: true) var nickname: String
//    @Persisted var profileImage: Int
//    @Persisted var joinedDate: Date
//    @Persisted var searchHistory: List<SearchTable>
//    @Persisted var shoppingBagDetail: List<ShoppingBagItemTable>
//    
//    convenience init(nickname: String, profileImage: Int) {
//        self.init()
//        self.id = id
//        self.nickname = nickname
//        self.profileImage = profileImage
//        self.joinedDate = Date()
//        self.searchHistory = searchHistory
//        self.shoppingBagDetail = shoppingBagDetail
//    }
//}

final class SearchTable: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted (indexed: true) var searchKeyWord: String
    @Persisted var searchedDate: Date
//    @Persisted(originProperty: "searchHistory") var main: LinkingObjects<UserTable>
    
    convenience init(searchKeyWord: String) {
        self.init()
        self.id = id
        self.searchKeyWord = searchKeyWord
        self.searchedDate = Date()
    }
}

final class ShoppingBagItemTable: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted (indexed: true) var title: String
    @Persisted var price: String
    @Persisted var webLink: String
    @Persisted var brand: String
    @Persisted var image: String
    @Persisted var likedDate: Date
//    @Persisted(originProperty: "shoppingBagDetail") var main: LinkingObjects<UserTable>
  
    convenience init(id: String, title: String, price: String, webLink: String, brand: String, image: String) {
        self.init()
        self.id = id
        self.title = title
        self .price = price
        self.webLink = webLink
        self.brand = brand
        self.image = image
        self.likedDate = Date()
   }
}
