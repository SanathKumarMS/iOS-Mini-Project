//
//  FirebaseManager.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 03/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import FBSDKLoginKit
class FirebaseManager {
    
    static var shared = FirebaseManager()
    
    private init() {
        
    }
    
    typealias CompletionHandler = (() -> Void)
    func loginOrSignUp(email: String, password: String, completionHandler: CompletionHandler? = nil) {
        Auth.auth().fetchSignInMethods(forEmail: email) {(signInMethods, error) in
            if let error = error {
                print(error)
            }
            if let signInMethods = signInMethods {
                print("Sign in Methods ", signInMethods)
                if signInMethods.contains(EmailPasswordAuthSignInMethod) {
                    print("User already present. Signing in")
                    Auth.auth().signIn(withEmail: email, password: password)
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            } else { Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    print("User not present. Creating account and signing in")
                    Auth.auth().signIn(withEmail: email, password: password)
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                } else {
                    print(error ?? "No error")
                }
                }
            }
        }
    }
    
    func signInWithGoogle(authentication: GIDAuthentication, completionHandler: CompletionHandler? = nil) {
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        signInWithCredential(credential: credential)
        if let completionHandler = completionHandler {
            completionHandler()
        }
    }
    
    func signInWithFB(accessToken: AccessToken, completionHandler: CompletionHandler? = nil) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        print(credential.provider)
        GraphRequest(graphPath: "me",
                     parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
            .start(completionHandler: { (connection, result, error) -> Void in
                if  error == nil {
                    if let dict = result as? [String: AnyObject] {
                        print(dict)
                    }
                }
            })
        signInWithCredential(credential: credential)
        if let completionHandler = completionHandler {
            completionHandler()
        }
    }
    
    func signInWithCredential(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
    }
}
