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
    private let messageRef = Database.database().reference(withPath: "Messages")
    private let storage = Storage.storage()
    private let userMessagesRef = Database.database().reference(withPath: "UserMessages")
    
    // MARK: - Authentication
    
    func loginOrSignUp(email: String, password: String, completionHandler: @escaping LoginOrSignUpHandler) {
        Auth.auth().fetchSignInMethods(forEmail: email) {(signInMethods, error) in
            if let error = error {
                completionHandler(error, nil)
                return
            }
            if let signInMethods = signInMethods {
                if signInMethods.contains(EmailPasswordAuthSignInMethod) {
                    //User already present. Signing in
                    Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                        completionHandler(error, false)
                    }
                }   //User not present. Creating account and signing in
            } else { Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
                guard let error = error else {
                    Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                        completionHandler(error, true)
                    }
                    return
                }
                completionHandler(error, nil)
            }
            }
        }
    }
    
    func signInWithGoogle(email: String, authentication: GIDAuthentication, completionHandler: @escaping LoginOrSignUpHandler) {
        var newUser: Bool?
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            if let signInMethods = signInMethods {
                if signInMethods.contains(GoogleAuthSignInMethod) {
                    newUser = false
                } else {
                    newUser = true
                }
            }
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        signInWithCredential(credential: credential, newUser: newUser, completionHandler: completionHandler)
    }
    
    func signInWithFB(accessToken: AccessToken, completionHandler: @escaping LoginOrSignUpHandler) {
        var newUser: Bool?
        let r = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
        
        r.start(completionHandler: { (_, result, error) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            
            if let result = result as? [String: String] {
                if let email = result["email"] {
                    Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
                        guard error == nil else {
                            completionHandler(error, nil)
                            return
                        }
                        if let signInMethods = signInMethods {
                            if signInMethods.contains(FacebookAuthSignInMethod) {
                                newUser = false
                            } else {
                                newUser = true
                            }
                        }
                    }
                }
            }
        })
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        signInWithCredential(credential: credential, newUser: newUser, completionHandler: completionHandler)
    }
    
    func signInWithCredential(credential: AuthCredential,newUser: Bool?, completionHandler: @escaping LoginOrSignUpHandler) {
        Auth.auth().signIn(with: credential) { (_, error) in
            completionHandler(error, newUser)
        }
    }
    
    func signOut() {
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            GIDSignIn.sharedInstance()?.signOut()
            return
        } else {
            do {
                try Auth.auth().signOut()
            } catch {
                return
            }
        }
        let loginManager = LoginManager()
        loginManager.logOut()
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
    
    //Add User Details to Realtime Database
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
    
    //Get Details of all the users in Firebase Database
    func getAllUsersDetails(completionHandler: @escaping GetAllUserDetailsCompletionHandler) {
        userDetails.observe(.value, with: { (snapshot) in
            guard let details = snapshot.value as? [String: Any] else {
                completionHandler(nil)
                return
            }
            completionHandler(details)
        })
    }
    
    //Add Message to Database
    func addMessage(message: Message) {
        let childRef = messageRef.childByAutoId()
        childRef.setValue(message.convertToDictionary())
        guard let messageKey = childRef.key else { return }
        let userMessagesFromIDRef = userMessagesRef.child(message.fromID)
        userMessagesFromIDRef.child(messageKey).setValue(1)
        let userMessagesToIDRef = userMessagesRef.child(message.toID)
        userMessagesToIDRef.child(messageKey).setValue(1)
    }
    
    //Get Chat Messages from Database
    func getChat(fromID: String, toID: String, completionHandler: @escaping GetMessageHandler) {
        userMessagesRef.child(fromID).observe(.childAdded) { [weak self] (snapshot) in
            let messageID = snapshot.key
            self?.messageRef.child(messageID).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let messageDetails = snapshot.value as? [String: Any] else {
                    return
                }

                guard let messageFromID = messageDetails["fromID"] as? String, let messageToID = messageDetails["toID"] as? String, let messageTimestamp = messageDetails["timestamp"] as? String, let messageText = messageDetails["text"] as? String else { return }

                if (messageFromID == fromID && messageToID == toID) || (messageFromID == toID && messageToID == fromID) {
                    let message = Message(fromID: messageFromID, toID: messageToID, timestamp: messageTimestamp, text: messageText)
                    completionHandler(message)
                }
            })
        }
    }
    
    // MARK: - Firebase Storage
    
    //Upload Profile picture to Firebase Storage and get its download URL
    func uploadImageToStorage(name: String, imageData: Data?, completionHandler: @escaping ImageHandler) {
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        let imageName = name + Constants.jpgExtension
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
        let imageName = name + Constants.jpgExtension
        let imageRef = imagesRef.child(imageName)
        imageRef.delete(completion: { (error) in
            completionHandler(error)
        })
    }
    
    //Download Image from Storage
    func downloadImageFromStorage(name: String, completionHandler: @escaping GetImageCompletionHandler) {
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        let imageName = name + Constants.jpgExtension
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
