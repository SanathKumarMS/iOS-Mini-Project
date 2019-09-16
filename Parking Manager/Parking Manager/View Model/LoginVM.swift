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
        
    func loginOrSignUp(email: String, password: String, completionHandler: @escaping StringCompletionHandler) {
        FirebaseManager.shared.loginOrSignUp(email: email, password: password) { (error) in
            DispatchQueue.main.async {
                completionHandler(error?.localizedDescription)
            }
        }
    }
    
    func signInWithGoogle(user: GIDGoogleUser?, error: Error?, completionHandler: @escaping StringCompletionHandler) {
        var msg: String?
        if let error = error {
            msg = error.localizedDescription
            DispatchQueue.main.async {
                completionHandler(msg)
            }
            return
        }
        guard let user = user else {
            msg = Constants.defaultErrorMessage
            DispatchQueue.main.async {
                completionHandler(msg)
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        FirebaseManager.shared.signInWithGoogle(authentication: authentication) { (error) in
            DispatchQueue.main.async {
                completionHandler(error?.localizedDescription)
            }
        }
    }
    
    func signInWithFB(result: LoginManagerLoginResult?, error: Error?, completionHandler: @escaping FBCompletionHandler) {
        var msg: String?
        if let error = error {
            msg = error.localizedDescription
            DispatchQueue.main.async {
                completionHandler(msg, false)
            }
            return
        }
        guard let accessToken = AccessToken.current else {
            DispatchQueue.main.async {
                completionHandler(nil, false)
            }
            return
        }
        
        FirebaseManager.shared.signInWithFB(accessToken: accessToken) { (error) in
            DispatchQueue.main.async {
                completionHandler(error?.localizedDescription, error == nil)
            }
        }
    }
    
}
