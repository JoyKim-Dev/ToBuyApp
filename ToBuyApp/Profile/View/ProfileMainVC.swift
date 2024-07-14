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
    
    private let profileNameLabel = UILabel()
    private let joinedDateLabel = UILabel()

    private let toEditProfileBtn = UIButton()
    private var profileImageNumData = 0
    
    private let tableView = UITableView()
    private let settingMenu = ["나의 장바구니 목록", "자주 묻는 질문", "1:1문의", "알림 설정", "탈퇴하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
        profileImageNumData = UserDefaultManager.profileImage
        profileImageView.changeImage(profileNum: profileImageNumData)
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
            make.centerY.equalTo(profileView)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(70)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        joinedDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileNameLabel)
            make.top.equalTo(profileNameLabel.snp.bottom).offset(10)
        }
        
        toEditProfileBtn.snp.makeConstraints { make in
            make.centerY.equalTo(profileView)
            make.trailing.equalTo(profileView).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        bindData()
        navigationController?.navigationBar.shadowImage = nil
        profileNameLabel.font = Font.heavy20
        
        
        toEditProfileBtn.setImage(Icon.chevronRight, for: .normal)
        toEditProfileBtn.addTarget(self, action: #selector(rightBarBtnTapped), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileMainTableViewCell.self, forCellReuseIdentifier: ProfileMainTableViewCell.identifier)
        tableView.rowHeight = 40
    }
    
    func bindData() {
        
        viewModel.outputNavigationTitle.bind { value in
            self.setNavTitle(value)
        }
        viewModel.outputProfileNickname.bind { value in
            self.profileNameLabel.text = value
        }
        viewModel.outputProfileImage.bind { value in
            self.profileImageNumData = value
        }
        viewModel.outputJoinedDate.bind { value in
            self.joinedDateLabel.text = value
        }
        
    }

}

extension ProfileMainVC {
    
    func showAlert(title: String, message: String, ok: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: ok, style: .default) { _ in
                completionHandler()
            }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
    }
    
    @objc func rightBarBtnTapped() {
        let vc = ProfileNicknameVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileMainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMainTableViewCell.identifier, for: indexPath) as! ProfileMainTableViewCell
        let data = settingMenu[indexPath.row]
        cell.configUI(data: data, indexPath: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            showAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", ok: "확인") {
                UserDefaultManager.shared.clearUserDefaults()
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let rootViewController = UINavigationController(rootViewController: OnboardingVC())
                sceneDelegate?.window?.rootViewController = rootViewController
                sceneDelegate?.window?.makeKeyAndVisible()
            }

        } else {
            return
        }
    }
}

