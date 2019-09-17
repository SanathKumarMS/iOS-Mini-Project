//
//  ChatTabVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 14/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class ChatTabVC: BaseVC {
    
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var recipientPhoneNumber: String? {
        didSet {
            navigationItem.title = self.recipientPhoneNumber
        }
    }
    var recipientEmail: String = ""
    
    private var viewModel = ChatTabVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewModel.getChatMessages(chatPartner: recipientEmail, completionHandler: { [weak self] (message) in
            guard message != nil else { return }
            
            self?.collectionView.reloadData()
            self?.scrollToBottom()
//            self?.collectionView.collectionViewLayout.invalidateLayout()
        })

        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
    
    @IBAction private func sendMessageButton(_ sender: Any) {
        guard let messageText = messageTextField.text else { return }
        viewModel.addMessageToDatabase(text: messageText, chatPartner: recipientEmail)
        messageTextField.text = ""
    }
    
    func scrollToBottom() {
        collectionView.scrollToItem(at: IndexPath(item: viewModel.messages.count - 1, section: 0), at: .bottom, animated: false)
    }
}

extension ChatTabVC: UICollectionViewDelegate {

}

extension ChatTabVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ChatCVCell.self), for: indexPath) as? ChatCVCell else { return ChatCVCell() }
        
        if viewModel.messages[indexPath.row].fromID == viewModel.toID {
            cell.messageLabel.textAlignment = .left
        }
        cell.backgroundColor = .gray
        cell.messageLabel.text = viewModel.messages[indexPath.row].text
        return cell
    }
    
}

extension ChatTabVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//        var height: CGFloat = 200
//        let text = viewModel.messages[indexPath.row].text
//        height = estimateHeightForText(text: text).height + 20
//        return CGSize(width: view.frame.width, height: height)
//        if let cell = collectionView.cellForItem(at: indexPath) as? ChatCVCell {
//            return cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        }
        return CGSize(width: view.frame.width, height: 150)
//        return UICollectionViewFlowLayout.automaticSize
    }
}
