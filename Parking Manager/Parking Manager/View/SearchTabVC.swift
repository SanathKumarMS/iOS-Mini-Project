//
//  SearchTabVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 12/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class SearchTabVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Search"
    }

}

extension SearchTabVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

