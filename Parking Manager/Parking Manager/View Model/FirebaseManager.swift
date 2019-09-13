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
    
    private let root = Database.database().reference()
    private let userDetails = Database.database().reference(withPath: "UserDetails")
    private let storage = Storage.storage()
    
    // MARK: - Authentication
    
    func loginOrSignUp(email: String, password: String, completionHandler: @escaping ErrorHandler) {
        Auth.auth().fetchSignInMethods(forEmail: email) {(signInMethods, error) in
            if let error = error {
                completionHandler(error)
                return
            }
            if let signInMethods = signInMethods {
                if signInMethods.contains(EmailPasswordAuthSignInMethod) {
                    //User already present. Signing in
                    Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                        completionHandler(error)
                    }
                }   //User not present. Creating account and signing in
            } else { Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
                if error == nil {
                    Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                        completionHandler(error)
                    }
                } else {
                    completionHandler(error)
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
                GraphRequest(graphPath: "me",
                             parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                        if error == nil {
                            if let dict = result as? [String: AnyObject] {
                                print(dict)
                            }
                        }
                    })
        signInWithCredential(credential: credential, completionHandler: completionHandler)
    }
    
    func signInWithCredential(credential: AuthCredential, completionHandler: @escaping ErrorHandler) {
        Auth.auth().signIn(with: credential) { (_, error) in
            completionHandler(error)
        }
    }
    
    func signOut() {
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            GIDSignIn.sharedInstance()?.signOut()
        } else {
            do {
                try Auth.auth().signOut()
            } catch {
                return
            }
        }
    }
    
    func getLoggedInUserEmail() -> String {
        if let user = Auth.auth().currentUser {
            if let email = user.email {
                return email
            } else {
                if let providerEmail = user.providerData.first?.email {
                    return providerEmail
                }
            }
        }
        guard let googleUser = GIDSignIn.sharedInstance()?.currentUser, let email = googleUser.profile.email else { return "" }
        return email
    }
    
    // MARK: - Realtime Database
    
    func addUser(user: User) {
        let childRef = userDetails.child(user.md5HashOfEmail)
        childRef.setValue(user.convertToJSON())
    }
    
    //Get Details of a User Having Key as key
    func getUserDetails(key: String, completionHandler: @escaping GetUserDetailsCompletionHandler) {
        userDetails.child(key).observe(.value, with: { (snapshot) in
            guard let details = snapshot.value as? [String: Any] else {
                completionHandler(nil)
                return
            }
            completionHandler(details as? [String : String])
        })
    }
    
    func getAllUsersDetails(completionHandler: @escaping GetAllUserDetailsCompletionHandler) {
        userDetails.observe(.value, with: { (snapshot) in
            guard let details = snapshot.value as? [String: Any] else {
                completionHandler(nil)
                return
            }
            completionHandler(details)
        })
    }
    
    // MARK: - Firebase Storage
    
    //Upload Profile picture to Firebase Storage and get its download URL
    func uploadImageToStorage(name: String, imageData: Data?, completionHandler: @escaping ImageHandler) {
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        let imageName = name + ".jpg"
        let imageRef = imagesRef.child(imageName)
        guard let imageData = imageData else { return }
        
        _ = imageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            imageRef.downloadURL { (url, error) in
                completionHandler(url, error)
            }
        }
    }
    
    //Delete Image from Storage
    func deleteImageFromStorage(name: String, completionHandler: @escaping ErrorHandler) {
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        let imageName = name + ".jpg"
        let imageRef = imagesRef.child(imageName)
        imageRef.delete(completion: { (error) in
            completionHandler(error)
        })
    }
    
    //Download Image from Storage
    func downloadImageFromStorage(name: String, completionHandler: @escaping GetImageCompletionHandler) {
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        let imageName = name + ".jpg"
        let imageRef = imagesRef.child(imageName)
        imageRef.getData(maxSize: 30 * 1024 * 1024, completion: { (data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                completionHandler(nil, nil)
                return
            }
            completionHandler(data, nil)
        })
    }
}
