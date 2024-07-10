//
//  shoppingBagBtn.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/11/24.
//

import UIKit

class LikeBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
       
        layer.cornerRadius = 3
        clipsToBounds = true
        imageEdgeInsets = UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
        backgroundColor = Color.unselectedGray
        tintColor = Color.white
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
