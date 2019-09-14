//
//  ChatTabVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 14/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class ChatTabVC: BaseVC {
    
    @IBOutlet private weak var messageLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat"
    }
    
    @IBAction private func sendMessageButton(_ sender: Any) {
        print(messageLabel.text)
    }
}
