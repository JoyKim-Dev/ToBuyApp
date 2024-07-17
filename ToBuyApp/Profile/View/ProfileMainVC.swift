//
//  ProfileMainVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

final class ProfileMainVC:BaseViewController {
    
    let viewModel = ProfileMainViewModel()
    
    private let profileView = UIView()
    private lazy var profileImageView = ProfileImageView(profileImageNum: profileImageNumData, cameraBtnMode: .isHidden, isSelected: true)
    
    private let profileNameLabel = {
    let view = UILabel()
        view.font = Font.heavy20
        return view
    }()
    private let joinedDateLabel = UILabel()

    private let toEditProfileBtn = {
        let view = UIButton()
        view.tintColor = .appTitle
        return view
    }()
    private var profileImageNumData = 0
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = ()
        tableView.reloadData()
        
        }
 
    override func configHierarchy() {
        view.addSubview(profileView)
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(joinedDateLabel)
        view.addSubview(toEditProfileBtn)
        view.addSubview(tableView)
    }
    
    override func configLayout() {
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(100)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(profileView)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView).inset(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        joinedDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileNameLabel)
            make.bottom.equalTo(profileView).inset(20)
        }
        
        toEditProfileBtn.snp.makeConstraints { make in
            make.centerY.equalTo(profileView)
            make.trailing.equalTo(profileView).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        
        navigationController?.navigationBar.shadowImage = nil
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.appTitle
        
        toEditProfileBtn.setImage(Icon.chevronRight, for: .normal)
        toEditProfileBtn.addTarget(self, action: #selector(toEditProfileBtnTapped), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileMainTableViewCell.self, forCellReuseIdentifier: ProfileMainTableViewCell.identifier)
        tableView.rowHeight = 40
    }
    
    func bindData() {
        
        viewModel.outputNavigationTitle.bind {  [weak self] value in
            self?.setNavTitle(value)
        }
        viewModel.outputJoinedDate.bind { [weak self] value in
            self?.joinedDateLabel.text = value
        }
        viewModel.outputProfileNickname.bind { [weak self] value in
            self?.profileNameLabel.text = value
        }
        viewModel.outputProfileImage.bind { [weak self] value in
            self?.profileImageNumData = value
        }
        viewModel.outputEditedNickname.bind {[weak self] value in
            print(value)
            self?.profileNameLabel.text = value
        }
        viewModel.outputEditedImage.bind { value in
            self.profileImageNumData = value
            self.profileImageView.changeImage(profileNum: self.profileImageNumData )
        }
        viewModel.outputToEditProfileBtnTapped.bindLater { [weak self] _ in
            self?.viewControllerPushTransition(toVC: ProfileNicknameVC())

        }
    }

    @objc func toEditProfileBtnTapped() {
        viewModel.inputToEditProfileBtnTapped.value = ()
    }
}

extension ProfileMainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profileMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMainTableViewCell.identifier, for: indexPath) as! ProfileMainTableViewCell
        let data = viewModel.profileMenu[indexPath.row]
        cell.configUI(data: data, indexPath: indexPath.row)
        switch indexPath.row {
        case 1,2,3:
            cell.selectionStyle = .none
        default:
            cell.selectionStyle = .default
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        switch index {
        case 0:
             sceneDelegateRootViewTransition(toVC: TabBarController())
        case 1,2,3:
             tableView.deselectRow(at: indexPath, animated: true)
        case 4:
            AlertManager.showAlert(viewController: self, title: AlertMessage.deleteAccountTitle.text, message: AlertMessage.deleteAccountMessage.text, ok: AlertMessage.answerOK.text) {
               self.viewModel.inputDeleteAccount.value = ()
              
                UserDefaultManager.shared.clearUserDefaults()
                let navOnboardingVC = UINavigationController(rootViewController: OnboardingVC())
                self.sceneDelegateRootViewTransition(toVC: navOnboardingVC)
                
            }
        default:
            return
        }
    }
}

