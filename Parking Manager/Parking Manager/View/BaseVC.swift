//
//  BaseVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 03/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func presentAlert(title: String, message: String, style: UIAlertController.Style, actions: [AlertAction]){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        for item in actions {
            alertController.addAction(UIAlertAction(title: item.title, style: item.style, handler: item.handler))
        }
        present(alertController, animated: true, completion: nil)
    }

}

struct AlertAction {
    var title: String
    var style: UIAlertAction.Style
    var handler: ((UIAlertAction) -> Void)?
}
