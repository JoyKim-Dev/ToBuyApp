//
//  VC + Extension.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

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
}

