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
    
    private let viewModel = ProfileMainTableViewCellViewModel()
    private let label = UILabel()
    private let bagBtn = {
        let view = UIButton()
        view.setTitleColor(Color.black, for: .normal)
        view.titleLabel?.font = Font.semiBold15
        view.setImage(Icon.likeSelected, for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 100)
        return view
    }()
    
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
        
        if indexPath == 0 {
            bagBtn.isHidden = false
            viewModel.outputShoppingBagItemCount.bind { value in
                self.bagBtn.setTitle("\(value)개의 상품", for: .normal)
            }
            
        } else {
            bagBtn.isHidden = true
           
        }
    }
}

