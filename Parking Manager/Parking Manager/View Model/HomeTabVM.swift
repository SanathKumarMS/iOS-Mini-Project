//
//  HomeTabVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 11/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

enum UserDetails: String, CaseIterable {
    case email
    case name
    case phone
    case vehicleType
    case vehicleNumber
    case md5HashOfEmail
    case profilePicturePath
}

class HomeTabVM: BaseVM {
    
    var userData: [String: String] = [:]
    
    //Get Details of the Logged in User 
    func getLoggedInUserDetails(completionHandler: @escaping (Bool, UIImage?) -> Void) {
        let email = FirebaseManager.shared.getLoggedInUserEmail()
        let md5Data = Helper.MD5(string: email)
        let md5Hex = md5Data.map { String(format: "%02hhx", $0) }.joined()
        //Realm part
        if let userProfile = RealmManager.shared.fetchDetailsForUser(email: email) {
            userData[UserDetails.email.rawValue] = email
            userData[UserDetails.name.rawValue] = userProfile.name
            userData[UserDetails.phone.rawValue] = userProfile.phone
            userData[UserDetails.vehicleType.rawValue] = userProfile.vehicleType
            userData[UserDetails.vehicleNumber.rawValue] = userProfile.vehicleNumber
            if let fileName = userProfile.profilePictureName {
                if let image = getImageFromDocuments(fileName: fileName) {
                    completionHandler(true, image)
                } else {
                    completionHandler(true, nil)
                }
            }
            return
        }
        FirebaseManager.shared.getUserDetails(key: md5Hex, completionHandler: { [weak self] (details) in
            guard let details = details else {
                completionHandler(false, nil)
                return
            }
            self?.userData = details
            FirebaseManager.shared.downloadImageFromStorage(name: md5Hex, completionHandler: { (data, error) in
                if error != nil {
                    completionHandler(true, nil)
                    return
                }
                guard let data = data else {
                    completionHandler(false, nil)
                    return
                }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completionHandler(true, image)
                }
            })
        })
    }
    
    func removeAllImagesFromDocuments() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for fileURL in fileURLs {
                if fileURL.pathExtension == ".jpg" || fileURL.pathExtension == "jpg" || fileURL.pathExtension == "png" {
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getCurrentUsersEmail() -> String {
        return FirebaseManager.shared.getLoggedInUserEmail()
    }
}
