//
//  ProfileNicknameViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation

final class ProfileNicknameViewModel {

    var inputBackBtnTapped: Observable<Void?> = Observable(nil)
    var inputtextFieldDidChange: Observable<String?> = Observable("")
    var inputImageTapped: Observable<Void?> = Observable(nil)
    
    var outputImageTapped: Observable<Void?> = Observable(nil)
    var outputNavigationTitle: Observable<String> = Observable("")
    var outputNickTextFieldText: Observable<String> = Observable("")
    var outputImage: Observable<Int> = Observable(0)
    var outputSubmitBtn: Observable<Bool> = Observable(false)
    var outputNicknameStatus: Observable<String> = Observable("")
    
    init() {
        transform()
    }
    private func transform() {
        
        inputImageTapped.bind { _ in
            self.outputImageTapped.value  = ()
        }
        outputNavigationTitle.bind { _ in
            self.setNavigationTitle()
        }
        outputNickTextFieldText.bind { _ in
            self.nicknameTextFieldText()
        }
        outputImage.bind { _ in
            self.selectImage()
        }
        inputtextFieldDidChange.bind { _ in
            self.nicknameValidation()
        }
        inputBackBtnTapped.bind { _ in
            self.resetSelectedImage()
        }
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
        
        if UserDefaultManager.nickname.isEmpty {
            outputImage.value = Int.random(in: 0...11)
            UserDefaultManager.profileImage = outputImage.value
        } else {
            outputImage.value = UserDefaultManager.profileImage
        }
    }
    private func resetSelectedImage() {
        if UserDefaultManager.nickname.isEmpty {
            UserDefaults.standard.removeObject(forKey: "profileImage")
            print("삭제됨")
        }
    }
    private func nicknameValidation()  {
        
        if !outputNickTextFieldText.value.isEmpty && inputtextFieldDidChange.value == "" {
            outputNicknameStatus.value = TextFieldValidation.valid.value
            outputSubmitBtn.value = true
        } else {
            guard let nickname = inputtextFieldDidChange.value else {return}
            guard !nickname.isEmpty else {
                outputNicknameStatus.value = TextFieldValidation.emptyString.value
                return
            }
            guard nickname.count > 1 && nickname.count < 10 else {
                outputNicknameStatus.value = TextFieldValidation.tooShortOrTooLong.value
                outputSubmitBtn.value = false
                return
            }
            guard nickname.containsNumber() == false else {
                outputNicknameStatus.value = TextFieldValidation.isInt.value
                outputSubmitBtn.value = false
                return
            }
            guard nickname.containsAnyOfSpecificSymbols(["@","#","$","%"]) == false else {
                outputNicknameStatus.value = TextFieldValidation.containsSymbol.value
                outputSubmitBtn.value = false
                return
            }
            guard !nickname.contains(" ") else {
                outputNicknameStatus.value = TextFieldValidation.containsBlank.value
                outputSubmitBtn.value = false
                return
            }
            outputNicknameStatus.value = TextFieldValidation.valid.value
            outputSubmitBtn.value = true
        }
    }
    private func outputSubmitBtnisOn() {
        if outputNicknameStatus.value != TextFieldValidation.valid.value {
            outputSubmitBtn.value = false
        } else {
            outputSubmitBtn.value = true
        }
    }
}
