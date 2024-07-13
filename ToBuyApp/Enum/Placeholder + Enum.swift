//
//  Placeholder + Enum.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/11/24.
//

import Foundation

enum Placeholder {
    case nicknameTextField
    
    var value: String {
        switch self {
        case .nicknameTextField:
             "닉네임을 입력해주세요:)"
        }
    }
}
