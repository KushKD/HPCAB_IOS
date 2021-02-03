//
//  NoInternetController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 2/3/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation

import UIKit


class NoInternetController: UIViewController {
    
    let alertService = AlertService();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func checkInternet(_ sender: Any) {
        print("Please Check Internet")
        
        if Reachability.isConnectedToNetwork(){
            UIApplication.setRootView(LoginViewController.instantiate(from:.Login))
        }else{
            DispatchQueue.main.async(execute: {
                let alertVC = self.alertService.alert(title: "Network Message", body: Constants.internetNotAvailable!, buttonTitle: "OK")
                { [weak self] in
                    //Go to the Next Story Board
                   
                    
                }
                self.present(alertVC, animated: true)
                
            })
        }
        
        
    }
}
