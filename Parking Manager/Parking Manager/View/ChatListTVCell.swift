//
//  ChatListTVCell.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 19/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class ChatListTVCell: BaseTVCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
