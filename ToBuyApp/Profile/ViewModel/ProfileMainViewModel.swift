//
//  ProfileMainViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation
import RealmSwift
import Toast

final class ProfileMainViewModel {
    let repository = ShoppingBagRepository.shared
    var profileMenu = ["나의 장바구니 목록", "자주 묻는 질문", "1:1문의", "알림 설정", "탈퇴하기"]
    
    var inputViewDidLoadTrigger = Observable(())
    var inputViewWillAppear: Observable<Void?> = Observable(nil)
    var inputToEditProfileBtnTapped: Observable<Void?> = Observable(nil)
    var inputDeleteAccount: Observable<Void?> = Observable(nil)
    
    var outputToEditProfileBtnTapped: Observable<Void?> = Observable(nil)
    var outputNavigationTitle: Observable<String> = Observable("")
    var outputJoinedDate: Observable<String> = Observable("")
    
    var outputProfileNickname: Observable<String> = Observable("")
    var outputProfileImage: Observable<Int> = Observable(0)
    var outputEditedNickname: Observable<String> = Observable("")
    var outputEditedImage: Observable<Int> = Observable(0)
    
    
    init() {
        transform()
    }
    
    private func transform() {
        
        
        inputDeleteAccount.bind {  [weak self]_ in
            self?.repository.deleteAll()
            print("repository deleted")
        }
        inputViewWillAppear.bind {  [weak self]_ in
            self?.outputEditedNickname.value = UserDefaultManager.nickname
            self?.outputEditedImage.value = UserDefaultManager.profileImage
        }
        
        inputToEditProfileBtnTapped.bind { [weak self] _ in
            self?.outputToEditProfileBtnTapped.value = ()
        }
        
        inputViewDidLoadTrigger.bind {  [weak self]_ in
            self?.setNavigationTitle()
        }
        outputJoinedDate.bind {  [weak self]_ in
            self?.setJoindDate()
        }
        
        outputProfileNickname.bind {  [weak self]_ in
            self?.setProfileTitle()
        }
        
        outputProfileImage.bind {  [weak self]_ in
            self?.setProfileImage()
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
        let joined = DateFormatterManager.dateToString(date: UserDefaultManager.joinedDate)
        outputJoinedDate.value = "\(joined)가입"
    }

}

