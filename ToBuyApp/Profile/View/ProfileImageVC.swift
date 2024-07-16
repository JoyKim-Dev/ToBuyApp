//
//  ProfileImageVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

protocol ImageDelegate : AnyObject {
    func imageDataFromImageSettingpage(int:Int)
}

final class ProfileImageVC: BaseViewController {
    
    let viewModel = ProfileImageViewModel()
    
    private lazy var selectedImageView = ProfileImageView(profileImageNum: viewModel.imageDataFromPreviousPage , cameraBtnMode: .isShowing, isSelected: true)
    private lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ProfileImageVC.collectionViewLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
 
    override func configHierarchy() {
        view.addSubview(selectedImageView)
        view.addSubview(profileCollectionView)
    }
    override func configLayout() {
        selectedImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.width.equalTo(125)
        }
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    override func configView() {
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
        let navBackBtn = UIBarButtonItem(image: Icon.chevronLeft, style: .plain, target: self, action: #selector(navBackBtnTapped))
        navigationItem.leftBarButtonItem = navBackBtn
    }
    
    func bindData() {
        viewModel.outputNavigationTitle.bind { title in
            self.setNavTitle(title)
        }
    }
    
   static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()

        let sectionSpacing:CGFloat = 2
        let cellSpacing:CGFloat = 2

        let width = UIScreen.main.bounds.width - (sectionSpacing * 2) - (cellSpacing * 3)
        layout.itemSize = CGSize(width: width/5, height: width/5)
        layout.scrollDirection = .vertical

        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    @objc func navBackBtnTapped() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileImageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        let data = indexPath.item
        cell.configUI(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageView.changeImage(profileNum: indexPath.item)
        viewModel.imageForDelegate?.imageDataFromImageSettingpage(int: indexPath.item)
        
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? ProfileImageCollectionViewCell {
                ProfileImageStyle.unSelected.configProfileImageUI(to: cell.imageView.profileImage)
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell {
            ProfileImageStyle.isSelected.configProfileImageUI(to: cell.imageView.profileImage)
        }
    }
}

