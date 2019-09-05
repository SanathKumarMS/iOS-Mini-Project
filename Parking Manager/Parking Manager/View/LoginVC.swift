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

class LoginVC: BaseVC, GIDSignInDelegate, LoginButtonDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    var viewModel = LoginVM()
    
    override func viewDidLoad() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        fbLoginButton.delegate = self
        super.viewDidLoad()
    }
    
    @IBAction private func manualLogin(_ sender: Any) {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        print(email, password)
        var msg: String = ""
        if email.isEmpty == false && password.isEmpty == false {
            if email.isValidEmail() == true {
                viewModel.loginOrSignUp(email: email, password: password) { [weak self] (msg) in
                    if msg != "nil" {
                        let alertAction = AlertAction(title: "Close", style: .cancel, handler: nil)
                        self?.presentAlert(title: "Error", message: msg, style: .alert, actions: [alertAction])
                    } else {
                        guard let userDetailsVC = self?.storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as? UserDetailsVC else { return }
                        self?.navigationController?.pushViewController(userDetailsVC, animated: true)
                    }
                }
            } else {
                print("Invalid Email")
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        viewModel.signInWithGoogle(user: user, error: error)
        guard let userDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as? UserDetailsVC else { return }
        self.navigationController?.pushViewController(userDetailsVC, animated: true)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        viewModel.signInWithFB(result: result, error: error)
        guard let userDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as? UserDetailsVC else { return }
        self.navigationController?.pushViewController(userDetailsVC, animated: true)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        viewModel.signOut()
    }
}

