//
//  AppDelegate.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 14/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import GoogleSignIn
import UIKit
import Firebase
import IQKeyboardManagerSwift
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = "692259290919-k15v019o5c56pfscmsrk6n1t9e58meu6.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        IQKeyboardManager.shared.enable = true
         
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = GIDSignIn.sharedInstance().handle(url)
        return handled
        // return GIDSignIn.sharedInstance().handle(url,
        // sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
        // annotation: [:])
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}





