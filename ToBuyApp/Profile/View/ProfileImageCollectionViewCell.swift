//
//  ProfileImageCollectionViewCell.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    
    lazy var imageView = ProfileImageView(profileImageNum: 4, cameraBtnMode: .isHidden, isSelected: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    deinit{
        print("ProfileImageCollectionViewCell Deinit")
    }
    
    override func configHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints { make in
            make.height.equalTo(contentView)
            make.width.equalTo(contentView)
        }
    }
    
    func configUI(data: Int) {
       super.configUI()
        self.imageView.tag = data
        self.imageView.changeImage(profileNum: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


