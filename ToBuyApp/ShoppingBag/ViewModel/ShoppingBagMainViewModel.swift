//
//  ShoppingBagMainViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation
import RealmSwift

final class ShoppingBagMainViewModel {
    
    let repository = ShoppingBagRepository.shared
    let categoryRepository = CategoryRepository.shared

    var inputViewDidLoadTrigger = Observable(())
    var inputViewWillAppear = Observable(())
    var inputLikeBtnTapped: Observable<Int> = Observable(0)
    var inputSearchBarTextChanged: Observable<String> = Observable("")

    var outputNavigationTitle: Observable<String> = Observable("")
    var outputSearchBarFilter: Observable<Void?> = Observable(nil)
    var outputViewWillAppear = Observable(())
    var outputShoppingList: Observable<[ShoppingBagItemTable]> = Observable([])
    var outputCategoryList: Observable<[Category]> = Observable([])
   
    
    init() {
      
        transform()
        print("ShoppingBagMainViewModel init")
    }
    
    deinit {
        print("ShoppingBagMainViewModel deinit")
    }
    private func transform() {
        
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.setNavigationTitle()
        }
        inputLikeBtnTapped.bind { [weak self] _ in
            self?.likeBtnValidation()
        }

        inputSearchBarTextChanged.bind { [weak self] _ in
            self?.searchBarFilter()
        }
        
        inputViewWillAppear.bind { [weak self] _ in
            self?.setNavigationTitle()
            
        }
    }
    
    private func setNavigationTitle() {
        outputNavigationTitle.value = "찜 \(repository.fetchAlls().count)개 목록"
    }
    
    private func likeBtnValidation() {
        
        let index = inputLikeBtnTapped.value
        let all = repository.fetchAllsInArray()
        
        guard index >= 0, index < all.count else {
                print("Index out of bounds or invalid")
                return
            }
            
            let category = all[index].main.first
            
            guard let category = category else {
                print("Category not found")
                return
            }
            
            if category.detail.count == 1 {
                category.detail.removeAll()
                categoryRepository.removeCategory(category)
            } else if category.detail.count > 1 {
                repository.deleteItem(id: all[index].id)
                print("Product deleted")
            }
        }
    
    private func searchBarFilter() {
        
        let searchText = inputSearchBarTextChanged.value
        let filter = repository.realm.objects(ShoppingBagItemTable.self).where { $0.title.contains(searchText, options: .caseInsensitive) }
        
        let categoryFilter = categoryRepository.realm.objects(Category.self).where {
            $0.detail.title.contains(searchText, options: .caseInsensitive)
        }
        
        outputShoppingList.value = Array(filter)
        outputCategoryList.value = Array(categoryFilter)
    }
    
    private func fetchShoppingList() {
        outputShoppingList.value = repository.fetchAllsInArray()
    }
    
    private func fetchCategoryList() {
        outputCategoryList.value = categoryRepository.fetchAllCategoryInArray()
    }
}
