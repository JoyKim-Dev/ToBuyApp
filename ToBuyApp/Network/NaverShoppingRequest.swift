//
//  NaverShoppingRequest.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation
import Alamofire

enum RequestError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
}

enum Sort: String {
    case sim
}
enum NaverShoppingRequest {

    case productList(query: String, page: Int, display: Int, sort: Sort)

    var baseURL: String {
        return APIURL.naverShoppingURL
    }
    
    var endpoint: URL {
        switch self {
        case .productList:
            return URL(string: baseURL)!
        }
    }
    
    var header: HTTPHeaders {
        return [
            "X-Naver-Client-Id": APIKey.naverID,
            "X-Naver-Client-Secret": APIKey.naverKey
        ]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
        case .productList(let query, let page, let display, let sort):
            return ["query": query,"page": page, "display": 30, "sort": Sort.sim.rawValue]
        }
    }
}

