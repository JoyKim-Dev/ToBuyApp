//
//  SearchResultVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit
import SnapKit

final class SearchResultVC: BaseViewController {
    
    var viewModel = SearchResultViewModel()
    
    private lazy var numberOfResultLabel = UILabel()
    private let accuracyFilterBtn = UIButton.Configuration.filteredButton(title: SearchResultSortType.accuracy.btnTitle)
    private let recentDateFilterBtn = UIButton.Configuration.filteredButton(title: SearchResultSortType.recentDate.btnTitle)
    private let priceTopDownFilterBtn = UIButton.Configuration.filteredButton(title: SearchResultSortType.priceTopDown.btnTitle)
    private let priceDownTopFilterBtn = UIButton.Configuration.filteredButton(title: SearchResultSortType.priceDownTop.btnTitle)
    
    private lazy var btns = [accuracyFilterBtn, recentDateFilterBtn, priceDownTopFilterBtn, priceTopDownFilterBtn]
    
    private lazy var filterStackView = UIStackView()
    private lazy var searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = NavBackBtn(currentVC: self)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        searchResultCollectionView.prefetchDataSource = self
        
        viewModel.inputViewDidLoadTrigger.value = ()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultCollectionView.reloadData()
    }
    
    deinit{
        print("SearchResultViewModel Deinit")
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
        
        setNavTitle(viewModel.outputNavigationTitle.value)
        
        numberOfResultLabel.textColor = Color.orange
        numberOfResultLabel.font = Font.heavy15
        
        filterStackView.axis = .horizontal
        filterStackView.spacing = 8
        filterStackView.distribution = .fillProportionally
        
        searchResultCollectionView.backgroundColor = Color.white
        
        accuracyFilterBtn.addTarget(self, action: #selector(accuratebtnTapped), for: .touchUpInside)
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
    
    func bindData() {
        
        viewModel.outputNavigationTitle.bind { [weak self] title in
            self?.setNavTitle(title)
        }
        viewModel.outputList.bind { [weak self] _ in
            self?.searchResultCollectionView.reloadData()
        }
        //        viewModel.outputError.bind { error in
        //            AlertManager.showAlert(viewController: self, title: error?.title! , message: error?.message!, ok: "확인") {
        //            }
        //        }
        viewModel.outputResultCountLabel.bind {[weak self] text in
            self?.numberOfResultLabel.text = text
        }
        
    }
    @objc func likeBtnTapped(sender: UIButton) {
        viewModel.inputLikeBtnTapped.value = sender.tag
        searchResultCollectionView.reloadData()
        
    }
    
    @objc func accuratebtnTapped(sender: UIButton) {
        viewModel.inputFilterBtnType.value = SearchResultSortType.accuracy.rawValue
        viewModel.inputQueryPage.value = 1
        btns.forEach { $0.isSelected = false }
        accuracyFilterBtn.isSelected = true
        self.searchResultCollectionView.reloadData()
    }
    
    @objc func recentBtnTapped() {
        viewModel.inputFilterBtnType.value = SearchResultSortType.recentDate.rawValue
        viewModel.inputQueryPage.value = 1
        btns.forEach { $0.isSelected = false }
        recentDateFilterBtn.isSelected = true
        self.searchResultCollectionView.reloadData()
    }
    @objc func priceTopDownTapped() {
        viewModel.inputFilterBtnType.value = SearchResultSortType.priceTopDown.rawValue
        viewModel.inputQueryPage.value = 1
        btns.forEach { $0.isSelected = false }
        priceTopDownFilterBtn.isSelected = true
        self.searchResultCollectionView.reloadData()
        
    }
    @objc func priceDownTopTapped() {
        viewModel.inputFilterBtnType.value = SearchResultSortType.priceDownTop.rawValue
        viewModel.inputQueryPage.value = 1
        btns.forEach { $0.isSelected = false }
        priceDownTopFilterBtn.isSelected = true
        self.searchResultCollectionView.reloadData()
    }
}

extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        let data = viewModel.outputList.value[indexPath.item]
        cell.configUI(data: data, indexPath: indexPath)
        cell.likeBtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
        cell.likeBtn.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SearchItemDetailVC()
        vc.viewModel.inputSearchDataFromPreviousPage.value = viewModel.outputList.value[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        viewModel.inputCollectionViewDataPrefetching.value = indexPaths
    }
}

