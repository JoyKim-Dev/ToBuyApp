//
//  ProfileNicknameViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

final class ProfileNicknameViewModel {

    var inputBackBtnTapped: Observable <Void?> = Observable(nil)
    var inputNickname: Observable<String?> = Observable("")
    
    var outputNavigationTitle: Observable<String> = Observable("")
    var outputNickTextFieldText: Observable<String> = Observable("")
    var outputImage: Observable<Int> = Observable(0)
    var outputSubmitBtn: Observable<Bool> = Observable(false)
    var outputNicknameStatus: Observable<String> = Observable("")
   // var outputTextFieldShouldReturn: Observable<Bool> = Observable(true)
    
    init() {
        transform()
        
    }
    
    private func transform() {
        
        outputNavigationTitle.bind { _ in
            self.setNavigationTitle()
        }
        outputNickTextFieldText.bind { _ in
            self.nicknameTextFieldText()
        }
        outputImage.bind { _ in
            self.selectImage()
        }
        outputNicknameStatus.bind { _ in
            self.nicknameValidation()
        }
        outputSubmitBtn.bind { _ in
            self.outputSubmitBtnisOn()
        }
        inputBackBtnTapped.bind { _ in
            self.resetSelectedImage()
        }
      //  outputTextFieldShouldReturn.bind { _ in
//            if self.outputNicknameStatus.value == TextFieldValidation.valid.value {
//                self.outputTextFieldShouldReturn.value = true
//            } else {
//                self.outputTextFieldShouldReturn.value = false
//            }
//        }
   
    }
    
    private func setNavigationTitle() {
        if !UserDefaultManager.nickname.isEmpty {
            outputNavigationTitle.value = "EDIT PROFILE"
        } else {
            outputNavigationTitle.value = "PROFILE SETTING"
        }
    }
    private func nicknameTextFieldText() {
        
        if !UserDefaultManager.nickname.isEmpty {
            outputNickTextFieldText.value = UserDefaultManager.nickname
        } else {
            outputNickTextFieldText.value = ""
        }
    }
    private func selectImage() {
        if UserDefaultManager.profileImage == nil {
            outputImage.value = Int.random(in: 0...11)
            UserDefaultManager.profileImage = outputImage.value
            print(outputImage.value)
        } else {
            guard let image = UserDefaultManager.profileImage else {return}
            outputImage.value = image
        }
    }
    private func resetSelectedImage() {
        if UserDefaultManager.nickname.isEmpty {
            UserDefaults.standard.removeObject(forKey: "profileImage")
            print("삭제됨")
        }
    }
     func nicknameValidation()  {
        guard let nickname = inputNickname.value else {return}
        guard !nickname.isEmpty else {
            outputNicknameStatus.value = TextFieldValidation.emptyString.value
            return
        }
        guard nickname.count > 1 && nickname.count < 10 else {
            outputNicknameStatus.value = TextFieldValidation.tooShortOrTooLong.value
            return
        }
        guard nickname.containsNumber() == false else {
            outputNicknameStatus.value = TextFieldValidation.isInt.value
            return
        }
        guard nickname.containsAnyOfSpecificSymbols(["@","#","$","%"]) == false else {
            outputNicknameStatus.value = TextFieldValidation.containsSymbol.value
            return
        }
        guard !nickname.contains(" ") else {
            outputNicknameStatus.value = TextFieldValidation.containsBlank.value
            return
        }
        outputNicknameStatus.value = TextFieldValidation.valid.value
    }
    private func outputSubmitBtnisOn() {
        if outputNicknameStatus.value != TextFieldValidation.valid.value {
            outputSubmitBtn.value = false
        } else {
            outputSubmitBtn.value = true
        }
    }
    
    func popViewController(currentVC: UIViewController) {
        currentVC.navigationController?.popViewController(animated: true)
    }
    func submitValidation(currentVC:UIViewController) {
    if outputNicknameStatus.value != TextFieldValidation.valid.value {
        return
    } else if UserDefaultManager.nickname.isEmpty {
        UserDefaultManager.nickname = inputNickname.value ?? ""
        UserDefaultManager.joinedDate = Date()
        UserDefaultManager.profileImage = outputImage.value
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let rootViewController = TabBarController()
        sceneDelegate?.window?.rootViewController = rootViewController
        sceneDelegate?.window?.makeKeyAndVisible()
    } else {
        UserDefaultManager.nickname = inputNickname.value ?? ""
        UserDefaultManager.profileImage = outputImage.value
        currentVC.navigationController?.popViewController(animated: true)
    }
}

    
    
}
