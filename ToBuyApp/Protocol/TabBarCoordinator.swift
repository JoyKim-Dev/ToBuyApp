//
//  TabBarCoordinator.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/14/24.
//

import Foundation

import UIKit

@objc protocol TabbarCoordinator: AnyObject {
    @objc optional func pushToTabbarHome()
    @objc optional func popcurrentPage()
}

extension TabbarCoordinator {
    
    func pushToTabbarHome(_ navigationcontroller: UINavigationController) {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let rootViewController = TabBarController()
        sceneDelegate?.window?.rootViewController = rootViewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func popcurrentPage(_ navigationcontroller: UINavigationController) {
        
        navigationcontroller.popViewController(animated: true)
    }
}
