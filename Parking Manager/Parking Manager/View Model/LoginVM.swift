//
//  LoginVM.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 04/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation
import GoogleSignIn
import FBSDKLoginKit

class LoginVM: BaseVM {
    
    typealias ErrorHandler = ((String?) -> Void)
    func loginOrSignUp(email: String, password: String, completionHandler: @escaping ErrorHandler) {
        FirebaseManager.shared.loginOrSignUp(email: email, password: password) { (error) in
            var msg: String?
            if let error = error {
                msg = error.localizedDescription
            }
            DispatchQueue.main.async {
                completionHandler(msg)
            }
        }
    }
    
    func signInWithGoogle(user: GIDGoogleUser?, error: Error?, completionHandler: @escaping (String?) -> Void) {
        var msg: String?
        if let error = error {
            msg = error.localizedDescription
            DispatchQueue.main.async {
                completionHandler(msg)
            }
            return
        }
        guard let user = user else {
            msg = "The operation could not be completed"
            DispatchQueue.main.async {
                completionHandler(msg)
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        FirebaseManager.shared.signInWithGoogle(authentication: authentication) { (error) in
            if let error = error {
                msg = error.localizedDescription
            }
            DispatchQueue.main.async {
                completionHandler(msg)
            }
        }
    }
    
    func signInWithFB(result: LoginManagerLoginResult?, error: Error?, completionHandler: @escaping (String?) -> Void) {
        var msg: String?
        if let error = error {
            msg = error.localizedDescription
            DispatchQueue.main.async {
                completionHandler(msg)
            }
            return
        }
        guard let accessToken = AccessToken.current else {
            msg = "Cancel"
            DispatchQueue.main.async {
                completionHandler(msg)
            }
            return
        }
        
        FirebaseManager.shared.signInWithFB(accessToken: accessToken) { (error) in
            if let error = error {
                msg = error.localizedDescription
            }
            DispatchQueue.main.async {
                completionHandler(msg)
            }
        }
    }
    
}
