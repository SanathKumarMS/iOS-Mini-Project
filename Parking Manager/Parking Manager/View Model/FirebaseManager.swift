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
import FirebaseAuth
import FirebaseStorage

class FirebaseManager {
    
    static var shared = FirebaseManager()
    
    private init() {
        
    }
    
    let root = Database.database().reference()
    let userDetails = Database.database().reference(withPath: "UserDetails")
    let storage = Storage.storage()
    typealias ErrorHandler = (Error?) -> Void
    
    // MARK: - Authentication
    
    func loginOrSignUp(email: String, password: String, completionHandler: @escaping ErrorHandler) {
        Auth.auth().fetchSignInMethods(forEmail: email) {(signInMethods, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            if let signInMethods = signInMethods {
                if signInMethods.contains(EmailPasswordAuthSignInMethod) {
                    print("User already present. Signing in")
                    Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                            completionHandler(error)
                    }
                }
            } else { Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
                        if error == nil {
                            print("User not present. Creating account and signing in")
                            Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
                                completionHandler(error)
                            }
                        } else {
                    }
                }
            }
        }
    }
    
    func signInWithGoogle(authentication: GIDAuthentication, completionHandler: @escaping ErrorHandler) {
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        signInWithCredential(credential: credential, completionHandler: completionHandler)
    }
    
    func signInWithFB(accessToken: AccessToken, completionHandler: @escaping ErrorHandler) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//        GraphRequest(graphPath: "me",
//                     parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                if error == nil {
//                    if let dict = result as? [String: AnyObject] {
//                        print(dict)
//                    }
//                }
//            })
        signInWithCredential(credential: credential, completionHandler: completionHandler)
    }
    
    func signInWithCredential(credential: AuthCredential, completionHandler: @escaping ErrorHandler) {
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                completionHandler(error)
            }
            completionHandler(error)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
    }
    
    func getLoggedInUserEmail() -> String {
        if let user = Auth.auth().currentUser {
            if let email = user.email {
                return email
            } else {
                if let providerEmail = user.providerData[0].email {
                    return providerEmail
                }
            }
        }
        if let googleUser = GIDSignIn.sharedInstance()?.currentUser {
            if let email = googleUser.profile.email {
                return email
            }
        }
        return ""
    }
    
    // MARK: - Realtime Database
    
    func addUser(user: User) {
        let childRef = userDetails.child(user.md5HashOfEmail)
        childRef.setValue(user.convertToJSON())
    }
    
    // MARK: - Firebase Storage
    
    func uploadPhotoToStorage(name: String, imageData: Data?) {
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        let imageName = name + ".jpg"
        let imageRef = imagesRef.child(imageName)
        guard let imageData = imageData else { return }

    }
}
