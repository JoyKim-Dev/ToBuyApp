//
//  SearchItemDetailViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation
import RealmSwift

final class SearchItemDetailViewModel {
    let repository = ShoppingBagRepository.shared
    let categoryRepository = CategoryRepository.shared
    var detail = List<ShoppingBagItemTable>()
    
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputSearchDataFromPreviousPage: Observable<ItemResult?> = Observable(ItemResult(title: "", link: "", image: "", lprice: "", mallName: "", productId: "", category2: ""))
    var inputLikedDataFromPreviousPage: Observable<String> = Observable("")
    var inputNavCartBtnTapped: Observable<Void?> = Observable(nil)

    var outputNavCartBtnImage: Observable<String> = Observable("")
    var outputNavTitleSet: Observable<String> = Observable("")
    var outputURLValidation: Observable<URLRequest?> = Observable(nil)

    
    init() {
        transform()
    }
    
    private func transform() {
        
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.urlValidation()
            self?.setNavBtn()
            self?.setNavTitle()
        }
        
        inputNavCartBtnTapped.bind { [weak self] _ in
            self?.addShoppingBagValidation()
            self?.setNavBtn()
        }
        
        
    }
 
    private func setNavTitle() {
        guard let title = inputSearchDataFromPreviousPage.value?.title else {return}
        outputNavTitleSet.value = title.replacingOccurrences(of: "[<b></b>]", with: "", options: .regularExpression)
    }
    private func setNavBtn() {
        
        let title = inputSearchDataFromPreviousPage.value?.title.replacingOccurrences(of:"[<b></b>]", with: "", options: .regularExpression)
        
        if let _ = repository.realm.object(ofType: ShoppingBagItemTable.self, forPrimaryKey: inputSearchDataFromPreviousPage.value?.productId) {
            outputNavCartBtnImage.value = "cart.fill"
        } else {
            outputNavCartBtnImage.value = "cart"
        }
    }
    
    private func urlValidation() {
        
        guard let url = inputSearchDataFromPreviousPage.value?.link else {
            return
        }
        
        guard let validURL = URL(string: url) else {
            print("유효하지 않은 url")
            return
        }
        
        if inputLikedDataFromPreviousPage.value != "" {
            outputURLValidation.value = URLRequest(url: URL(string:inputLikedDataFromPreviousPage.value)!)
        } else {
            outputURLValidation.value = URLRequest(url: validURL)

        }
        
    }
    
    private func addShoppingBagValidation() {
        
        guard let item = inputSearchDataFromPreviousPage.value else {return}
        
        let liked = ShoppingBagItemTable(id: item.productId, title: item.title, price: item.lprice, webLink: item.link, category: item.category2, image: item.image )
        
        let categoryName = categoryRepository.realm.objects(Category.self).where {
            $0.category == liked.category}
        
        if let _ = repository.realm.object(ofType: ShoppingBagItemTable.self, forPrimaryKey: liked.id) {
            repository.deleteItem(id: liked.id)
            print("Product deleted")
        } else {
                if let category = categoryName.first {
                    repository.createItem(liked, category: category)
                } else {
                    detail.append(liked)
                    let category = Category(category: liked.category, detail: detail)
                    categoryRepository.createCategory(category)
                }
        }
    }
}

