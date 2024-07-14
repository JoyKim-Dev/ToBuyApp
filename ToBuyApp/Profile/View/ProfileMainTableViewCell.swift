//
//  ProfileMainTableViewCell.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

import SnapKit
import RealmSwift

final class ProfileMainTableViewCell: BaseTableViewCell {

    private let label = UILabel()
    private let bagBtn = UIButton()
    let realm = try! Realm()
    let repository = ShoppingBagRepository()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configHierarchy() {
        contentView.addSubview(label)
        contentView.addSubview(bagBtn)
    }
    
    override func configLayout() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        bagBtn.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.height.equalTo(25)
            make.width.equalTo(125)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configUI(data: String, indexPath: Int) {
        super.configUI()
        label.text = data
        label.font = Font.semiBold15
        
        let likes = repository.fetchAlls()

        if indexPath == 0 {
            bagBtn.isHidden = false
            bagBtn.setTitleColor(Color.black, for: .normal)
            bagBtn.setTitle("\(likes.count)개의 상품", for: .normal)
            bagBtn.titleLabel?.font = Font.semiBold15
            bagBtn.setImage(Icon.likeSelected, for: .normal)
            bagBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 100)
        } else {
            bagBtn.isHidden = true
        }
    }
}

