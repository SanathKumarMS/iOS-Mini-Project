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
    
        viewModel.getChatMessages(completionHandler: { [weak self] (message) in
            guard let message = message else { return }
            
            self?.messages.append(message)
            print(self?.messages)
            self?.collectionView.reloadData()
        })
    }
    
    @IBAction private func sendMessageButton(_ sender: Any) {
        guard let messageText = messageLabel.text else { return }
        viewModel.addMessageToDatabase(text: messageText)
        messageLabel.text = ""
    }
}

extension ChatTabVC: UICollectionViewDelegate {

}

extension ChatTabVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ChatCVCell.self), for: indexPath) as? ChatCVCell else { return ChatCVCell() }
        
        cell.backgroundColor = .red
        cell.messageLabel.text = messages[indexPath.row].text
        return cell
    }
    
}

extension ChatTabVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
}
