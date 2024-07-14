//
//  NicknameSettingVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit
import RealmSwift
import SnapKit
import Toast


final class ProfileNicknameVC: BaseViewController, TabbarCoordinator {
    
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
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        profileImageView.changeImage(profileNum: selectedProfileImageNum)

    }
    
    func bindData() {
        
        viewModel.outputNavigationTitle.bind {  title in
            self.setNavTitle(title)
        }
        viewModel.outputImage.bind { imageNum in
            self.selectedProfileImageNum = imageNum
            self.profileImageView.changeImage(profileNum: imageNum)
                }
        viewModel.outputNickTextFieldText.bind { nickname in
            self.nicknameTextField.text = nickname
        }
        viewModel.outputNicknameStatus.bind {  status in
            print(status)
                    self.nicknameStatusLabel.text = status
                    self.textIsValid = status
                }
        viewModel.outputSubmitBtn.bind { status in
            self.submitBtn.isEnabled = status
            self.submitBtn.toggleOnboardingBtn()
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
        let vc = ProfileImageVC()
        vc.imageDataFromPreviousPage = selectedProfileImageNum
        vc.imageForDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func textFieldDidChange(_ sender: UITextField) {
        viewModel.inputtextFieldDidChange.value = sender.text
    }
    
    @objc func submitBtnTapped() {
        print(#function)
        //viewModel.submitValidation(currentVC: self)
        if nicknameStatusLabel.text != textIsValid {
            return
        } else if UserDefaultManager.nickname.isEmpty {
            // 멤버가 아니라면(UD값이 없다면) 현재 입력된 텍스트 UD에 저장.
            UserDefaultManager.nickname = nicknameTextField.text ?? UserDefaultManager.nickname
            UserDefaultManager.joinedDate = Date()
            UserDefaultManager.profileImage = selectedProfileImageNum
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let rootViewController = TabBarController()
            sceneDelegate?.window?.rootViewController = rootViewController
            sceneDelegate?.window?.makeKeyAndVisible()
        } else {
            UserDefaultManager.nickname = nicknameTextField.text ?? UserDefaultManager.nickname
            UserDefaultManager.profileImage = selectedProfileImageNum
            navigationController?.popViewController(animated: true)
        }
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

// 화면 전환 로직을 뷰모델에서 하는게 맞? Delegate등을 사용해서 
// 화면 전환을 담당하는 객체를 별도로? 개념만 알아두기
