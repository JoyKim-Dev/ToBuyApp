//
//  ProfileImageViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation

final class ProfileImageViewModel {
    
    var imageDataFromPreviousPage:Int = 0
    var selectedIndexPath: IndexPath?
    weak var imageForDelegate: ImageDelegate?
    
    var outputNavigationTitle: Observable<String> = Observable("")
    
    init() {
        transform()
    }
    private func transform() {
        outputNavigationTitle.bind { _ in
            self.setNavigationTitle()
        }
        
    }
    
    private func setNavigationTitle() {
        if !UserDefaultManager.nickname.isEmpty {
            outputNavigationTitle.value = "EDIT PROFILE"
        } else {
            outputNavigationTitle.value = "PROFILE SETTING"
        }
    }
}
