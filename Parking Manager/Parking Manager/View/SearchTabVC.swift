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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Search"
        viewModel.getAllUsersData()
    }

}

//Add MARK later
extension SearchTabVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SearchTabVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTVCell.self)) as? SearchTVCell else { return SearchTVCell() }
        cell.label.text = "Hey"
        cell.button.setTitle(filteredData[indexPath.row].email, for: .normal)
        return cell
    }
}

extension SearchTabVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = viewModel.allUsers.filter ( {(user) -> Bool in
            
            return user.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || user.email.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        tableView.reloadData()
    }
}
