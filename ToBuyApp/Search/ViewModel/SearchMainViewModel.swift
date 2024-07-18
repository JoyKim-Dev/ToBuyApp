//
//  SearchMainViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation

final class SearchMainViewModel {
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputViewWillAppear: Observable<Void?> = Observable(nil)
    var inputDeleteBtnTapped: Observable<Int> = Observable(0)
    var inputDeleteAllTapped: Observable<Void?> = Observable(nil)
    var inputSearchBtnClicked: Observable<String> = Observable("")
    var inputReloadSearchView: Observable<Void?> = Observable(nil)
    var inputSearchBarShouldEndEditing: Observable<String> = Observable("")
    
    var outputNavigationTitle: Observable<String> = Observable("")
   // var outputEditedNavigationTitle: Observable<String> = Observable("")
    var outputSearchBarValidationResult: Observable<Bool> = Observable(true)
    var outputTableViewStatus: Observable<Bool> = Observable(true)
    var outputImageViewStatus: Observable<Bool> = Observable(true)
    var outputNoSearchWordLabelStatus: Observable<Bool> = Observable(true)
    var outputSearchBarText: Observable<String> = Observable("")
    var outputSearchBarShouldEndEditing: Observable<Bool> = Observable(true)
    var outputSearchList: Observable<[String]> = Observable([])
    
    
    init() {
        transform()
        print("SearchMainViewModel init")
    }
    
    deinit {
        print("SearchMainViewModel deinit")
    }
    private func transform() {
        
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.setNavigationTitle()
        }
        
        inputViewWillAppear.bind { [weak self] _ in
            self?.setNavigationTitle()
        }
        
        //        inputDeleteBtnTapped.bind{ _ in
        //            self.deleteSearchKey()
        //        }
        
        inputDeleteAllTapped.bind { [weak self] _ in
            self?.deleteSearchHistory()
        }
        
        inputSearchBtnClicked.bind{ [weak self] _ in
            self?.searchBarValidation()
        }
        
        inputReloadSearchView.bind {[weak self] _ in
            self?.reloadSearchViewValidation()
        }
        inputSearchBarShouldEndEditing.bind { [weak self] _ in
            self?.searchBarShouldReturnValidation()
        }
        outputSearchList.bind { [weak self] _ in
            self?.fetchSearchHistoryLIst()
        }
        
    }
    
    private func setNavigationTitle() {
        
        outputNavigationTitle.value = "\(UserDefaultManager.nickname)'s ToBuyBag"
        
    }
    
    //    private func deleteSearchKey() {
    //        UserDefaultManager.searchKeyword.remove(at: inputDeleteBtnTapped.value)
    //    }
    
    private func deleteSearchHistory() {
        UserDefaultManager.searchKeyword.removeAll()
    }
    private func fetchSearchHistoryLIst() {
        outputSearchList.value = UserDefaultManager.searchKeyword
    }
    private func searchBarValidation() {
        let trimmedText = inputSearchBtnClicked.value.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            guard let index = UserDefaultManager.searchKeyword.firstIndex(where: { $0 == trimmedText }) else { UserDefaultManager.searchKeyword.insert(inputSearchBtnClicked.value, at: 0)
                self.outputSearchBarText.value = ""
                self.outputSearchBarValidationResult.value = true
                return }
            
            UserDefaultManager.searchKeyword.remove(at: index)
            UserDefaultManager.searchKeyword.insert(inputSearchBtnClicked.value, at: 0)
//            self.outputSearchBarText.value = ""
            self.outputSearchBarValidationResult.value = true
        } else {
            self.outputSearchBarValidationResult.value = false
        }
    }
    
    private func reloadSearchViewValidation() {
        
        if UserDefaultManager.searchKeyword.count == 0 {
            self.outputTableViewStatus.value = true
            self.outputImageViewStatus.value = false
            self.outputNoSearchWordLabelStatus.value = false
        } else {
            self.outputTableViewStatus.value = false
            self.outputImageViewStatus.value = true
            self.outputNoSearchWordLabelStatus.value = true
        }
    }
    
    private func searchBarShouldReturnValidation() {
        if inputSearchBarShouldEndEditing.value.isEmpty {
            outputSearchBarShouldEndEditing.value = false
        } else {
            outputSearchBarShouldEndEditing.value = true
            let trimmedText = inputSearchBarShouldEndEditing.value.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedText.isEmpty {
                guard let index = UserDefaultManager.searchKeyword.firstIndex(where: { $0 == trimmedText }) else { UserDefaultManager.searchKeyword.insert(inputSearchBtnClicked.value, at: 0)
                    self.outputSearchBarText.value = ""
                    self.outputSearchBarValidationResult.value = true
                    return }
                
                UserDefaultManager.searchKeyword.remove(at: index)
                UserDefaultManager.searchKeyword.insert(inputSearchBtnClicked.value, at: 0)
    //            self.outputSearchBarText.value = ""
                self.outputSearchBarValidationResult.value = true
            } else {
                self.outputSearchBarValidationResult.value = false
            }
        }
    }
}
