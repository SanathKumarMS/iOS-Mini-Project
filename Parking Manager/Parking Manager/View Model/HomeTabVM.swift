//
//  HomeTabVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 11/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class HomeTabVM: BaseVM {
    
    var currentUser: User?

    func getLoggedInUserDetails() {
        let email = FirebaseManager.shared.getLoggedInUserEmail()
        let md5Data = Helper.MD5(string: email)
        let md5Hex = md5Data.map { String(format: "%02hhx", $0) }.joined()
        FirebaseManager.shared.getUserDetails(key: md5Hex, completionHandler: { (user) in
            guard let user = user else {
                return
            }
            self.currentUser = user
        })
    }
}
