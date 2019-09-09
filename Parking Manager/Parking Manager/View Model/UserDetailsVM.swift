//
//  UserDetailsVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 06/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation
import UIKit

class UserDetailsVM: BaseVM {
    
    var users: [User] = []
    let inputDetails = ["Email", "Name", "Phone", "Vehicle Type", "Vehicle No"]
    let vehicleTypes = ["Bike", "Car"]
    
    func addUserToDatabase(emailArg: String, name: String, phone: String, vehicleNumber: String, vehicleType: String, imageData: Data?) {
        let email = FirebaseManager.shared.getLoggedInUserEmail()
        let md5Data = Helper.MD5(string: email)
        let md5Hex = md5Data.map { String(format: "%02hhx", $0) }.joined()
        print(md5Hex)
        FirebaseManager.shared.uploadPhotoToStorage(name: name, imageData: imageData)
        let user = User(email: email, name: name, phone: phone, vehicleType: vehicleType, vehicleNumber: vehicleNumber, md5HashOfEmail: md5Hex)
        FirebaseManager.shared.addUser(user: user)
    }
    
    func getCurrentUsersEmail() -> String {
        return FirebaseManager.shared.getLoggedInUserEmail()
    }
}
