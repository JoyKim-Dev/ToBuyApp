//
//  SearchBar.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/11/24.
//

import UIKit

class SearchBar:UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        placeholder = "브랜드, 상품 등을 입력하세요."
        searchBarStyle = .minimal
        layer.borderColor = UIColor.black.cgColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

