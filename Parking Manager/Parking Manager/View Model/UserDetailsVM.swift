//
//  UserDetailsVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 06/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation
import UIKit

enum VehicleTypes: String, CaseIterable {
    case bike = "Bike"
    case car = "Car"
}

enum UserDetailsToDisplay: Int, CaseIterable {
    case email
    case name
    case phone
    case vehicleType
    case vehicleNumber
    
    var title: String {
        switch self {
        case .email:
            return "Email"
        case .name:
            return "Name"
        case .phone:
            return "Phone"
        case .vehicleType:
            return "Vehicle Type"
        case .vehicleNumber:
            return "Vehicle No"
        }
    }
}

enum ViewControllerType: String {
    case userDetails
    case addTab
}

class UserDetailsVM: BaseVM {
    
    func getCurrentUsersEmail() -> String {
        return FirebaseManager.shared.getLoggedInUserEmail()
    }
}
