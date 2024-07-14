//
//  ProfileNicknameCoordinator.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/14/24.
//

import UIKit

@objc protocol ProfileNicknameCoordinator: AnyObject {
    @objc optional func pushToProfileNickname()
    @objc optional func popcurrentView()
}

extension ProfileNicknameCoordinator {
    
    func pushToProfileNickname(_ navigationcontroller: UINavigationController) {
        
        let vc = ProfileNicknameVC()
        navigationcontroller.pushViewController(vc, animated: true)
    }
    
    func popcurrentView(_ navigationcontroller: UINavigationController) {
        
        navigationcontroller.popViewController(animated: true)
    }
}
