//
//  Constants.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 10/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation

typealias ErrorHandler = (Error?) -> Void
typealias LoginOrSignUpHandler = (Error?, Bool?) -> Void
typealias FBLoginOrSignUpHandler = (String?, Bool, Bool?) -> Void
typealias MsgAndNewUserHandler = (String?, Bool?) -> Void
typealias ImageHandler = (URL?, Error?) -> Void
typealias StringCompletionHandler = (String?) -> Void
typealias FBCompletionHandler = (String?, Bool) -> Void
typealias GetUserDetailsCompletionHandler = ([String: String]?) -> Void
typealias GetAllUserDetailsCompletionHandler = ([String: Any]?) -> Void
typealias GetAllUserDataCompletionHandler = ([User]?) -> Void
typealias GetImageCompletionHandler = (Data?, Error?) -> Void
typealias GetChatHandler = ([Message]?) -> Void
typealias GetMessageHandler = (Message?) -> Void

struct Constants {
    static let projectName = "Parking Manager"
    static let defaultProfilePhoto = "Network-Profile"
    static let defaultErrorMessage = "The operation could not be completed."
    static let successMessage = "Success"
    static let iPhone5SHeight = 568.0
    static let topConstraintfor5S = 70.0
    static let dropDownImage = "dropdown.png"
    static let jpgExtension = ".jpg"
}

struct AlertTitles {
    static let error = "Error"
    static let close = "Close"
    static let profilePhoto = "Profile Photo"
    static let success = "Success!"
}

struct AlertMessages {
    static let invalidEmail = "Invalid Email Entered"
    static let invalidPassword = "Invalid Password Entered"
    static let emptyField = "Email or password field empty"
    static let googleCancel = "The operation couldn’t be completed. (org.openid.appauth.general error -3.)"
    static let fbCancel = "Cancel"
    static let chooseYourAction = "Choose your Action"
    static let successfulOperation = ""
    static let detailsUpdated = "Your Profile details are updated!"
    static let otherUsersDetailsUpdated = "The user's details are added!"
}

struct ToolBarTitles {
    static let done = "Done"
    static let cancel = "Cancel"
}

enum ImagePickerActionTypes: String {
    case camera = "Camera"
    case photoLibrary = "Photo Library"
    case cancel = "Cancel"
    case delete = "Delete"
}

enum UserDefaultsKeys: String {
    case isLoggedIn
    case hasEnteredDetails
}
