//
//  SearchMainViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation

final class SearchMainViewModel {
    
    var inputDeleteAt: Observable<Int> = Observable(0)
    var inputDeleteBtnTapped: Observable<Void?> = Observable(nil)
    var inputDeleteAllTapped: Observable<Void?> = Observable(nil)
    
    var outputNavigationTitle: Observable<String> = Observable("")
    
    init() {
        transform()
    }
    private func transform() {
        outputNavigationTitle.bind { _ in
            self.setNavigationTitle()
        }
        
//        inputDeleteBtnTapped.bind { _ in
//            self.deleteSearchKey()
//        }
        
        inputDeleteAllTapped.bind { _ in
            self.deleteSearchHistory()
        }
        
        
    }
    
    private func setNavigationTitle() {
        
        outputNavigationTitle.value = "\(UserDefaultManager.nickname)'s ToBuyBag"
       
    }
    
//    private func deleteSearchKey() {
//        UserDefaultManager.searchKeyword.remove(at: inputDeleteAt.value)
//    }
    
    private func deleteSearchHistory() {
        UserDefaultManager.searchKeyword.removeAll()
    }
    
    
}
