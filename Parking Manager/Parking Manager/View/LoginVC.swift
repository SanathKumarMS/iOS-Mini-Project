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
    @IBOutlet weak var fbLoginButton: FBLoginButton!
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
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error)
            return
        }
        guard let accessToken = AccessToken.current else { return }
        print(accessToken.tokenString)
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        print(credential.provider)
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
            .start(completionHandler: { (connection, result, error) -> Void in
            if  error == nil {
                if let dict = result as? [String: AnyObject] {
                    print(dict)
                }
            }
        })
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
    }
}
