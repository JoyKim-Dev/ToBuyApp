//
//  SearchItemDetailVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

import SnapKit
import WebKit

final class SearchItemDetailVC: BaseViewController {
    
   let viewModel = SearchItemDetailViewModel()
    private let webView = WKWebView()
    private lazy var navLikeBtn = UIBarButtonItem(image: .likeSelected, style: .plain, target: self, action: #selector(navLikeBtnTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoadTrigger.value = ()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configView()
    }
    
    deinit{
        print("SearchItemDetailVC Deinit")
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
        navigationItem.rightBarButtonItem = navLikeBtn

    }
    
    func bindData() {
        viewModel.outputNavTitleSet.bind { [weak self] title in
            self?.setNavTitle(title)
        }
        viewModel.outputNavCartBtnImage.bind { [weak self] image in
            self?.navLikeBtn.image = UIImage(systemName: image)
        }
        viewModel.outputURLValidation.bind { [weak self] request in
            guard let request else {return}
            self?.webView.load(request)
        }
    }
    @objc func navLikeBtnTapped() {
        viewModel.inputNavCartBtnTapped.value = ()
    }
}

