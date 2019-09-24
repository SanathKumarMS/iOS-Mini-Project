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
    @IBOutlet weak var sendMessageViewBottomConstraint: NSLayoutConstraint!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    @IBAction private func sendMessageButton(_ sender: Any) {
        guard let messageText = messageTextField.text else { return }
        if messageText.isEmpty {
            return
        }
        viewModel.addMessageToDatabase(text: messageText, chatPartner: recipientEmail)
        messageTextField.text = ""
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if sendMessageViewBottomConstraint.constant == 0 {
                let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
                sendMessageViewBottomConstraint.constant = keyboardFrame.height
                UIView.animate(withDuration: keyboardDuration) {
                    self.view.layoutIfNeeded()
                }
                
            }
        }
    }
    
    @objc func handleKeyboardWillHide(notification: Notification) {
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        sendMessageViewBottomConstraint.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollToBottom() {
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
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
