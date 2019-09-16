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
        dict[UserDetails.email.rawValue] = email
        dict[UserDetails.name.rawValue] = name
        dict[UserDetails.phone.rawValue] = phone
        dict[UserDetails.vehicleType.rawValue] = vehicleType
        dict[UserDetails.vehicleNumber.rawValue] = vehicleNumber
        dict[UserDetails.profilePicturePath.rawValue] = profilePicturePath
        return dict
    }
}
