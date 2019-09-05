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
    
    typealias ErrorHandler = ((String) -> Void)
    func loginOrSignUp(email: String, password: String, completionHandler: @escaping ErrorHandler)
    {
        FirebaseManager.shared.loginOrSignUp(email: email, password: password) { (error) in
            if let error = error {
                print(error.localizedDescription)
                let msg = error.localizedDescription
                completionHandler(msg)
            }
            completionHandler("nil")
        }
    }
    
    func signInWithGoogle(user: GIDGoogleUser?, error: Error?) {
        if let error = error {
            return
        }
        guard let user = user else {
            return
        }
        guard let authentication = user.authentication else { return }
        FirebaseManager.shared.signInWithGoogle(authentication: authentication) { (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return error.localizedDescription
//            }
//            return "nil"
        }
    }
    
    func signInWithFB(result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            return
        }
        guard let accessToken = AccessToken.current else { return }
        FirebaseManager.shared.signInWithFB(accessToken: accessToken) { (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return error.localizedDescription
//            }
//            return "nil"
        }
    }
    func signOut() {
        FirebaseManager.shared.signOut()
    }
}
