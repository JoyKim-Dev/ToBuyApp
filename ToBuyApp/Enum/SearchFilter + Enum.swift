//
//  SearchFilter.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/14/24.
//

import Foundation

enum SearchResultSortType:String {
    case accuracy = "sim"
    case recentDate = "date"
    case priceTopDown = "dsc"
    case priceDownTop = "asc"
    
    var btnTitle: String {
        switch self {
        case .accuracy:
            return "정확도"
        case .recentDate:
            return "날짜순"
        case .priceTopDown:
            return "가격높은순"
        case .priceDownTop:
            return "가격낮은순"
        }
    }
}
