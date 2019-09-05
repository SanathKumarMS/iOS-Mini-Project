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
    
    func loginOrSignUp(email: String, password: String) {
        FirebaseManager.shared.loginOrSignUp(email: email, password: password)
    }
    
    func signInWithGoogle(user: GIDGoogleUser?, error: Error?) {
        if let error = error {
            return
        }
        guard let user = user else {
            return
        }
        guard let authentication = user.authentication else { return }
        FirebaseManager.shared.signInWithGoogle(authentication: authentication)
    }
    
    func signInWithFB(result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            return
        }
        guard let accessToken = AccessToken.current else { return }
        FirebaseManager.shared.signInWithFB(accessToken: accessToken)
    }
    func signOut() {
        FirebaseManager.shared.signOut()
    }
}
