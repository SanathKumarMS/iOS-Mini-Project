//
//  ChatTabVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 14/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class ChatTabVM: BaseVM {
    
    var fromID: String = ""
    var toID: String = ""
    var messages = [Message]()
    
    func addMessageToDatabase(text: String, chatPartner: String) {
        let fromID = md5Hash(email: FirebaseManager.shared.getLoggedInUserEmail())
        let toID = md5Hash(email: chatPartner)
        let dateString = getTimestamp()
        let message = Message(fromID: fromID, toID: toID, timestamp: dateString, text: text)
        FirebaseManager.shared.addMessage(message: message)
    }
    
    func getTimestamp() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    func md5Hash(email: String) -> String {
        let md5Data = Helper.MD5(string: email)
        return md5Data.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func getChatMessages(chatPartner: String, completionHandler: @escaping GetMessageHandler) {
        let fromID = md5Hash(email: FirebaseManager.shared.getLoggedInUserEmail())
        let toID = md5Hash(email: chatPartner)
        self.fromID = fromID
        self.toID = toID
        
        FirebaseManager.shared.getChat(fromID: fromID, toID: toID, completionHandler: { [weak self] (message) in
            guard let message = message else {
                return
            }
            
            self?.messages.append(message)
            DispatchQueue.main.async {
                completionHandler(message)
            }
        })
    }
}
