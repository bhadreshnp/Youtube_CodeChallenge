//
//  AppDelegate.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-24.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import GoogleSignIn

func appDelegate() -> AppDelegate {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
        fatalError("Error in App Delegate.")
    }
    return delegate
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootCoordinator: RootCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance()?.clientID = googleClientID
        
        rootCoordinator = RootCoordinator()
        rootCoordinator.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

