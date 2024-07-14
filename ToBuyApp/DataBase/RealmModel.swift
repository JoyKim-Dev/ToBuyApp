//
//  RealmModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

// database를 왜 사용할까? UserDefault를 써도 될텐데...

import Foundation
import RealmSwift

final class ShoppingBagItemTable: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted (indexed: true) var title: String
    @Persisted var price: String
    @Persisted var webLink: String
    @Persisted var brand: String
    @Persisted var image: String
    @Persisted var likedDate: Date

  
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
