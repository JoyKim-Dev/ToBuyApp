//
//  OnboardingVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

import SnapKit

final class OnboardingVC: BaseViewController {
    private let appTitleLabel = AppTitleLabel()
    private let nameLabel = UILabel()
    private let appMainImage = UIImageView()
    private var appStartBtn = OnboardingButton(btnTitle: "시작하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
        override func configHierarchy() {
            view.addSubview(appTitleLabel)
            view.addSubview(appMainImage)
            view.addSubview(appStartBtn)
            view.addSubview(nameLabel)
        }
        
    override func configLayout() {
            appTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
                make.centerX.equalTo(view)
            }
            
            appMainImage.snp.makeConstraints { make in
                make.centerY.equalTo(view)
                make.height.equalTo(view).multipliedBy(0.3)
                make.horizontalEdges.equalToSuperview().inset(10)
            }
            
            appStartBtn.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
                make.centerX.equalTo(view)
                make.height.equalTo(40)
                make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            }
            nameLabel.snp.makeConstraints { make in
                make.centerX.equalTo(view)
                make.top.equalTo(appMainImage.snp.bottom).offset(30)
            }
        }
        
        func configUI() {
            view.backgroundColor = UIColor.appTitle
            appMainImage.image = Image.mainImage
            appMainImage.contentMode = .scaleAspectFill
            appStartBtn.addTarget(self, action: #selector(startBtnTapped), for: .touchUpInside)
    }
}

extension OnboardingVC {
    
    @objc func startBtnTapped() {
       
        let vc = ProfileNicknameVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

