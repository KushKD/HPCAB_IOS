//
//  AppStoryboard.swift
//  login
//
//  Created by Oğulcan on 20/05/2018.
//  Copyright © 2018 ogulcan. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    
    case Login = "Login"
    case Main = "Main"
    case CabinetMemos = "CabinetMemosStoryBoard"
    case CabinetMemoDetials = "CabinetMemoDetailsStoryBoard"
    case CabinetHistory = "CabinetHistory"
    case CabinetAttachments = "MemoAttachments"
    case CabinetDecisions = "CabinetDecision"
    case AdminLogin = "AdminLogin"
    case NoInternet = "NoInternet"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass: T.Type, function: String = #function, line: Int = #line, file: String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
}
