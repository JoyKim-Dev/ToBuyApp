//
//  DateFormatterManager.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/15/24.
//

import Foundation

class DateFormatterManager {
    
    static let shared = DateFormatterManager()
    private init() {}
    
    static func dateToString(date:Date) -> String {

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: date)
    }
}
