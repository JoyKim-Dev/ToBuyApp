//
//  NaverShoppingRequest.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation

enum RequestError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
    
    var title: String {
        switch self {
        case .failedRequest:
            "통신 실패"
        case .noData:
            "응답값이 없음"
        case .invalidResponse:
            "응답 없음"
        case .invalidData:
            "유효하지 않은 응답값"
        }
    }
    
    var message: String {
        switch self {
        case .failedRequest:
            "인터넷 통신에 실패했습니다. 인터넷 연결을 확인한 후 다시 시도해주세요."
        case .noData:
            "응답값이 없습니다. 다시 검색해주세요"
        case .invalidResponse:
            "응답이 없습니다. 다시 시도해주세요."
        case .invalidData:
            "유효하지 않은 응답값입니다. 다시 검색해주세요."
        }
    }
}
// ResultType으로 하나의 매개변수 함수 활용
typealias NaverShoppingHander = (Result<[ItemResult], RequestError>) -> Void

class ShoppingNaverManager {
    
    static let shared = ShoppingNaverManager()
    private init() {}
    
    
    func callRequest(query: String, start: Int, apiSortType: SearchResultSortType.RawValue, completionHandler: @escaping NaverShoppingHander) {
        DispatchQueue.main.async {
            
            var component = URLComponents()
            component.scheme = "https"
            component.host = "openapi.naver.com"
            component.path = "/v1/search/shop.json"
            component.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "display", value: String(30)),
                URLQueryItem(name: "start", value: String(start)),
                URLQueryItem(name: "sort", value: apiSortType)
            ]
            
            guard let url = component.url else {
                print(RequestError.failedRequest)
                return
            }
            
            var request = URLRequest(url: url)
            print(#function, Thread.isMainThread)
            print("************URL: \(url)")
            print(request)
            
            request.setValue(APIKey.naverID, forHTTPHeaderField: "X-Naver-Client-Id")
            request.setValue(APIKey.naverKey, forHTTPHeaderField: "X-Naver-Client-Secret" )
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard error == nil else {
                        print("Failed Request")
                        completionHandler(.failure(.failedRequest))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse
                    else {
                        print("Unable Response")
                        completionHandler(.failure(.invalidResponse))
                        return
                    }
                    
                    guard response.statusCode == 200 else {
                        print("failed Response데이터없음")
                        completionHandler(.failure(.invalidData))
                        return
                    }
                    
                    guard let data = data else {
                        print("No Data Returned")
                        completionHandler(.failure(.noData))
                        return
                    }
                    
                    print("이제 식판에 담으면 됨")
                    
                    do {
                        let result = try JSONDecoder().decode(Product.self, from: data)
                        print(result)
                     
                            completionHandler(.success(result.items))
                        
                    } catch {
                        print("error")
                        print(error)
                        
                        completionHandler(.failure(.invalidData))
                        
                    }
                }
            }.resume()
        }
        
    }
}
