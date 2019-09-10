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
    
    func convertToJSON() -> [String: String] {
        var dict = [String: String]()
        dict["email"] = email
        dict["name"] = name
        dict["phone"] = phone
        dict["vehicleType"] = vehicleType
        dict["vehicleNumber"] = vehicleNumber
        return dict
    }
}
