//
//  ChatCVCell.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 16/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class ChatCVCell: BaseCVCell {
    
    @IBOutlet weak var bubbleViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        bubbleViewWidthConstraint.constant = 207
    }
}
