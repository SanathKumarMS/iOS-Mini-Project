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
    @IBOutlet private weak var tableView: UITableView!
    var recipientPhoneNumber: String = ""
    var recipientEmail: String = ""
    var recipientName: String? {
        didSet {
            navigationItem.title = self.recipientName
        }
    }
    
    private var viewModel = ChatTabVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.estimatedRowHeight = 100
        viewModel.getChatMessages(chatPartner: recipientEmail, completionHandler: { [weak self] (message) in
            guard message != nil else { return }
            
            self?.tableView.reloadData()
            self?.scrollToBottom()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction private func sendMessageButton(_ sender: Any) {
        guard let messageText = messageTextField.text else { return }
        if messageText.isEmpty {
            return
        }
        viewModel.addMessageToDatabase(text: messageText, chatPartner: recipientEmail)
        messageTextField.text = ""
    }
    
    func scrollToBottom() {
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
}

// MARK: - UITableViewDelegate

extension ChatTabVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UICollectionViewDataSource

extension ChatTabVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatTabTVCell.self), for: indexPath) as? ChatTabTVCell else { return ChatTabTVCell() }
        
        if viewModel.messages[indexPath.row].fromID == viewModel.toID {
            cell.bubbleVIewTrailingConstraint.constant = cell.bounds.width * 0.25
            cell.bubbleViewLeadingConstraint.constant = 10
            cell.messageLabel.textAlignment = .left
        } else {
            cell.bubbleViewLeadingConstraint.constant = cell.bounds.width * 0.25
            cell.bubbleVIewTrailingConstraint.constant = 10
            cell.messageLabel.textAlignment = .right
        }
        cell.messageLabel.text = viewModel.messages[indexPath.row].text
        return cell
    }
}

extension ChatTabVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
