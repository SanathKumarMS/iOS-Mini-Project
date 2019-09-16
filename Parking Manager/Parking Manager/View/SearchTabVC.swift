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
    private var filteredData: [User] = []
    private var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Search"
        getAllUsersData()
    }
    
    @IBAction private func segmentIndexChanged() {
        searchBar.text = ""
        filteredData = viewModel.allUsers.filter({ (user) -> Bool in
            user.vehicleType == SegmentTypes.allCases[segmentedControl.selectedSegmentIndex].title
        })
        tableView.reloadData()
    }

    @IBAction private func onClickedValue(_ sender: Any) {
        guard let button = sender as? UIButton, let text = button.title(for: .normal) else { return }
        switch button.tag {
        case UserDetailsToDisplay.email.rawValue:
            openMailApp(emailAddress: text)
        case UserDetailsToDisplay.phone.rawValue:
            guard let chatTabVC = storyboard?.instantiateViewController(withIdentifier: String(describing: ChatTabVC.self)) as? ChatTabVC else { return }
            chatTabVC.recipientPhoneNumber = text
            navigationController?.pushViewController(chatTabVC, animated: true)
//            present(chatTabVC, animated: true)
            //openDialerOrChat(phoneNumber: text)
        default:
            return
        }
    }
    
    func getAllUsersData() {
        viewModel.getAllUsersData(completionHandler: { [weak self] (userData) in
            guard let userData = userData else { return }
            self?.filteredData = userData.filter({ (user) -> Bool in
                user.vehicleType == VehicleTypes.bike.rawValue
            })
            self?.tableView.reloadData()
        })
    }
    
    func openMailApp(emailAddress: String) {
        if let mailURL = URL(string: "mailto:\(String(describing: emailAddress))"), UIApplication.shared.canOpenURL(mailURL) == true {
            UIApplication.shared.open(mailURL)
        }
    }
    
    func openDialerOrChat(phoneNumber: String) {
        if let phoneURL = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) == true {
            UIApplication.shared.open(phoneURL)
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchTabVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension SearchTabVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredData[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDetailsToDisplay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTVCell.self)) as? SearchTVCell else { return SearchTVCell() }
        let user = filteredData[indexPath.section]
        cell.fieldLabel.text = UserDetailsToDisplay.allCases[indexPath.row].title
        cell.detailButton.tag = indexPath.row
        switch indexPath.row {
        case UserDetailsToDisplay.email.rawValue:
            cell.detailButton.setTitle(user.email, for: .normal)
        case UserDetailsToDisplay.name.rawValue:
            cell.detailButton.setTitle(user.name, for: .normal)
        case UserDetailsToDisplay.phone.rawValue:
            cell.detailButton.setTitle(user.phone, for: .normal)
        case UserDetailsToDisplay.vehicleType.rawValue:
            cell.detailButton.setTitle(user.vehicleType, for: .normal)
        case UserDetailsToDisplay.vehicleNumber.rawValue:
            cell.detailButton.setTitle(user.vehicleNumber, for: .normal)
        default:
            break
        }
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension SearchTabVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = viewModel.allUsers.filter({(user) -> Bool in
            
            (user.name.lowercased().contains(searchText.lowercased()) || user.email.lowercased().contains(searchText.lowercased()) || user.vehicleNumber.lowercased().contains(searchText.lowercased())) && user.vehicleType == SegmentTypes.allCases[segmentedControl.selectedSegmentIndex].title
//            (user.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || user.email.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) && user.vehicleType == SegmentTypes.allCases[segmentedControl.selectedSegmentIndex].title
        })
        tableView.reloadData()
    }
}
