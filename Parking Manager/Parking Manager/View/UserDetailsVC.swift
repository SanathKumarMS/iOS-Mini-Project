//
//  UserDetailsVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 05/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class UserDetailsVC: BaseVC {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}



// MARK: - UITableViewDelegate

extension UserDetailsVC: UITableViewDelegate {
 
}

// MARK: - UITableViewDataSource

extension UserDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailsTVCell.self)) as? UserDetailsTVCell else { return UserDetailsTVCell() }
        return cell
    }
    
    
}