//
//  ProfileImageCoordinator.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/14/24.
//

import UIKit

@objc protocol ProfileImageCoordinator: AnyObject {
    @objc optional func pushToImageSetting()
    @objc optional func popImageSetting()
}

extension ProfileImageCoordinator {
    
    func pushToImageSetting(_ navigationcontroller: UINavigationController) {
        
        let vc = ProfileImageVC()
        navigationcontroller.pushViewController(vc, animated: true)
    }
    
    func popImageSetting(_ navigationcontroller: UINavigationController) {
        
        navigationcontroller.popViewController(animated: true)
    }
}
