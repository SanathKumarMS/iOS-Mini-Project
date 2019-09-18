//
//  AppDelegate.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 03/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue) == true {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasEnteredDetails.rawValue) == true {
                 window?.rootViewController = storyboard.instantiateViewController(withIdentifier: String(describing: TabBarVC.self))
            } else {
                let navVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: String(describing: LoginVC.self)))
                navVC.pushViewController(storyboard.instantiateViewController(withIdentifier: String(describing: UserDetailsVC.self)), animated: true)
                window?.rootViewController = navVC
            }
        } else {
            window?.rootViewController = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: String(describing: LoginVC.self)))
        }
        /*
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasEnteredDetails.rawValue) != true {
            let navVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: String(describing: LoginVC.self)))
            navVC.pushViewController(storyboard.instantiateViewController(withIdentifier: String(describing: UserDetailsVC.self)), animated: true)
            window?.rootViewController = navVC
        } else if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue) == true {
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: String(describing: TabBarVC.self))
        } else {
            window?.rootViewController = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: String(describing: LoginVC.self)))
        }
         */
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //To open the app
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
