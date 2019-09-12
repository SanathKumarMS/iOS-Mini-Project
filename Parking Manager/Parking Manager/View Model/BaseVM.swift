//
//  BaseVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 04/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation

class BaseVM {
    
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
    
    func signOut() {
        FirebaseManager.shared.signOut()
    }
}
