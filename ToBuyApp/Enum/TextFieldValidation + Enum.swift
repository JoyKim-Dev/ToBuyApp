//
//  Error + Enum.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/11/24.
//

import Foundation

enum TextFieldValidation: Error {
    case emptyString
    case tooShortOrTooLong
    case isInt
    case containsSymbol
    case containsBlank
    case valid
    
    var value: String {
        switch self {
        case .emptyString:
            "닉네임을 입력해주세요"
        case .tooShortOrTooLong:
            "2글자 이상 10글자 미만으로 설정해주세요"
        case .isInt:
            "닉네임에 숫자는 포함할 수 없어요"
        case .containsSymbol:
            "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .containsBlank:
            "문자 사이 공백을 포함할 수 없어요"
        case.valid:
            "사용할 수 있는 닉네입이에요"
        }
    }
}
