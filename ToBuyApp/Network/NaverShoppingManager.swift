////
////  NetworkManager.swift
////  ToBuyApp
////
////  Created by Joy Kim on 7/10/24.
////
//
//import Foundation
//import Alamofire
//
//final class NaverShoppingManager {
//    
//    
//    static let shared = NaverShoppingManager()
//    private init() {}
//    
//    typealias GenericHandler<T: Decodable> = (T?, RequestError?) -> Void
//    
//    
//    func request<T: Decodable>(api: NaverShoppingRequest, model: T.Type, completionHandler: @escaping (GenericHandler<T>, Error) -> Void) {
//        
//        AF.request(api.endpoint,
//                   method: api.method,
//                   parameters: api.parameter,
//                   encoding: URLEncoding(destination: .queryString),
//                   headers: api.header)
//        .responseDecodable(of: T.self) { response in
//            print("STATUS: \(response.response?.statusCode ?? 0)")
//            
//            switch response.result {
//                // 여기도 enum 연관값 활용!
//            case .success(let value):
//                //dump(value.results)
//                completionHandler()
//                
//            case .failure(let error):
//                print(error)
//                // 튜플
//                completionHandler(nil, .failedRequest)
//            }
//        }
//    }
//}
