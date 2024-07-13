//
//  NicknameStatusLabel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/11/24.
//

import UIKit

class NicknameStatusLabel:UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        
        textColor = Color.orange
        font = Font.semiBold13
        self.text = text
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
