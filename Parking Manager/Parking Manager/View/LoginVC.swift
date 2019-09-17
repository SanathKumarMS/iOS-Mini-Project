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

    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var googleLoginButton: GIDSignInButton!
    @IBOutlet private weak var fbLoginButton: FBLoginButton!
    private var viewModel = LoginVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        fbLoginButton.delegate = self
        fbLoginButton.permissions = ["public_profile","email"]
        fbLoginButton.adjustsImageWhenHighlighted = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailField.text = ""
        passwordField.text = ""
    }
    
    @IBAction private func manualLogin(_ sender: Any) {
        startSpin()
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        let alertAction = AlertAction(title: AlertTitles.close, style: .cancel)
        if email.isEmpty == false && password.isEmpty == false {
            if email.isValidEmail() == true {
                guard password.isValidPassword() != false else {
                    self.stopSpin()
                    self.presentAlert(title: AlertTitles.error, message: AlertMessages.invalidPassword, style: .alert, actions: [alertAction])
                    return
                }
                viewModel.loginOrSignUp(email: email, password: password) { [weak self] (error, newUser) in
                    if let error = error {
                        self?.stopSpin()
                        self?.presentAlert(title: AlertTitles.error, message: error.localizedDescription, style: .alert, actions: [alertAction])
                    } else {
                        self?.stopSpin()
                        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
                        guard let newUser = newUser else { return }
                        
                        if newUser == true {
                            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.hasEnteredDetails.rawValue)
                            guard let userDetailsVC = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: UserDetailsVC.self)) as? UserDetailsVC else { return }
                            self?.navigationController?.pushViewController(userDetailsVC, animated: true)
                        } else {
                            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasEnteredDetails.rawValue)
                            guard let tabBarVC = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: TabBarVC.self)) as? TabBarVC else { return }
                            self?.present(tabBarVC, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                self.stopSpin()
                self.presentAlert(title: AlertTitles.error, message: AlertMessages.invalidEmail, style: .alert, actions: [alertAction])
            }
        } else {
            self.stopSpin()
            self.presentAlert(title: AlertTitles.error, message: AlertMessages.emptyField, style: .alert, actions: [alertAction])

        }
    }
}

// MARK: - GIDSignInDelegate

extension LoginVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        startSpin()
        viewModel.signInWithGoogle(user: user, error: error) { [weak self] (msg, newUser) in
            if let msg = msg {
                //For Handling Cancel in Google Sign in
                self?.stopSpin()
                if msg != AlertMessages.googleCancel {
                    let alertAction = AlertAction(title: AlertTitles.close, style: .cancel)
                    self?.presentAlert(title: AlertTitles.error, message: msg, style: .alert, actions: [alertAction])
                }
            } else {
                self?.stopSpin()
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
                if newUser == true {
                    UserDefaults.standard.set(false, forKey: UserDefaultsKeys.hasEnteredDetails.rawValue)
                    guard let userDetailsVC = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: UserDetailsVC.self)) as? UserDetailsVC else { return }
                    self?.navigationController?.pushViewController(userDetailsVC, animated: true)
                } else {
                    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasEnteredDetails.rawValue)
                    guard let tabBarVC = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: TabBarVC.self)) as? TabBarVC else { return }
                    self?.present(tabBarVC, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - LoginButtonDelegate

extension LoginVC: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        startSpin()
        viewModel.signInWithFB(result: result, error: error) { [weak self] (msg, success, newUser) in
            self?.stopSpin()
            if !success {
                guard let msg = msg else {
                    return
                }
                let alertAction = AlertAction(title: AlertTitles.close, style: .cancel)
                
                self?.presentAlert(title: AlertTitles.error, message: msg, style: .alert, actions: [alertAction])
            } else {
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
                if newUser == true {
                    UserDefaults.standard.set(false, forKey: UserDefaultsKeys.hasEnteredDetails.rawValue)
                    guard let userDetailsVC = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: UserDetailsVC.self)) as? UserDetailsVC else { return }
                    self?.navigationController?.pushViewController(userDetailsVC, animated: true)
                } else {
                    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasEnteredDetails.rawValue)
                    guard let tabBarVC = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: TabBarVC.self)) as? TabBarVC else { return }
                    self?.present(tabBarVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        viewModel.signOut()
    }
}
