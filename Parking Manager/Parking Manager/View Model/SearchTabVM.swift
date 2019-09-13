//
//  SearchTabVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 12/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

enum SegmentTypes: Int, CaseIterable {
    case Bike
    case Car
    
    var title: String {
        switch self {
        case .Bike:
            return "Bike"
        case .Car:
            return "Car"
        }
    }
}

class SearchTabVM: BaseVM {
    
    var allUsers: [User] = []

    func getAllUsersData(completionHandler: @escaping GetAllUserDataCompletionHandler) {
        FirebaseManager.shared.getAllUsersDetails(completionHandler: { [weak self] (details) in
            guard let details = details else {
                completionHandler(nil)
                return
            }
            
            for item in details {
                let hashedKey = item.key
                guard let dict = item.value as? [String: String] else {
                    completionHandler(nil)
                    return
                }
                
                let email = dict[UserDetailsFromStructure.email.rawValue]
                let name = dict[UserDetailsFromStructure.name.rawValue]
                let phone = dict[UserDetailsFromStructure.phone.rawValue]
                let vehicleNumber = dict[UserDetailsFromStructure.vehicleNumber.rawValue]
                let vehicleType = dict[UserDetailsFromStructure.vehicleType.rawValue]
                let profilePicturePath = dict[UserDetailsFromStructure.profilePicturePath.rawValue]
                
                let user = User(email: email ?? EmptyString, name: name ?? EmptyString, phone: phone ?? EmptyString, vehicleType: vehicleType ?? EmptyString, vehicleNumber: vehicleNumber ?? EmptyString, md5HashOfEmail: hashedKey, profilePicturePath: profilePicturePath ?? EmptyString)
                self?.allUsers.append(user)
            }
            DispatchQueue.main.async {
               completionHandler(self?.allUsers)
            }
        })
    }
}
