//
//  UserDetailsVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 06/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation
import UIKit

enum VehicleTypes: String, CaseIterable {
    case bike = "Bike"
    case car = "Car"
}

enum UserDetails: Int, CaseIterable {
    case email
    case name
    case phone
    case vehicleType
    case vehicleNumber
    
    var title: String {
        switch self {
        case .email:
            return "Email"
        case .name:
            return "Name"
        case .phone:
            return "Phone"
        case .vehicleType:
            return "Vehicle Type"
        case .vehicleNumber:
            return "Vehicle No"
        }
    }
}

class UserDetailsVM: BaseVM {
    
    var users: [User] = []
    
    func addUserToDatabase(email: String, name: String, phone: String, vehicleNumber: String, vehicleType: String, imageData: Data?, completionHandler: @escaping ErrorHandler) {
        let md5Data = Helper.MD5(string: email)
        let md5Hex = md5Data.map { String(format: "%02hhx", $0) }.joined()
        if let imageData = imageData {
            FirebaseManager.shared.uploadImageToStorage(name: md5Hex, imageData: imageData, completionHandler: { (downloadURL, error) in
                guard error == nil else {
                    completionHandler(error)
                    return
                }
                let path = downloadURL?.absoluteString
                let user = User(email: email, name: name, phone: phone, vehicleType: vehicleType, vehicleNumber: vehicleNumber, md5HashOfEmail: md5Hex, profilePicturePath: path ?? "")
                FirebaseManager.shared.addUser(user: user)
                completionHandler(nil)
            })
        } else {
            FirebaseManager.shared.deleteImageFromStorage(name: md5Hex, completionHandler: { (error) in
                guard error == nil  else {
                    completionHandler(error)
                    return
                }
            })
            let user = User(email: email, name: name, phone: phone, vehicleType: vehicleType, vehicleNumber: vehicleNumber, md5HashOfEmail: md5Hex, profilePicturePath: "")
            FirebaseManager.shared.addUser(user: user)
            completionHandler(nil)
        }
    }
    
    func getCurrentUsersEmail() -> String {
        return FirebaseManager.shared.getLoggedInUserEmail()
    }
}
