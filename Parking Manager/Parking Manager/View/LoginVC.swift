//
//  LoginVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 03/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class LoginVC: BaseVC {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    var viewModel = LoginVM()
    var activityIndicator: SpinnerVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        fbLoginButton.delegate = self
        fbLoginButton.isHighlighted = false
        fbLoginButton.showsTouchWhenHighlighted = false
    }
    
    @IBAction private func manualLogin(_ sender: Any) {
        startActivityIndicator()
        let email = emailField.text ?? ""
        print(email.hash)
        let password = passwordField.text ?? ""
        print(email, password)
        if email.isEmpty == false && password.isEmpty == false {
            if email.isValidEmail() == true {
                viewModel.loginOrSignUp(email: email, password: password) { [weak self] (msg) in
                    if msg != "nil" {
                        let alertAction = AlertAction(title: "Close", style: .cancel, handler: nil)
                        DispatchQueue.main.async {
                            self?.presentAlert(title: "Error", message: msg, style: .alert, actions: [alertAction])
                        }
                    } else {
                        guard let userDetailsVC = self?.storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as? UserDetailsVC else { return }
                        self?.navigationController?.pushViewController(userDetailsVC, animated: true)
                        DispatchQueue.main.async {
                            self?.stopActivityIndicator()
                        }
                    }
                }
            } else {
                let alertAction = AlertAction(title: "Close", style: .cancel, handler: nil)
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", message: "Invalid Email Entered", style: .alert, actions: [alertAction])
                }
            }
        } else {
            let alertAction = AlertAction(title: "Close", style: .cancel, handler: nil)
            DispatchQueue.main.async {
                self.presentAlert(title: "Error", message: "Email or password field empty", style: .alert, actions: [alertAction])
            }
        }
    }
    
    func startActivityIndicator() {
        activityIndicator = SpinnerVC()
        guard let activityIndicator = activityIndicator else { return }
        addChild(activityIndicator)
        activityIndicator.view.frame = view.frame
        view.addSubview(activityIndicator.view)
        activityIndicator.didMove(toParent: self)
    }
    
    func stopActivityIndicator() {
        activityIndicator?.willMove(toParent: nil)
        activityIndicator?.view.removeFromSuperview()
        activityIndicator?.removeFromParent()
    }
}

// MARK: - GIDSignInDelegate

extension LoginVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        viewModel.signInWithGoogle(user: user, error: error) { (msg) in
            if msg != "nil" {
                let alertAction = AlertAction(title: "Close", style: .cancel, handler: nil)
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", message: msg, style: .alert, actions: [alertAction])
                }
            } else {
                guard let userDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as? UserDetailsVC else { return }
                self.navigationController?.pushViewController(userDetailsVC, animated: true)
            }
        }
        
    }
}

// MARK: - LoginButtonDelegate

extension LoginVC: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        viewModel.signInWithFB(result: result, error: error) { (msg) in
            if msg != "nil" {
                let alertAction = AlertAction(title: "Close", style: .cancel, handler: nil)
                DispatchQueue.main.async {
                    self.presentAlert(title: "Error", message: msg, style: .alert, actions: [alertAction])
                }
            } else {
                guard let userDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as? UserDetailsVC else { return }
                self.navigationController?.pushViewController(userDetailsVC, animated: true)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        viewModel.signOut()
    }
}
