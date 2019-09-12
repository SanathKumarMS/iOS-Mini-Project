//
//  User.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 06/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation

struct User {
    var email: String
    var name: String
    var phone: String
    var vehicleType: String
    var vehicleNumber: String
    var md5HashOfEmail: String
    var profilePicturePath: String
    
    func convertToJSON() -> [String: String] {
        var dict = [String: String]()
        dict[UserDetailsFromStructure.email.rawValue] = email
        dict[UserDetailsFromStructure.name.rawValue] = name
        dict[UserDetailsFromStructure.phone.rawValue] = phone
        dict[UserDetailsFromStructure.vehicleType.rawValue] = vehicleType
        dict[UserDetailsFromStructure.vehicleNumber.rawValue] = vehicleNumber
        dict[UserDetailsFromStructure.profilePicturePath.rawValue] = profilePicturePath
        return dict
    }
}
