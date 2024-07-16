//
//  ShoppingBagMainVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

import RealmSwift
import SnapKit

final class ShoppingBagMainVC:BaseViewController {
    
    let realm = try! Realm()
    let repository = ShoppingBagRepository.shared
    let categoryRepository = CategoryRepository.shared
    lazy var liked = repository.fetchAlls()
    lazy var list = categoryRepository.fetchCategory()
    var segmentIndex = 0

    let segment = {
        let control = UISegmentedControl(items: ["상품", "카테고리"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    let searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    lazy var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShoppingBagMainCollectionViewCell.self, forCellWithReuseIdentifier:   ShoppingBagMainCollectionViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ShoppingBagTableViewCell.self, forCellReuseIdentifier: ShoppingBagTableViewCell.identifier)
        
        searchBar.delegate = self
        
        list = categoryRepository.fetchCategory()
        print(repository.detectRealmURL())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        liked  = repository.fetchAlls()
        list = categoryRepository.fetchCategory()
        collectionView.reloadData()
        tableView.reloadData()
        configView()
    
    }
    
    override func configHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(segment)
    }
    
    override func configLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
        segment.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        navigationItem.title = "찜 \(liked.count)개 목록"
        hideKeyboardWhenTappedAround()
        segment.addTarget(self, action: #selector(segmentChanged(segment:)), for: .valueChanged)
        tableView.rowHeight = 300
    }
}

extension ShoppingBagMainVC {
     
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: width / 3, height: width / 2)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return layout
    }
    
    @objc func segmentChanged(segment: UISegmentedControl) {
        print(#function)
     
        let selectedIndex = segment.selectedSegmentIndex
        print(selectedIndex)
        switch selectedIndex {
           case 0:
               segmentIndex = 0
               tableView.isHidden = true
                collectionView.isHidden = false
                collectionView.reloadData()
           case 1:
               segmentIndex = 1

               collectionView.isHidden = true
               tableView.isHidden = false
           tableView.reloadData()
           case 2:
               segmentIndex = 2
                collectionView.isHidden = true
               tableView.isHidden = true

           default:
               break
           }
        viewWillAppear(true)
    }
    
    @objc func likedBtnTapped(_ btn: UIButton){
        
        print(#function)
        let index = btn.tag
        let all = repository.fetchAlls()
        let category = all[index].main.first
        guard let category = category else {return}
        
        if category.detail.count == 1 {
            categoryRepository.removeCategory(category)
        } else if category.detail.count > 1 {
            repository.deleteItem(id: all[index].id)
            print("Product deleted")
        }
        viewWillAppear(true)
    }
}

extension ShoppingBagMainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(list)
        return list.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingBagTableViewCell.identifier, for: indexPath) as! ShoppingBagTableViewCell
        
        cell.configUI(data: list[indexPath.row])
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(ShoppingBagMainCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingBagMainCollectionViewCell.identifier)
        cell.collectionView.tag = indexPath.row
        cell.collectionView.reloadData()
        
        return cell
    }

}
extension ShoppingBagMainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentIndex == 0 || collectionView == self.collectionView {
            return liked.count
        } else {
            return list[collectionView.tag].detail.count
        }
    }
    
    // PageViewController
    // Tabman, PageBoy
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingBagMainCollectionViewCell.identifier, for: indexPath) as! ShoppingBagMainCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.likeBtn.addTarget(self, action: #selector(likedBtnTapped), for: .touchUpInside)
        cell.likeBtn.tag = indexPath.item
        
        if segmentIndex == 0 || collectionView == self.collectionView {
            cell.configUI(data: liked[indexPath.item])
        
            return cell
        } else {
            cell.configUI(data: list[collectionView.tag].detail[indexPath.item])
            return cell
        }
    }
    
}

extension ShoppingBagMainVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = realm.objects(ShoppingBagItemTable.self).where { $0.title.contains(searchText, options: .caseInsensitive) }
        let categoryFilter = realm.objects(Category.self).where {
            $0.detail.title.contains(searchText, options: .caseInsensitive)
        }
        liked = filter
        list = categoryFilter
        
        collectionView.reloadData()
        tableView.reloadData()
        
    }

}

