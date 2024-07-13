//
//  NavBackBtn.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/11/24.
//

import Foundation
import UIKit

class NavBackBtn:UIBarButtonItem {
    
    var popVC: UIViewController?
    
    override init() {
        super.init()
        image = Icon.chevronLeft
        style = .plain
        tintColor = .black
    }
    init(currentVC: UIViewController) {
         super.init()
         popVC = currentVC
         image = Icon.chevronLeft
         style = .plain
         target = self
         action = #selector(self.leftBarBtnTapped)
         tintColor = .black
     }
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     @objc private func leftBarBtnTapped() {
            popVC?.navigationController?.popViewController(animated: true)
     }
 }
