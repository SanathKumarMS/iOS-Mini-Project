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
                
                let email = dict[UserDetails.email.rawValue]
                let name = dict[UserDetails.name.rawValue]
                let phone = dict[UserDetails.phone.rawValue]
                let vehicleNumber = dict[UserDetails.vehicleNumber.rawValue]
                let vehicleType = dict[UserDetails.vehicleType.rawValue]
                let profilePicturePath = dict[UserDetails.profilePicturePath.rawValue]
                
                let user = User(email: email ?? "", name: name ?? "", phone: phone ?? "", vehicleType: vehicleType ?? "", vehicleNumber: vehicleNumber ?? "", md5HashOfEmail: hashedKey, profilePicturePath: profilePicturePath ?? "")
                self?.allUsers.append(user)
            }
            DispatchQueue.main.async {
               completionHandler(self?.allUsers)
            }
        })
    }
}
