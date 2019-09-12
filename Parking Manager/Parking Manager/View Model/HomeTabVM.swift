//
//  HomeTabVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 11/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

enum UserDetailsFromStructure: String, CaseIterable {
    case email
    case name
    case phone
    case vehicleType
    case vehicleNumber
    case md5HashOfEmail
    case profilePicturePath
}

class HomeTabVM: BaseVM {
    
    var dict: [String: String] = [:]
    
    //Get Details of the Logged in User 
    func getLoggedInUserDetails(completionHandler: @escaping (Bool, UIImage?) -> Void) {
        let email = FirebaseManager.shared.getLoggedInUserEmail()
        let md5Data = Helper.MD5(string: email)
        let md5Hex = md5Data.map { String(format: "%02hhx", $0) }.joined()
        FirebaseManager.shared.getUserDetails(key: md5Hex, completionHandler: { [weak self] (details) in
            guard let details = details else {
                completionHandler(false, nil)
                return
            }
            self?.dict = details
            FirebaseManager.shared.downloadImageFromStorage(name: md5Hex, completionHandler: { (data, error) in
                if let error = error {
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
    
    func getCurrentUsersEmail() -> String {
        return FirebaseManager.shared.getLoggedInUserEmail()
    }
}
