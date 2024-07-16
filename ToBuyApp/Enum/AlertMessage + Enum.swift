//
//  AlertMessage + Enum.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/15/24.
//

import Foundation

enum AlertMessage {
    case deleteAccountTitle
    case deleteAccountMessage
    case answerOK
    case searchErrorTitle
    case searchErrorMessage
    
    var text:String {
        switch self {
        case .deleteAccountTitle:
            "탈퇴하기"
        case .deleteAccountMessage:
            "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?"
        case .answerOK:
            "확인"
        case .searchErrorTitle:
            "검색어 오류"
        case .searchErrorMessage:
            "검색어를 입력해 주세요."
        }
    }
}
