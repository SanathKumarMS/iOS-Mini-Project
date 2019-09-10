//
//  SpinnerVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 09/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class SpinnerVC: BaseVC {
    
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        guard let spinner = spinner else { return }
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.frame = view.frame
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
