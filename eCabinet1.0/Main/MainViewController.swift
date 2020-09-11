//
//  MainViewController.swift
//  login
//
//  Created by Oğulcan on 11/05/2018.
//  Copyright © 2018 ogulcan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clearLoginTapped(_ sender: UIButton) {
       // try! App.keychain?.remove("token")
         let preferences = UserDefaults.standard
         let mapped_loggedin_key = "IS_LOGGED_IN"
        preferences.set(false, forKey: mapped_loggedin_key)
          print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))
        UIApplication.setRootView(LoginViewController.instantiate(from: .Login), options: UIApplication.logoutAnimation)
    }
}
