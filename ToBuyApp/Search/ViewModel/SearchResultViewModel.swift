//
//  SearchResultViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation
import RealmSwift

final class SearchResultViewModel {
    let realmRepository = ShoppingBagRepository.shared
    let categoryRepository = CategoryRepository.shared
    var detail = List<ShoppingBagItemTable>()
    
    var inputViewDidLoadTrigger = Observable(())
    var inputFilterBtnType: Observable<String> = Observable("sim")
    var inputSearchwordFromPreviousPage: Observable<String> = Observable("")
    var inputQueryPage: Observable<Int> = Observable(1)
    var inputLikeBtnTapped: Observable<Int> = Observable(0)
    
    var outputNavigationTitle: Observable<String> = Observable("")
    var outputList: Observable<[ItemResult]> = Observable([])
    var outputError: Observable<RequestError?> = Observable(nil)
    var outputResultCountLabel: Observable<String> = Observable("")
    
    init() {
        transform()
    }
    
    deinit {
        print("deinit")
    }
    private func transform() {
        
        outputNavigationTitle.bind {[weak self] _ in
            self?.setNavigationTitle()
        }
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.callRequest()
        }
        inputFilterBtnType.bind { [weak self] _ in
            self?.callRequest()
        }
        inputLikeBtnTapped.bind { [weak self] _ in
            self?.shoppingItemValidation()
        }
        
    }
    private func setNavigationTitle() {
        outputNavigationTitle.value = inputSearchwordFromPreviousPage.value
    }
    
    private func callRequest() {
        ShoppingNaverManager.shared.callRequest(query: inputSearchwordFromPreviousPage.value, start: inputQueryPage.value, apiSortType: inputFilterBtnType.value) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let data):
                    self.outputList.value = data
                    self.outputResultCountLabel.value = "\(data.count)개의 검색 결과"
                case .failure(let failure):
                    self.outputError.value = failure.self
                    print(failure.message,failure.title)
                    
                }
            }
        }
    }
    
    private func shoppingItemValidation() {
        if inputLikeBtnTapped.value < outputList.value.count {
            let item = outputList.value[inputLikeBtnTapped.value]
            let id = item.productId
            let title = item.title
            let price = item.lprice
            let weblink = item.link
            let category = item.category2
            let image = item.image
            
            let liked = ShoppingBagItemTable(id: id, title: title, price: price, webLink: weblink, category: category, image: image )
            
            let categoryName = categoryRepository.realm.objects(Category.self).where {
                $0.category == liked.category}
            
            if let _ = categoryRepository.realm.object(ofType: ShoppingBagItemTable.self, forPrimaryKey: id) {
                realmRepository.deleteItem(id: id)
                print("Product deleted")
                
            } else {
                if let category = categoryName.first {
                    realmRepository.createItem(liked, category: category)
                } else {
                    self.detail.append(liked)
                    let category = Category(category: liked.category, detail: detail)
                    categoryRepository.createCategory(category)
                    detail.removeAll()
                }
            }
        } else {
            print("Error: Index out of range")
        }
    }
}
