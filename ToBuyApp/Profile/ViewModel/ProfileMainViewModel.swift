//
//  ProfileMainViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation

final class ProfileMainViewModel {
    
    var outputNavigationTitle: Observable<String> = Observable("")
    var outputProfileNickname: Observable<String> = Observable("")
    var outputProfileImage: Observable<Int> = Observable(0)
    var outputJoinedDate: Observable<String> = Observable("")
    
    init() {
        transform()
    }
    private func transform() {
        
        outputNavigationTitle.bind { _ in
            self.setNavigationTitle()
        }
        outputProfileNickname.bind { _ in
            self.setProfileTitle()
        }
        outputProfileImage.bind { _ in
            self.setProfileImage()
        }
        outputJoinedDate.bind { _ in
            self.setJoindDate()
        }
        
    }
    
    private func setNavigationTitle() {
        outputNavigationTitle.value = "SETTING"
    }
    private func setProfileTitle() {
        outputProfileNickname.value = UserDefaultManager.nickname
    }
    private func setProfileImage() {
        outputProfileImage.value = UserDefaultManager.profileImage
    }
    private func setJoindDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: UserDefaultManager.joinedDate)
        
        outputJoinedDate.value = "\(date)가입"
    }
    
}

















