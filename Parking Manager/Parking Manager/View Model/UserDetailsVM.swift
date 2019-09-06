//
//  UserDetailsVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 06/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation

class UserDetailsVM: BaseVM {
    
    var users: [User] = []
    
    func add(emailArg: String, name: String, phone: String, vehicleNumber: String, vehicleType: String) {
        let email = FirebaseManager.shared.getLoggedInUserEmail()
        let md5Data = Helper.MD5(string: email)
        let md5Hex = md5Data.map { String(format: "%02hhx", $0) }.joined()
        print(md5Hex)
        let user = User(email: email, name: name, phone: phone, vehicleType: vehicleType, vehicleNumber: vehicleNumber, md5HashOfEmail: md5Hex)
        FirebaseManager.shared.addUser(user: user)
    }
}
