//
//  ProfileMainTableViewCellViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/15/24.
//

import Foundation

final class ProfileMainTableViewCellViewModel {
    
    let repository = ShoppingBagRepository.shared
    
    var outputShoppingBagItemCount: Observable<Int> = Observable(0)
    
    init() {
        
        outputShoppingBagItemCount.bind { _ in
            self.outputShoppingBagItemCount.value = self.repository.fetchAlls().count
        }
    }
    
    
}
