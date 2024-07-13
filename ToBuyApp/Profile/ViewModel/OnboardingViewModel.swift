//
//  OnboardingViewModel.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/13/24.
//

import UIKit

final class OnboardingViewModel {
    
    //startBtn 눌리면 ProfileNickname VC로 이동
    // 화면 전환 로진 전체 viewModel에서 관장
    
    func toNextVC(fromVC: UIViewController, nextVC: UIViewController) {
        print(#function)
        let fromVC = fromVC
        let nextVC = nextVC
        fromVC.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
