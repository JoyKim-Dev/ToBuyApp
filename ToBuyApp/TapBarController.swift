//
//  TapBarController.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/10/24.
//

import UIKit

 class TabBarController: UITabBarController {
  
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = Color.orange
        tabBar.unselectedItemTintColor = Color.darkGray
        
        let shoppingBagVC = UINavigationController(rootViewController: ShoppingBagMainVC())
        shoppingBagVC.tabBarItem = UITabBarItem(title: "찜", image: Icon.likeUnSelected, tag: 0)
        
       let  searchVC =  UINavigationController(rootViewController: SearchMainVC())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: Icon.search, tag: 1)
        
        let profileVC = UINavigationController(rootViewController: ProfileMainVC())
        profileVC.tabBarItem = UITabBarItem(title: "설정", image: Icon.person, tag: 2)
        
        

        setViewControllers([shoppingBagVC, searchVC, profileVC], animated: true)
    }
}
