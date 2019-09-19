//
//  ChatListVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 19/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class ChatListVM: BaseVM {
    
    var allChatInteractions = [Message]()
    var chatPartnersInformation = [String: User]()
    var userData = [User]()
    var userImageData = [Data]()
    var fromID: String = ""
    var filteredMessages = [Message]()

    func getChatList(completionHandler: @escaping (Bool) -> Void) {
        let loggedInEmail = FirebaseManager.shared.getLoggedInUserEmail()
        fromID = Helper.md5Hash(email: loggedInEmail)
        FirebaseManager.shared.getAllChatInteractions(fromID: fromID) { [weak self] (message) in
            
            guard let message = message else {
                completionHandler(false)
                return
            }
            
            self?.allChatInteractions.append(message)
            let chatPartnerID = self?.fromID == message.fromID ? message.toID : message.fromID
            FirebaseManager.shared.getUserDetails(key: chatPartnerID, completionHandler: { (userDetails) in
                guard let userDetails = userDetails else {
                    completionHandler(false)
                    return
                }
                guard let email = userDetails[UserDetails.email.rawValue], let name = userDetails[UserDetails.name.rawValue], let phone = userDetails[UserDetails.phone.rawValue], let vehicleType = userDetails[UserDetails.vehicleType.rawValue], let vehicleNumber = userDetails[UserDetails.vehicleNumber.rawValue], let profilePicturePath = userDetails[UserDetails.profilePicturePath.rawValue]  else { return }
                
                let user = User(email: email, name: name, phone: phone, vehicleType: vehicleType, vehicleNumber: vehicleNumber, md5HashOfEmail: chatPartnerID, profilePicturePath: profilePicturePath)

                if self?.chatPartnersInformation[chatPartnerID] == nil {
                    self?.chatPartnersInformation[chatPartnerID] = user
                    self?.userData.append(user)
                    DispatchQueue.main.async {
                        completionHandler(true)
                    }
                }
                completionHandler(false)
            })
        }
    }
    
    func getChatPartnerImages(completionHandler: @escaping (Bool) -> Void) {
        for user in userData {
            FirebaseManager.shared.downloadImageFromStorage(name: user.md5HashOfEmail, completionHandler: { [weak self] (data, error) in
                if error != nil {
                    completionHandler(false)
                    return
                }
                guard let data = data else {
                    completionHandler(false)
                    return
                }
                self?.userImageData.append(data)
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            })
        }
        
    }
    
    func filterMessages(toID: String) {
        
        filteredMessages = allChatInteractions.filter { (message) -> Bool in
            (message.fromID == fromID && message.toID == toID) || (message.fromID == toID && message.toID == fromID)
        }
        filteredMessages.sort { (message1, message2) -> Bool in
            message1.timestamp >= message2.timestamp
        }
    }
}
