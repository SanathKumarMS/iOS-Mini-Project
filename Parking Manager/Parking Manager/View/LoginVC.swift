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

class LoginVC: BaseVC, GIDSignInDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        super.viewDidLoad()
    }
    
    @IBAction func manualLogin(_ sender: Any) {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        print(email, password)
//        print(Auth.auth().currentUser ?? "none")
//
        print(Auth.auth().currentUser ?? "none")
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch let error {
                print(error)
            }
        }
        Auth.auth().fetchSignInMethods(forEmail: email) {(signInMethods, error) in
            if let error = error {
                print(error)
            }
            if let signInMethods = signInMethods {
                print("Sign in Methods ", signInMethods)
                if signInMethods.contains(EmailPasswordAuthSignInMethod) {
                    print("User already present. Signing in")
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            } else { Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error == nil {
                        print("User not present. Creating account and signing in")
                        Auth.auth().signIn(withEmail: email, password: password)
                    } else {
                        print(error ?? "No error")
                    }
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
}
