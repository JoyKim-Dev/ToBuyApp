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
    var inputCollectionViewDataPrefetching: Observable<[IndexPath]?> = Observable([])
    
    var outputNavigationTitle: Observable<String> = Observable("")
    var outputList: Observable<[ItemResult]> = Observable([])
    var outputError: Observable<RequestError?> = Observable(nil)
    var outputResultCountLabel: Observable<String> = Observable("")
    
    init() {
        transform()
        print("SearchResultViewModel deinit")
    }
    
    deinit {
        print("SearchResultViewModel deinit")
    }
    private func transform() {
        
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.callRequest()
            self?.setNavigationTitle()
        }
        
        inputFilterBtnType.bind { [weak self] _ in
            self?.callRequest()
        }
        
        inputLikeBtnTapped.bind { [weak self] _ in
            self?.shoppingItemValidation()
        }
        
        inputCollectionViewDataPrefetching.bind { [weak self] _ in
            self?.paginationCallRequest()
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
                    self.outputResultCountLabel.value = "\(data.total.formatted())개의 검색 결과"
                    if self.inputQueryPage.value == 1 {
                        self.outputList.value = data.items
                    } else {
                        self.outputList.value.append(contentsOf: data.items)
                    }
     
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
    
    private func paginationCallRequest() {
        guard let indexPaths = inputCollectionViewDataPrefetching.value else {return}
        
        for i in indexPaths {
            if outputList.value.count - 3 == i.item {
                inputQueryPage.value += 1
                callRequest()
            }
        }
    }
}
