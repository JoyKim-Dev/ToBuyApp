//
//  VC + Extension.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit
import Toast

extension UIViewController {
    
    func setNavTitle(_ navTitle: String) {
        navigationItem.title = navTitle
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    func sceneDelegateRootViewTransition(toVC: UIViewController ) {
         let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
         let sceneDelegate = windowScene?.delegate as? SceneDelegate
         sceneDelegate?.window?.rootViewController = toVC
         sceneDelegate?.window?.makeKeyAndVisible()
     }
    
    func viewControllerPushTransition(toVC: UIViewController) {
        navigationController?.pushViewController(toVC, animated: true)
    }
    
    func showToast() {
        self.view.makeToast("🐥 아직 준비중이에요", duration: 1.5)
    }
}

