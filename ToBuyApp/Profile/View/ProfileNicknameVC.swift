//
//  NicknameSettingVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit
import SnapKit


final class ProfileNicknameVC: BaseViewController {
    
    let viewModel = ProfileNicknameViewModel()
    
    private lazy var profileImageView = ProfileImageView(profileImageNum: selectedProfileImageNum, cameraBtnMode: .isShowing, isSelected: true)
    private lazy var nicknameTextField = NicknameTextField(placeholder: Placeholder.nicknameTextField.value)
    private let lineView = LineView()
    private lazy var nicknameStatusLabel = NicknameStatusLabel(text: textIsValid)
    private let submitBtn = OnboardingButton(btnTitle: "완료")
    
    var selectedProfileImageNum = UserDefaultManager.profileImage
    private var textIsValid = TextFieldValidation.valid.value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoadTrigger.value = ()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImageView.changeImage(profileNum: selectedProfileImageNum)
    }
    deinit{
        print("ProfileNicknameVC Deinit")
    }
    func bindData() {
        
        viewModel.outputNavigationTitle.bind { [weak self] title in
            self?.setNavTitle(title)
        }
        viewModel.outputImage.bind { [weak self] imageNum in
            self?.selectedProfileImageNum = imageNum
            self?.profileImageView.changeImage(profileNum: imageNum)
        }
        viewModel.outputNickTextFieldText.bind { [weak self] nickname in
            self?.nicknameTextField.text = nickname
        }
        viewModel.outputNicknameStatus.bind { [weak self] status in
            print(status)
            self?.nicknameStatusLabel.text = status
            self?.textIsValid = status
        }
        viewModel.outputSubmitBtn.bind { [weak self] status in
            self?.submitBtn.isEnabled = status
            print(status)
            self?.submitBtn.toggleOnboardingBtn()
        }
        viewModel.outputSubmitBtnTapped.bind { [weak self] value in
            if value == "error" {
                return
            } else if value == "newMember" {
                self?.sceneDelegateRootViewTransition(toVC: TabBarController())
            } else if value == "updateMember" {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func configHierarchy() {
        super.configHierarchy()
        view.addSubview(profileImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(lineView)
        view.addSubview(nicknameStatusLabel)
        view.addSubview(submitBtn)
    }
    
    override func configLayout() {
        super.configLayout()
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.width.equalTo(125)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(5)
        }
        nicknameStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        submitBtn.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configView() {
        super.configView()
        
        hideKeyboardWhenTappedAround()
        
        // 커스텀뷰 - 네비바 왼쪽버튼
        let backbtn = NavBackBtn(image: Icon.chevronLeft, style: .plain, target: self, action: #selector(backBtnTapped))
        navigationItem.leftBarButtonItem = backbtn
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.addGestureRecognizer(imageTapGesture)
        
        nicknameTextField.delegate = self
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        submitBtn.addTarget(self, action: #selector(submitBtnTapped), for: .touchUpInside)
    }
    
    @objc func imageTapped() {
        viewModel.inputBackBtnTapped.value = ()
        let vc = ProfileImageVC()
        vc.viewModel.imageDataFromPreviousPage = self.selectedProfileImageNum
        vc.viewModel.imageForDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        viewModel.inputtextFieldDidChange.value = sender.text
    }
    
    @objc func submitBtnTapped() {
        print(#function)
        viewModel.inputSubmitBtnTapped.value = nicknameStatusLabel.text ?? ""
        viewModel.inputNickName.value = nicknameTextField.text ?? ""
    }
    
    @objc func backBtnTapped() {
        viewModel.inputBackBtnTapped.value = ()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func popcurrentPage() {
        navigationController?.popViewController(animated: true)
    }
}
extension ProfileNicknameVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if nicknameStatusLabel.text != textIsValid {
            return false
        } else {
            submitBtnTapped()
            print(UserDefaultManager.nickname)
            return true
        }
    }
}

extension ProfileNicknameVC: ImageDelegate {
    func imageDataFromImageSettingpage(int: Int) {
        selectedProfileImageNum = int
    }
}
