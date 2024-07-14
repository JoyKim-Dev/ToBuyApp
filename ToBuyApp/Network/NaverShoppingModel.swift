//
//  NaverShopping.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation

struct Product: Decodable {
    
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    var items: [ItemResult]

}

struct ItemResult: Decodable {
    
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let brand: String
    let productId: String
    let category2: String
}
