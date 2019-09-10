//
//  BaseVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 04/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation

class BaseVM {
    
    func signOut() {
        FirebaseManager.shared.signOut()
    }
}
