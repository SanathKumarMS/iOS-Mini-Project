//
//  ChatTabTVCell.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 18/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class ChatTabTVCell: BaseTVCell {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var bubbleViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleVIewTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
