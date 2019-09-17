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
        
    func loginOrSignUp(email: String, password: String, completionHandler: @escaping LoginOrSignUpHandler) {
        FirebaseManager.shared.loginOrSignUp(email: email, password: password) { (error, newUser) in
            DispatchQueue.main.async {
                completionHandler(error, newUser)
            }
        }
    }
    
    func signInWithGoogle(user: GIDGoogleUser?, error: Error?, completionHandler: @escaping MsgAndNewUserHandler) {
        var msg: String?
        if let error = error {
            msg = error.localizedDescription
            DispatchQueue.main.async {
                completionHandler(msg, nil)
            }
            return
        }
        guard let user = user else {
            msg = Constants.defaultErrorMessage
            DispatchQueue.main.async {
                completionHandler(msg, nil)
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        FirebaseManager.shared.signInWithGoogle(email: user.profile.email, authentication: authentication) { (error, newUser) in
            DispatchQueue.main.async {
                completionHandler(error?.localizedDescription, newUser)
            }
        }
    }
    
    func signInWithFB(result: LoginManagerLoginResult?, error: Error?, completionHandler: @escaping FBLoginOrSignUpHandler) {
        var msg: String?
        if let error = error {
            msg = error.localizedDescription
            DispatchQueue.main.async {
                completionHandler(msg, false, nil)
            }
            return
        }
        guard let accessToken = AccessToken.current else {
            DispatchQueue.main.async {
                completionHandler(nil, false, nil)
            }
            return
        }
        
        FirebaseManager.shared.signInWithFB(accessToken: accessToken) { (error, newUser) in
            DispatchQueue.main.async {
                completionHandler(error?.localizedDescription, error == nil, newUser)
            }
        }
    }
    
}
