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
        viewModel.getAllUsersData(completionHandler: { [weak self] (userData) in
            guard let userData = userData else { return }
            self?.filteredData = userData.filter({ (user) -> Bool in
                user.vehicleType == VehicleTypes.bike.rawValue
            })
            self?.tableView.reloadData()
        })
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
        case UserDetails.email.rawValue:
            openMailApp(emailAddress: text)
        case UserDetails.phone.rawValue:
            openDialerOrChat(phoneNumber: text)
        default:
            return
        }
    }
    
    func openMailApp(emailAddress: String) {
        if let mailURL = URL(string: "mailto:\(String(describing: emailAddress))") {
            if UIApplication.shared.canOpenURL(mailURL) {
                UIApplication.shared.open(mailURL)
            }
        }
    }
    
    func openDialerOrChat(phoneNumber: String) {
        if let phoneURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL)
            }
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
        return UserDetails.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTVCell.self)) as? SearchTVCell else { return SearchTVCell() }
        let user = filteredData[indexPath.section]
        cell.label.text = UserDetails.allCases[indexPath.row].title
        cell.button.tag = indexPath.row
        switch indexPath.row {
        case UserDetails.email.rawValue:
            cell.button.setTitle(user.email, for: .normal)
        case UserDetails.name.rawValue:
            cell.button.setTitle(user.name, for: .normal)
        case UserDetails.phone.rawValue:
            cell.button.setTitle(user.phone, for: .normal)
        case UserDetails.vehicleType.rawValue:
            cell.button.setTitle(user.vehicleType, for: .normal)
        case UserDetails.vehicleNumber.rawValue:
            cell.button.setTitle(user.vehicleNumber, for: .normal)
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
            
            (user.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || user.email.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) && user.vehicleType == SegmentTypes.allCases[segmentedControl.selectedSegmentIndex].title
        })
        tableView.reloadData()
    }
}
