//
//  Design + Enum.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

enum Color {
    static let orange = UIColor(red: 0.94, green: 0.54, blue: 0.28, alpha: 1.00)
    static let black = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
    static let darkGray = UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1.00)
    static let mediumGray = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
    static let lightGray = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
    static let unselectedGray = Color.lightGray.withAlphaComponent(0.5)
    static let white = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
}

enum Font {
    static let semiBold13 = UIFont.systemFont(ofSize: 13, weight: .semibold)
    static let semiBold14 = UIFont.systemFont(ofSize: 14, weight: .semibold)
    static let semiBold15 = UIFont.systemFont(ofSize: 15, weight: .semibold)
    static let semiBold16 = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    static let heavy15 = UIFont.systemFont(ofSize: 15, weight: .heavy)
    static let heavy20 = UIFont.systemFont(ofSize: 20, weight: .heavy)
    
    static let appTitleFont = UIFont.systemFont(ofSize: 50, weight: .black)
}


enum ButtonHidden: String {
    case isHidden
    case isShowing
    
    var value: Bool {
        switch self {
        case .isHidden:
            return true
        case.isShowing:
            return false
        }
    }
}

