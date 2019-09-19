//
//  ChatListVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 19/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class ChatListVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel = ChatListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getChatList { [weak self] (success) in
            if success == true {
                self?.tableView.reloadData()
            }
        }
        tableView.tableFooterView = UIView()
//        viewModel.getChatPartnerImages { [weak self] (success) in
//            if success == true {
//                self?.tableView.reloadData()
//            }
//        }
    }
}

// MARK: - UITableViewDelegate

extension ChatListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate

extension ChatListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatListTVCell.self), for: indexPath) as? ChatListTVCell else { return ChatListTVCell() }
        
        cell.nameLabel.text = viewModel.userData[indexPath.row].name
        viewModel.filterMessages(toID: viewModel.userData[indexPath.row].md5HashOfEmail)
        cell.lastMessageLabel.text = viewModel.filteredMessages[0].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chatTabVC = storyboard?.instantiateViewController(withIdentifier: String(describing: ChatTabVC.self)) as? ChatTabVC else { return }
        
        chatTabVC.recipientEmail = viewModel.userData[indexPath.row].email
        chatTabVC.recipientName = viewModel.userData[indexPath.row].name
        chatTabVC.recipientPhoneNumber = viewModel.userData[indexPath.row].phone
        
        navigationController?.pushViewController(chatTabVC, animated: true)
    }
    
}
