//
//  ToastMessage + Enum.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/18/24.
//

import Foundation

enum ToastMessage {
    case unRealeasedView
    case itemSaved
    case itemUnsaved
    
    var message:String {
        switch self {
        case .unRealeasedView:
            "🐥 아직 준비중이에요"
        case .itemSaved:
            "찜 추가되었습니다."
        case .itemUnsaved:
            "찜 해제되었습니다."
        }
    }
}
