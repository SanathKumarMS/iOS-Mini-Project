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
//        addToRealm(email: email, name: name, phone: phone, vehicleNumber: vehicleNumber, vehicleType: vehicleType, imageData: imageData)
        let userProfile = UserProfile()
        userProfile.email = email
        userProfile.name = name
        userProfile.phone = phone
        userProfile.vehicleNumber = vehicleNumber
        userProfile.vehicleType = vehicleType
        let filename = md5Hex
        if storeImageInDocuments(fileName: filename, imageData: imageData) == true {
            userProfile.profilePictureName = md5Hex
        } else {
            userProfile.profilePictureName = nil
        }
        
        if RealmManager.shared.fetchDetailsForUser(email: email) != nil {
            RealmManager.shared.updateDetailsForUser(userProfile: userProfile)
        } else {
            RealmManager.shared.add(userProfile: userProfile)
        }
//        RealmManager.shared.fetchAll()
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
    
//    func addToRealm(email: String, name: String, phone: String, vehicleNumber: String, vehicleType: String, imageData: Data?) {
//        
//        let userProfile = UserProfile()
//        userProfile.email = email
//        userProfile.name = name
//        userProfile.phone = phone
//        userProfile.vehicleNumber = vehicleNumber
//        userProfile.vehicleType = vehicleType
//        userProfile.profilePicture = imageData
//        
//        let realm: Realm
//        do {
//            realm = try Realm()
//            try realm.write {
//                realm.add(userProfile)
//            }
//            let userProfile = realm.objects(UserProfile.self)
//            print(userProfile)
//            try realm.write {
//                realm.deleteAll()
//            }
//        } catch let error {
//            print(error)
//        }
//    }
    
    func storeImageInDocuments(fileName: String, imageData: Data?) -> Bool {
        guard let imageData = imageData else {
            return false
        }
        
        do {
            let documentsDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsDirectoryURL.appendingPathComponent(fileName).appendingPathExtension(Constants.jpgExtension)
            try imageData.write(to: fileURL)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func signOut() {
        FirebaseManager.shared.signOut()
    }
}
