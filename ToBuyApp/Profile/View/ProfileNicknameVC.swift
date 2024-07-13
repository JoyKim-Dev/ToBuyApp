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



final class ProfileNicknameVC: BaseViewController {
    
    let viewModel = ProfileNicknameViewModel()

    private lazy var profileImageView = ProfileImageView(profileImageNum: selectedProfileImageNum, cameraBtnMode: .isShowing, isSelected: true)
    private lazy var nicknameTextField = NicknameTextField(placeholder: Placeholder.nicknameTextField.value)
    private let lineView = LineView()
    private lazy var nicknameStatusLabel = NicknameStatusLabel(text: textIsValid)
    private let submitBtn = OnboardingButton(btnTitle: "완료")
    
    private lazy var selectedProfileImageNum: Int = 0
    private var textIsValid = TextFieldValidation.valid.value
   
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // viewModel에서 선택한 이미지 숫자 받아오기
        profileImageView.profileImage.image = UIImage(named: "catProfile_\(selectedProfileImageNum)")
        //  textFieldDidChange(nicknameTextField)
    }
    
    func bindData() {
        
        viewModel.outputNavigationTitle.bind {  title in
            self.setNavTitle(title)
        }
        viewModel.outputNickTextFieldText.bind { nickname in
            self.nicknameTextField.text = nickname
        }
        viewModel.outputImage.bind { imageNum in
            self.selectedProfileImageNum = imageNum
            print(imageNum)
                }
        viewModel.outputNicknameStatus.bind {  status in
                    self.nicknameStatusLabel.text = status
                    self.textIsValid = status
                }
        viewModel.outputSubmitBtn.bind { status in
                    self.submitBtn.isEnabled = status
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
        setNavTitle(viewModel.outputNavigationTitle.value)
        
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
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func textFieldDidChange(_ sender: UITextField) {
        viewModel.inputNickname.value = sender.text
        viewModel.nicknameValidation()
    }
    // 완료 시 동작 trigger : 1. 버튼 addtarget 2. 텍스트필드 return (버튼 함수 실행 - 재활용) 3. UserDefault 저장(닉네임. 가입일.이미지)
    @objc func submitBtnTapped() {
        viewModel.submitValidation(currentVC: self)
    }
    
    @objc func backBtnTapped() {
        navigationController?.popViewController(animated: true)
        viewModel.inputBackBtnTapped.value = ()
        viewModel.popViewController(currentVC: self)
        
        }
}
extension ProfileNicknameVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        if nicknameStatusLabel.text != textIsValid {
            return false
        } else {
            submitBtnTapped()
            return true
        }
    }
}


// 화면 전환 로직을 뷰모델에서 하는게 맞? Delegate등을 사용해서 
// 화면 전환을 담당하는 객체를 별도로? 개념만 알아두기
