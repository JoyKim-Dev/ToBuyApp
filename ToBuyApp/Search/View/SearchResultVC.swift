//
//  SearchResultVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

import Alamofire
import SnapKit
import RealmSwift

final class SearchResultVC: BaseViewController {
 
        private lazy var numberOfResultLabel = UILabel()
        private let accuracyFilterBtn = UIButton.Configuration.filteredButton(title: SearchResultSortType.accuracy.btnTitle)
        private let recentDateFilterBtn = UIButton.Configuration.filteredButton(title: SearchResultSortType.recentDate.btnTitle)
        private let priceTopDownFilterBtn = UIButton.Configuration.filteredButton(title: SearchResultSortType.priceTopDown.btnTitle)
        private let priceDownTopFilterBtn = UIButton.Configuration.filteredButton(title: SearchResultSortType.priceDownTop.btnTitle)
        private lazy var btns = [accuracyFilterBtn, recentDateFilterBtn, priceDownTopFilterBtn, priceTopDownFilterBtn]
        private lazy var filterStackView = UIStackView()
        private lazy var searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchCollectionViewLayout())
        
        let realm = try! Realm()
        let realmRepository = ShoppingBagRepository()
        let categoryRepository = CategoryRepository()
        var liked: ShoppingBagItemTable?
        var detail = List<ShoppingBagItemTable>()
        
        
        var searchWordFromPreviousPage: String?
        lazy var query = searchWordFromPreviousPage
        
        private var list = Product(lastBuildDate: "", total: 1, start: 1 , display: 1, items: [])
        private var start = 1
        private var apiSortType = SearchResultSortType.accuracy.rawValue
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            navigationItem.leftBarButtonItem = NavBackBtn(currentVC: self)
            searchResultCollectionView.delegate = self
            searchResultCollectionView.dataSource = self
            searchResultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
            searchResultCollectionView.prefetchDataSource = self
         
            callRequest(searchQuery: String(query ?? ""))
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            searchResultCollectionView.reloadData()
        }

    override func configHierarchy() {
            
            view.addSubview(numberOfResultLabel)
            view.addSubview(filterStackView)
            view.addSubview(searchResultCollectionView)
            
            for i in btns {
                
                filterStackView.addArrangedSubview(i)
            }
        }
        
    override func configLayout() {
            numberOfResultLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
                make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            }
            
            filterStackView.snp.makeConstraints { make in
                make.top.equalTo(numberOfResultLabel.snp.bottom).offset(10)
                make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
                //  make.trailing.equalTo(view.safeAreaLayoutGuide).inset(85)
                make.height.equalTo(30)
            }
            
            searchResultCollectionView.snp.makeConstraints { make in
                make.top.equalTo(filterStackView.snp.bottom).offset(10)
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            
        }
        
    override func configView() {
            
            setNavTitle(searchWordFromPreviousPage ?? "")
            
            numberOfResultLabel.textColor = Color.orange
            numberOfResultLabel.font = Font.heavy15
            
            filterStackView.axis = .horizontal
            filterStackView.spacing = 8
            filterStackView.distribution = .fillProportionally
            
            searchResultCollectionView.backgroundColor = Color.white
            
            accuracyFilterBtn.addTarget(self, action: #selector(accuracyBtnTapped), for: .touchUpInside)
            recentDateFilterBtn.addTarget(self, action: #selector(recentBtnTapped), for: .touchUpInside)
            priceTopDownFilterBtn.addTarget(self, action: #selector(priceTopDownTapped), for: .touchUpInside)
            priceDownTopFilterBtn.addTarget(self, action: #selector(priceDownTopTapped), for: .touchUpInside)
            
        }
        
        func searchCollectionViewLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewFlowLayout()
            
            let sectionSpacing:CGFloat = 10
            let cellSpacing:CGFloat = 12
            
            let width = UIScreen.main.bounds.width - (sectionSpacing * 2) - (cellSpacing * 3)
            layout.itemSize = CGSize(width: width/2, height: width/1.2)
            layout.scrollDirection = .vertical
            
            layout.minimumInteritemSpacing = cellSpacing
            layout.minimumLineSpacing = cellSpacing
            layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: 100, right: sectionSpacing)
            return layout
            
        }
        
        func callRequest(searchQuery: String) {
            guard !searchQuery.isEmpty else { return }
            NaverShoppingManager.shared.request(api: .productList(query: query ?? "", page: 1, display: 30, sort: Sort.sim), model: Product.self) { product, error in
                
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        let alert = UIAlertController(
                            title: "네트워크 에러",
                            message: "인터넷 통신에 실패했습니다. 인터넷 연결을 확인한 후 다시 시도해주세요.",
                            preferredStyle: .alert)
                        let ok = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(ok)
                        self.present(alert, animated: true)
                        return
                    }
                    
                    guard let product = product else { return }
                    
                    self.numberOfResultLabel.text = "\(product.total.formatted())개의 검색 결과"
                    
                    if self.start == 1 {
                        self.list = product
                        self.searchResultCollectionView.reloadData()
                        if !self.list.items.isEmpty {
                            self.searchResultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        }
                    } else {
                        let oldItemCount = self.list.items.count
                        self.list.items.append(contentsOf: product.items)
                        var indexPaths = [IndexPath]()
                        for i in oldItemCount..<self.list.items.count {
                            indexPaths.append(IndexPath(item: i, section: 0))
                        }
                        self.searchResultCollectionView.insertItems(at: indexPaths)
                    }
                }
            }
        }
        @objc func likeBtnTapped(sender: UIButton) {
            let index = sender.tag
            print(index)
            let id = list.items[index].productId
            print(realm.configuration.fileURL)
            liked = ShoppingBagItemTable(id: id, title: list.items[index].title, price: list.items[index].lprice, webLink: list.items[index].link, category: list.items[index].category2, image: list.items[index].image )
            
            guard let data = liked else {
                print("data nil")
                return}
            
            let categoryName = realm.objects(Category.self).where {
                $0.category == data.category}
            
            if let _ = realm.object(ofType: ShoppingBagItemTable.self, forPrimaryKey: id) {
                realmRepository.deleteItem(id: id)
                print("Product deleted")
            } else {
                    if let category = categoryName.first {
                        realmRepository.createItem(data, category: category)
                    } else {
                        detail.append(data)
                        let category = Category(category: data.category, detail: detail)
                        categoryRepository.createCategory(category)
                        detail.removeAll()
                    }
            }
            searchResultCollectionView.reloadData()
    
        }
        
        @objc func accuracyBtnTapped() {
            apiSortType = SearchResultSortType.accuracy.rawValue
            start = 1
            callRequest(searchQuery: query ?? "미정")
            print(accuracyFilterBtn.isFocused)
            btns.forEach { $0.isSelected = false }
            accuracyFilterBtn.isSelected = true
        }
        
        @objc func recentBtnTapped() {
            apiSortType = SearchResultSortType.recentDate.rawValue
            start = 1
            callRequest(searchQuery: query ?? "미정")
            btns.forEach { $0.isSelected = false }
            recentDateFilterBtn.isSelected = true
        }
        @objc func priceTopDownTapped() {
            apiSortType = SearchResultSortType.priceTopDown.rawValue
            start = 1
            btns.forEach { $0.isSelected = false }
            priceTopDownFilterBtn.isSelected = true
            callRequest(searchQuery: query ?? "미정")
            
        }
        @objc func priceDownTopTapped() {
            apiSortType = SearchResultSortType.priceDownTop.rawValue
            start = 1
            btns.forEach { $0.isSelected = false }
            priceDownTopFilterBtn.isSelected = true
            callRequest(searchQuery: query ?? "미정")
        }
    }

    extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return list.items.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
            let data = list.items[indexPath.item]
            cell.configUI(data: data, indexPath: indexPath)
            cell.likeBtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.item
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = SearchItemDetailVC()
            vc.searchDataFromPreviousPage = list.items[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    extension SearchResultVC: UICollectionViewDataSourcePrefetching {
        func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
            
            for i in indexPaths {
                if list.items.count - 3 == i.item {
                    start += 1
                    callRequest(searchQuery: query ?? "미정")
                }
            }
        }
    }

