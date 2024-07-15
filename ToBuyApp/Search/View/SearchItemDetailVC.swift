//
//  SearchItemDetailVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

import SnapKit
import WebKit
import RealmSwift

final class SearchItemDetailVC: BaseViewController {
    let realm = try! Realm()
    let repository = ShoppingBagRepository()
    let categoryRepository = CategoryRepository()
    var searchDataFromPreviousPage:ItemResult?
    var likedDataFromPreviousPage: String = ""
    let folderRepository = CategoryRepository()
    var detail = List<ShoppingBagItemTable>()
    
    private let webView = WKWebView()
    private lazy var navLikeBtn = UIBarButtonItem(image: .likeSelected, style: .plain, target: self, action: #selector(navLikeBtnTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configView()
        
    }

    override func configHierarchy() {
        view.addSubview(webView)
    }
    
    override func configLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        navigationItem.leftBarButtonItem = NavBackBtn(currentVC: self)
        
        setNavTitle(searchDataFromPreviousPage?.title.replacingOccurrences(of: "[<b></b>]", with: "", options: .regularExpression) ?? "")
        if let _ = realm.object(ofType: ShoppingBagItemTable.self, forPrimaryKey: searchDataFromPreviousPage?.productId) {
            navLikeBtn.image = .likeSelected.withRenderingMode(.alwaysOriginal)
        } else {
            navLikeBtn.image = .likeUnselected.withRenderingMode(.alwaysOriginal)
        }
        
        navigationItem.rightBarButtonItem = navLikeBtn
        
        guard let url = searchDataFromPreviousPage?.link else {
            return
        }
        
        guard let validURL = URL(string: url) else {
            print("유효하지 않은 url")
            return
        }
        
        if likedDataFromPreviousPage != "" {
            let request = URLRequest(url: URL(string:likedDataFromPreviousPage)!)
            webView.load(request)
        } else {
            let request = URLRequest(url: validURL)
            webView.load(request)
        }
    }
    
    @objc func navLikeBtnTapped() {
        
        guard let id = searchDataFromPreviousPage?.productId, let title = searchDataFromPreviousPage?.title, let price = searchDataFromPreviousPage?.lprice, let weblink = searchDataFromPreviousPage?.link, let image = searchDataFromPreviousPage?.image , let category = searchDataFromPreviousPage?.category2 else {
            print("no data")
            return
        }
        
        let liked = ShoppingBagItemTable(id: id, title: title, price: price, webLink: weblink, category: category, image: image )
        
        let categoryName = realm.objects(Category.self).where {
            $0.category == liked.category}
        
        if let _ = realm.object(ofType: ShoppingBagItemTable.self, forPrimaryKey: id) {
            repository.deleteItem(id: id)
            print("Product deleted")
        } else {
                if let category = categoryName.first {
                    repository.createItem(liked, category: category)
                } else {
                    detail.append(liked)
                    let category = Category(category: liked.category, detail: detail)
                    categoryRepository.createCategory(category)
                }
        }
        configView()
    }
}

