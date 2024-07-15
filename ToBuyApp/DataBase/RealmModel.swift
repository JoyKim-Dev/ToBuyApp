//
//  RealmModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

// database를 왜 사용할까? UserDefault를 써도 될텐데...

import Foundation
import RealmSwift

class Category: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var category: String
    @Persisted var regDate: Date
    @Persisted var detail: List<ShoppingBagItemTable>
    
    convenience init(category: String, detail: List<ShoppingBagItemTable> ) {
        self.init()

        self.category = category
        self.regDate = Date()
        self.detail = detail
    }
}

final class ShoppingBagItemTable: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted (indexed: true) var title: String
    @Persisted var price: String
    @Persisted var webLink: String
    @Persisted var category: String
    @Persisted var image: String
    @Persisted var likedDate: Date
    @Persisted(originProperty: "detail") var main: LinkingObjects<Category>

  
    convenience init(id: String, title: String, price: String, webLink: String, category: String, image: String) {
        self.init()
        self.id = id
        self.title = title
        self .price = price
        self.webLink = webLink
        self.category = category
        self.image = image
        self.likedDate = Date()
   }
}
