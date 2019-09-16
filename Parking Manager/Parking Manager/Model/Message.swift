//
//  Message.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 16/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation

struct Message {
    var fromID: String
    var toID: String
    var timestamp: String
    var text: String
    
    func convertToDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict[MessageDetails.fromID.rawValue] = fromID
        dict[MessageDetails.toID.rawValue] = toID
        dict[MessageDetails.timestamp.rawValue] = timestamp
        dict[MessageDetails.text.rawValue] = text
        return dict
    }
}

enum MessageDetails: String {
    case fromID
    case toID
    case timestamp
    case text
}
