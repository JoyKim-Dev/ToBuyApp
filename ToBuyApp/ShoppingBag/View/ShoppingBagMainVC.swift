//
//  ShoppingBagMainVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

import SnapKit

final class ShoppingBagMainVC: BaseViewController {
    
    let viewModel = ShoppingBagMainViewModel()
    private var segmentIndex = 0
    
    private lazy var segment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["상품", "카테고리"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let searchBar = UISearchBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShoppingBagMainCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingBagMainCollectionViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ShoppingBagTableViewCell.self, forCellReuseIdentifier: ShoppingBagTableViewCell.identifier)
        
        searchBar.delegate = self
        
        viewModel.inputViewDidLoadTrigger.value = ()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = ()
        collectionView.reloadData()
        tableView.reloadData()
        configView()
    }
    deinit{
        print("ShoppingBagMainVC Deinit")
    }
    override func configHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(segment)
    }
    
    override func configLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        segment.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        hideKeyboardWhenTappedAround()
        segment.addTarget(self, action: #selector(segmentChanged(segment:)), for: .valueChanged)
        tableView.rowHeight = 300

    }
    
    func bindData() {
        viewModel.outputNavigationTitle.bind { [weak self] title in
            self?.setNavTitle(title)
        }
        viewModel.outputSearchBarFilter.bind { [weak self] _ in
            self?.tableView.reloadData()
            self?.collectionView.reloadData()
        }
        viewModel.outputCategoryList.bind { [weak self] _ in
            self?.tableView.reloadData()
            self?.collectionView.reloadData()
        }
        viewModel.outputShoppingList.bind { [weak self] _ in
            self?.tableView.reloadData()
            self?.collectionView.reloadData()
        }
        viewModel.outputSearchBarFilter.bind { [weak self] _ in
            self?.tableView.reloadData()
            self?.collectionView.reloadData()
        }
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
        let selectedIndex = segment.selectedSegmentIndex
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
        default:
            break
        }
    }
    
    @objc func likedBtnTapped(_ btn: UIButton) {
        viewModel.inputLikeBtnTapped.value = btn.tag
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension ShoppingBagMainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputCategoryList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingBagTableViewCell.identifier, for: indexPath) as! ShoppingBagTableViewCell
        cell.configUI(data: viewModel.outputCategoryList.value[indexPath.row])
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(ShoppingBagMainCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingBagMainCollectionViewCell.identifier)
        cell.collectionView.tag = indexPath.row
        cell.backgroundColor = .orange
        cell.collectionView.reloadData()
        return cell
    }
}

extension ShoppingBagMainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentIndex == 0 {
            return viewModel.outputShoppingList.value.count
        } else {
            return viewModel.outputCategoryList.value[collectionView.tag].detail.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingBagMainCollectionViewCell.identifier, for: indexPath) as! ShoppingBagMainCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.likeBtn.addTarget(self, action: #selector(likedBtnTapped), for: .touchUpInside)
        cell.likeBtn.tag = indexPath.item
        if segmentIndex == 0 {
            cell.configUI(data: viewModel.outputShoppingList.value[indexPath.item])
        } else {
            cell.configUI(data: viewModel.outputCategoryList.value[collectionView.tag].detail[indexPath.item])
        }
        return cell
    }
}

extension ShoppingBagMainVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.inputSearchBarTextChanged.value = searchText
    }
}
