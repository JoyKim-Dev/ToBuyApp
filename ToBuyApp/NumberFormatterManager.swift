//
//  NumberFormatterManager.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import Foundation

class NumberFormatterManager {
    
    static let shared = NumberFormatterManager()
    private init() {}
    
    static let nubmerFormatter = NumberFormatter()
    
    static let numberFormatter = {
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        return format.string(from: 1000)
    }()
}
