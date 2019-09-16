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
    @IBOutlet weak var collectionView: UICollectionView!
    var recipientPhoneNumber: String? {
        didSet {
            navigationItem.title = self.recipientPhoneNumber
        }
    }
    var recipientEmail: String = ""
    var messages = [Message]()
    private var viewModel = ChatTabVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewModel.getChatMessages()
    }
    
    @IBAction private func sendMessageButton(_ sender: Any) {
        guard let messageText = messageLabel.text else { return }
        viewModel.addMessageToDatabase(text: messageText)
    }
}

extension ChatTabVC: UICollectionViewDelegate {
    
}

extension ChatTabVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ChatCVCell.self), for: indexPath) as? ChatCVCell else { return ChatCVCell() }
        
        return cell
    }
    
    
}
