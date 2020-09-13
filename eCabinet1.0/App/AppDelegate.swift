//
//  AppDelegate.swift
//  login
//
//  Created by Oğulcan on 11/05/2018.
//  Copyright © 2018 ogulcan. All rights reserved.
//

import UIKit

typealias App = AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       
        // Let's initiliaze window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
       
         let mapped_loggedin_key = "IS_LOGGED_IN"
        print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))
        
        if (UserDefaults.standard.bool(forKey: mapped_loggedin_key)) {
            let mainViewController = MainViewController.instantiate(from: .Main)
            self.window?.rootViewController = mainViewController
            
            
        } else {
            // Show the login page
            let loginViewController = LoginViewController.instantiate(from: .Login)
            self.window?.rootViewController = loginViewController
            
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

