//
//  SearchTabVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 12/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class SearchTabVC: BaseVC {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel = SearchTabVM()
    
    private var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Search"
        setupUI()
        getAllUsersData()
    }
    
    @IBAction private func segmentIndexChanged() {
        searchBar.text = ""
        viewModel.filterDataForSegment(segmentType: SegmentTypes.allCases[segmentedControl.selectedSegmentIndex])
        tableView.reloadData()
        if tableView.numberOfSections > 0 && tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func setupUI() {
        searchBar.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.layer.borderWidth = 2
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    func getAllUsersData() {
        viewModel.getAllUsersData(completionHandler: { [weak self] (userData) in
            guard userData != nil else { return }
            
            self?.viewModel.filterDataForSegment(segmentType: SegmentTypes.Bike)
            self?.tableView.reloadData()
        })
    }
    
    func openMailApp(emailAddress: String) {
        if let mailURL = URL(string: "mailto:\(String(describing: emailAddress))"), UIApplication.shared.canOpenURL(mailURL) == true {
            UIApplication.shared.open(mailURL)
        }
    }
    
    func openDialer(phoneNumber: String) {
        if let phoneURL = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) == true {
            UIApplication.shared.open(phoneURL)
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchTabVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchTVCell else { return }
        switch indexPath.row {
        case UserDetailsToDisplay.email.rawValue:
            guard let email = cell.valueLabel.text else { return }
            openMailApp(emailAddress: email)
        case UserDetailsToDisplay.phone.rawValue:
            guard let phone = cell.valueLabel.text else { return }
            
            let callAction = AlertAction(title: "Call", style: .default)
            let chatAction = AlertAction(title: "Message", style: .default)
            let cancelAction = AlertAction(title: "Cancel", style: .cancel)
            self.presentAlert(title: "", message: "", style: .actionSheet, actions: [callAction, chatAction, cancelAction]) { [weak self] (alertAction) in
                if alertAction.title == "Call" {
                    self?.openDialer(phoneNumber: phone)
                } else if alertAction.title == "Message" {
                    guard let emailCell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? SearchTVCell else { return }
                    
                    guard let nameCell = tableView.cellForRow(at: IndexPath(row: 1, section: indexPath.section)) as? SearchTVCell else { return }
                    
                    guard let userEmail = emailCell.valueLabel.text else { return }
                    
                    guard let userName = nameCell.valueLabel.text else { return }
                    
                    guard let chatTabVC = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: ChatTabVC.self)) as? ChatTabVC else { return }
                    chatTabVC.recipientPhoneNumber = phone
                    chatTabVC.recipientEmail = userEmail
                    chatTabVC.recipientName = userName
                    self?.navigationController?.pushViewController(chatTabVC, animated: true)
                }
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchTabVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.filteredData[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDetailsToDisplay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTVCell.self)) as? SearchTVCell else { return SearchTVCell() }
        let user = viewModel.filteredData[indexPath.section]
        cell.fieldLabel.text = UserDetailsToDisplay.allCases[indexPath.row].title
        cell.valueLabel.tag = indexPath.row
        switch indexPath.row {
        case UserDetailsToDisplay.email.rawValue:
            cell.valueLabel.text = user.email
        case UserDetailsToDisplay.name.rawValue:
            cell.valueLabel.text = user.name
        case UserDetailsToDisplay.phone.rawValue:
            cell.valueLabel.text = user.phone
        case UserDetailsToDisplay.vehicleType.rawValue:
            cell.valueLabel.text = user.vehicleType
        case UserDetailsToDisplay.vehicleNumber.rawValue:
            cell.valueLabel.text = user.vehicleNumber
        default:
            break
        }
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension SearchTabVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterDataForSearchText(searchText: searchText, segmentType: SegmentTypes.allCases[segmentedControl.selectedSegmentIndex])
        tableView.reloadData()
    }
}
