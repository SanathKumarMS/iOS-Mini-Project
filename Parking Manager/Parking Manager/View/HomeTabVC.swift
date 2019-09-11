//
//  HomeTabVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 11/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class HomeTabVC: BaseVC {

    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var updateDetailsButton: UIButton!
    @IBOutlet private weak var homeTableView: UITableView!
    private var viewModel = HomeTabVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        print(profilePictureButton.bounds.size.width / 2)
        profilePictureButton.layer.cornerRadius = profilePictureButton.bounds.size.width / 2
        profilePictureButton.clipsToBounds = true
        viewModel.getLoggedInUserDetails()
    }

}

// MARK: - UITableViewDelegate

extension HomeTabVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate

extension HomeTabVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDetails.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTabTVCell.self)) as? HomeTabTVCell else { return HomeTabTVCell() }
        cell.displayTextField.tag = indexPath.row
        cell.detailLabel.text = UserDetails.allCases[indexPath.row].title + ":"
        cell.detailLabel.font = UIFont.systemFont(ofSize: 12)
        cell.displayTextField.text = viewModel.currentUser?.email
        return cell
    }
}
