//
//  SearchResultCollectionViewCell.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

import SnapKit
import Kingfisher
import RealmSwift

final class SearchResultCollectionViewCell: BaseCollectionViewCell {
    let realm = try! Realm()
    private let productImageView = UIImageView()
     let likeBtn = LikeBtn()
    
    private let storeNameLabel = UILabel()
    private let productNameLabel = UILabel()
    private let productPriceLabel = UILabel()
    let repository = ShoppingBagRepository()
   
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configHierarchy() {
        contentView.addSubview(productImageView)
        contentView.addSubview(likeBtn)
        contentView.addSubview(storeNameLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPriceLabel)
    }
    
    override func configLayout() {
        productImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(contentView).multipliedBy(0.7)
        }
        
        likeBtn.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(25)
            make.bottom.trailing.equalTo(productImageView).inset(15)
        }
        
        storeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(3)
            make.leading.equalTo(contentView)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.lessThanOrEqualTo(productPriceLabel.snp.top)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(contentView)
        }
    }
    
    func configUI(data: ItemResult, indexPath: IndexPath) {
        super.configUI()
        contentView.backgroundColor = Color.white
        productImageView.layer.cornerRadius = 10
        productImageView.layer.masksToBounds = true
        
        let url = URL(string: data.image)
        productImageView.kf.setImage(with: url)
        productImageView.backgroundColor = .gray
        
        storeNameLabel.text = data.mallName
        storeNameLabel.font = Font.semiBold13
        storeNameLabel.textColor = Color.lightGray
        
        // 특정 문자열 여러개 제거!
        productNameLabel.text = data.title.replacingOccurrences(of: "[<b></b>]", with: "", options: .regularExpression)
        productNameLabel.lineBreakMode = .byCharWrapping
        productNameLabel.font = Font.semiBold14
        productNameLabel.numberOfLines = 2
        
        
        if let _ = realm.object(ofType: ShoppingBagItemTable.self, forPrimaryKey: data.productId) {
            likeBtn.backgroundColor = Color.white
            likeBtn.setImage(Icon.likeSelected, for: .normal)
            likeBtn.tintColor = Color.black

        } else {
            likeBtn.backgroundColor = Color.lightGray
            likeBtn.setImage(Icon.likeUnSelected, for: .normal)
            likeBtn.tintColor = Color.white
        }
        
        let price = data.lprice
        let priceInt = Int(price)!.formatted()
        productPriceLabel.text  = "\(String(priceInt))원"
        productPriceLabel.font = Font.heavy15
    }
}

