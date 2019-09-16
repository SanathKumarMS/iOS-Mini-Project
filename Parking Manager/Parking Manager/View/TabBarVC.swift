//
//  TabBarVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 11/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navVC = viewController as? UINavigationController else { return }
        guard let addTabVC = navVC.viewControllers.first as? UserDetailsVC else { return }
        
        addTabVC.currentVCType = .addTab
    }
}
