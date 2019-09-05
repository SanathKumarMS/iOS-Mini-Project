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
    
    @IBAction func manualLogin(_ sender: Any) {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        print(email, password)
        if email.count > 0, password.count > 0 {
            if email.isValidEmail() == true {
                viewModel.loginOrSignUp(email: email, password: password)
            } else {
                print("Invalid Email")
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        viewModel.signInWithGoogle(user: user, error: error)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        viewModel.signInWithFB(result: result, error: error)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        viewModel.signOut()
    }
}

extension LoginVC: UITextFieldDelegate {
    
}
