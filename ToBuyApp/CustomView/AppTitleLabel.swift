//
//  AppTitleLabel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

class AppTitleLabel:UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        text = "TOBUYBAG"
        font = Font.appTitleFont
        textColor = Color.orange
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
