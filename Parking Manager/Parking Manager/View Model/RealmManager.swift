//
//  RealmManager.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 23/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static var shared = RealmManager()
    
    let realm: Realm?
    
    private init() {
        do {
            let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { (migration, oldSchemaVersion) in
                if oldSchemaVersion < 1 {
                    
                }
            })
            realm = try Realm(configuration: config)
        } catch let error {
            realm = nil
            print(error)
        }
    }
    
    func add(userProfile: UserProfile) {
        do {
            try realm?.write {
                realm?.deleteAll()
                realm?.add(userProfile)
            }
        } catch let error {
            print(error)
            return
        }
    }
    
    func fetchDetailsForUser(email: String) -> UserProfile? {
        return realm?.objects(UserProfile.self).filter("email == '\(email)'").first
    }
    
    func updateDetailsForUser(userProfile: UserProfile) {
        do {
            try realm?.write {
                realm?.add(userProfile, update: .modified)
            }
        } catch let error {
            print(error)
        }
    }
    
}
