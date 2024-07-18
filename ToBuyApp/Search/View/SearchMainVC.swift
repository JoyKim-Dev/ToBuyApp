//
//  SearchMainVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit
import SnapKit

final class SearchMainVC:BaseViewController {
    
    let viewModel = SearchMainViewModel()
    
    private let searchBar = SearchBar()
    private let lineView = LineView()
    private let listTableView = UITableView()
    private let emptylistImageView = UIImageView()
    
    private let headerLabel = UILabel()
    private let noSearchWordLabel = {
        let view = UILabel()
        view.text = "최근 검색어가 없어요 🥹 \n원하시는 상품을 검색해보세요"
        view.font = Font.heavy20
        view.textColor = Color.black
        view.numberOfLines = 0
        view.textAlignment = .center
        
        return view
    }()
    private let headerDeleteAllBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoadTrigger.value = ()
        bindData()
    }
    
    deinit{
        print("SearchMainVC Deinit")
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.inputViewWillAppear.value = ()
        listTableView.reloadData()
    }
    override func configHierarchy() {
        view.addSubview(lineView)
        view.addSubview(emptylistImageView)
        view.addSubview(noSearchWordLabel)
        view.addSubview(listTableView)
        view.addSubview(searchBar)
    }
    
    override func configLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptylistImageView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        noSearchWordLabel.snp.makeConstraints { make in
            make.top.equalTo(emptylistImageView.snp.bottom).inset(100)
            make.centerX.equalTo(view)
        }
    }
    
    override func configView() {
        emptylistImageView.contentMode = .scaleAspectFill
        hideKeyboardWhenTappedAround()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(SearchMainTableViewCell.self, forCellReuseIdentifier: SearchMainTableViewCell.identifier)
        
        searchBar.delegate = self
        
        emptylistImageView.image = Image.emptyImage
        emptylistImageView.contentMode = .scaleAspectFit
        
        headerLabel.text = "최근 검색"
        headerLabel.font = Font.semiBold15
        
        headerDeleteAllBtn.setTitle("전체 삭제", for: .normal)
        headerDeleteAllBtn.titleLabel?.font = Font.semiBold14
        headerDeleteAllBtn.setTitleColor(Color.orange, for: .normal)
        headerDeleteAllBtn.addTarget(self, action: #selector(deleteAllTapped), for: .touchUpInside)
    }
    
    func bindData() {
        viewModel.outputNavigationTitle.bind { [weak self] value in
            self?.setNavTitle(value)
        }
        viewModel.outputSearchBarValidationResult.bindLater { [weak self] bool in
            if bool {
                let vc = SearchResultVC()
                vc.viewModel.inputSearchwordFromPreviousPage.value = UserDefaultManager.searchKeyword.first ?? ""
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                AlertManager.showAlert(viewController: self!, title: AlertMessage.searchErrorTitle.text, message: AlertMessage.searchErrorMessage.text, ok: AlertMessage.answerOK.text) {
                    print("alert")
                }
            }
        }
        
        viewModel.outputTableViewStatus.bind { [weak self] bool in
            self?.listTableView.isHidden = bool
        }
        viewModel.outputImageViewStatus.bind { [weak self] bool in
            self?.emptylistImageView.isHidden = bool
        }
        viewModel.outputNoSearchWordLabelStatus.bind {[weak self]  bool in
            self?.noSearchWordLabel.isHidden = bool
        }
        viewModel.outputSearchBarText.bind { [weak self] text in
            self?.searchBar.text = text
        }
        viewModel.outputSearchList.bind { [weak self] _ in
            self?.listTableView.reloadData()
        }
    }
    
    private func reloadSearchView() {
        viewModel.inputReloadSearchView.value = ()
    }
    
    @objc func deleteBtnTapped(_ sender: UIButton) {
        print(#function)
       UserDefaultManager.searchKeyword.remove(at: sender.tag)
//        viewModel.inputDeleteBtnTapped.value = (sender.tag)
        listTableView.reloadData()
        reloadSearchView()
    }
    
    @objc func deleteAllTapped() {
        print(#function)
       viewModel.inputDeleteAllTapped.value = ()
        listTableView.reloadData()
        reloadSearchView()
    }
}

extension SearchMainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        headerView.addSubview(headerLabel)
        headerView.addSubview(headerDeleteAllBtn)
        
        
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(headerView)
            make.leading.equalTo(headerView.safeAreaLayoutGuide).inset(10)
        }
        headerDeleteAllBtn.snp.makeConstraints { make in
            make.centerY.equalTo(headerView)
            make.trailing.equalTo(headerView.safeAreaLayoutGuide).inset(10)
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(UserDefaultManager.searchKeyword.count)
        return viewModel.outputSearchList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchMainTableViewCell.identifier , for: indexPath) as! SearchMainTableViewCell
        cell.configUI(searchKeywordRow: indexPath.row, searchlist: viewModel.outputSearchList.value)
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = SearchResultVC()
        vc.viewModel.inputSearchwordFromPreviousPage.value = viewModel.outputSearchList.value[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchMainVC: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        viewModel.inputSearchBarShouldEndEditing.value = searchBar.text ?? ""
        return viewModel.outputSearchBarShouldEndEditing.value
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchBtnClicked.value = searchBar.text ?? ""
    }
}

