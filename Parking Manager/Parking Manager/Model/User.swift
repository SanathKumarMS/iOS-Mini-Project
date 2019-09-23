//
//  User.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 06/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation
import RealmSwift

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

class ProfileDetails: Object {
    @objc dynamic var email: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var vehicleType: String = ""
    @objc dynamic var vehicleNumber: String = ""
    @objc dynamic var md5HashOfEmail: String = ""
    @objc dynamic var profilePicture: Data?
    
    override static func primaryKey() -> String? {
        return "email"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["md5HashOfEmail"]
    }

}
