//
//  ProfileImageVC.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

final class ProfileImageVC: BaseViewController {
    
    private lazy var selectedImageView = ProfileImageView(profileImageNum: imageDataFromPreviousPage , cameraBtnMode: .isShowing, isSelected: true)
//    private lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ProfileImageSettingVC.collectionViewLayout())
    private lazy var selectedImage = UIImage()
     var imageDataFromPreviousPage:Int = 0
     var selectedIndexPath: IndexPath?
    
}
