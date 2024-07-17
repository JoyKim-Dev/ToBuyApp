//
//  AlertManager.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/15/24.
//
import UIKit

final class AlertManager {
    
    static func showAlert(viewController: UIViewController, title: String, message: String, ok: String, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: ok, style: .default) { _ in
            completionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
    
    
}
