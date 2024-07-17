//
//  ProfileMainTableViewCellViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/15/24.
//

import Foundation
import RealmSwift

final class ProfileMainTableViewCellViewModel {
    
    let repository = ShoppingBagRepository.shared
    
    var outputShoppingBagItemCount: Observable<Int> = Observable(0)
  
    
    init() {
        outputShoppingBagItemCount.bind {  [weak self] _ in
            self?.outputShoppingBagItemCount.value = self?.repository.fetchAlls().count ?? 0
        }
    }
}
