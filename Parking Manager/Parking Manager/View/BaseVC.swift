//
//  BaseVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 03/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var spinnerVC: SpinnerVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Creates an Activity Indicator
    func startSpin() {
        spinnerVC = SpinnerVC()
        guard let spinnerVC = spinnerVC else { return }
        
        addChild(spinnerVC)
        spinnerVC.view.frame = view.frame
        view.addSubview(spinnerVC.view)
        spinnerVC.didMove(toParent: self)
    }

    func stopSpin() {
        spinnerVC?.willMove(toParent: nil)
        spinnerVC?.view.removeFromSuperview()
        spinnerVC?.removeFromParent()
    }
    
    func presentAlert(title: String, message: String, style: UIAlertController.Style, actions: [AlertAction], completionHandler: ((AlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        for item in actions {
            alertController.addAction(UIAlertAction(title: item.title, style: item.style, handler: { (alertAction) in
                completionHandler?(item)
            }))
        }
        present(alertController, animated: true, completion: nil)
    }

}

struct AlertAction {
    var title: String
    var style: UIAlertAction.Style
}
