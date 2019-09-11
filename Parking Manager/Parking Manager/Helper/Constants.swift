//
//  Constants.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 10/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import Foundation

typealias ErrorHandler = (Error?) -> Void
typealias ImageHandler = (URL?, Error?) -> Void
typealias StringCompletionHandler = (String?) -> Void
typealias FBCompletionHandler = (String?, Bool) -> Void
typealias GetUserDetailsCompletionHandler = (User?) -> Void

let projectName = "Parking Manager"
let defaultProfilePhoto = "Network-Profile"
let defaultErrorMessage = "The operation could not be completed."
let successMessage = "Success"

struct AlertTitles {
    static let error = "Error"
    static let close = "Close"
    static let profilePhoto = "Profile Photo"
    static let success = "Success"
}

struct AlertMessages {
    static let invalidEmail = "Invalid Email Entered"
    static let emptyField = "Email or password field empty"
    static let googleCancel = "The operation couldn’t be completed. (org.openid.appauth.general error -3.)"
    static let fbCancel = "Cancel"
    static let chooseYourAction = "Choose your Action"
    static let successfulOperation = ""
}

struct ToolBarTitles {
    static let done = "Done"
    static let cancel = "Cancel"
}