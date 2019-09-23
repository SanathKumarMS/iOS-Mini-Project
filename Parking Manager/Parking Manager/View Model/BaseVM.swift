//
//  BaseVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 04/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation
import RealmSwift

class BaseVM {
    
    var users: [User] = []
    
    func addUserToDatabase(email: String, name: String, phone: String, vehicleNumber: String, vehicleType: String, imageData: Data?, completionHandler: @escaping ErrorHandler) {
        let md5Data = Helper.MD5(string: email)
        let md5Hex = md5Data.map { String(format: "%02hhx", $0) }.joined()
        //Realm part
        addToRealm(email: email, name: name, phone: phone, vehicleNumber: vehicleNumber, vehicleType: vehicleType, imageData: imageData)
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
    
    func addToRealm(email: String, name: String, phone: String, vehicleNumber: String, vehicleType: String, imageData: Data?) {
        
        let profileDetails = ProfileDetails()
        profileDetails.email = email
        profileDetails.name = name
        profileDetails.phone = phone
        profileDetails.vehicleNumber = vehicleNumber
        profileDetails.vehicleType = vehicleType
        profileDetails.profilePicture = imageData
        
        let realm: Realm
        do {
            realm = try Realm()
            try realm.write {
                realm.add(profileDetails)
            }
            let profileDetails = realm.objects(ProfileDetails.self)
            print(profileDetails)
            try realm.write {
                realm.deleteAll()
            }
        } catch let error as Error {
            print(error)
        }
        
    }
    
    func signOut() {
        FirebaseManager.shared.signOut()
    }
}
