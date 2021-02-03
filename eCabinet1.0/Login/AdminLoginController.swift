//
//  AdminLoginController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 2/3/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation
import UIKit


class AdminLoginController: UIViewController {
    
    @IBOutlet weak var topView: UIView! 
    var appUtilities = UtilitiesApp();
    let alertService = AlertService();
    var networkUtility = NetworkUtility();
    
    @IBOutlet weak var MobileNumber: UITextField!
    @IBOutlet weak var OTP: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        appUtilities.setHorizontalGradientColor(view: self.topView)
        MobileNumber.maxLength  = 20
        OTP.maxLength = 20
        
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        UIApplication.setRootView(LoginViewController.instantiate(from:.Login))
    }
    
    
    @IBAction func loginAdmin(_ sender: Any) {
        //UIApplication.setRootView(NoInternetController.instantiate(from:.NoInternet))
        
        
        print("We are Here");
        if (MobileNumber.text != nil  &&  OTP.text != nil) {

            if(MobileNumber.text?.caseInsensitiveCompare(Constants.usernameAdmin!) == .orderedSame &&
                OTP.text?.caseInsensitiveCompare(Constants.passwordAdmin!) == .orderedSame){
                
                
                //Go to Main Page
                                let preferences = UserDefaults.standard
                                
                                let branchMappedkey_ = "BRANCH_MAPPED"
                                  let designationKey_ = "DESIGNATION"
                                  let isCabinetMinisterKey_ = "IS_CABINET_MINISTER"
                                  let mobileNumberKey_ = "MOBILE_NUMBER"
                                  let nameKey_ = "NAME"
                                let userIdKey_ = "USER_ID"
                                let userRoleIdKey_ = "ROLE_ID"
                                let mapped_departments_id_key  = "DEPARTMENTS_MAPPED"
                                let mapped_loggedin_key = "IS_LOGGED_IN"
                                 //  let photo_key = "PHOTO"
                                

                                let branchMappedLevel = Constants.branchMappedLevel
                                let designationLevel = Constants.designationLevel
                                let isCabinetMinisterLevel = Constants.isCabinetMinisterLevel
                                let nameLevel = Constants.nameLevel
                                let userIdLevel = Constants.userIdLevel
                                let mobileLevel = Constants.mobileLevel
                                let mapped_departments_id_Level = Constants.mapped_departments_id_Level
                                let userRoleIdLevel = Constants.userRoleIdLevel
                                // let PhotoLevel = user_details.Photo
                                
                               
                                
                                
                                preferences.set(branchMappedLevel, forKey: branchMappedkey_)
                                preferences.set(designationLevel, forKey: designationKey_)
                                preferences.set(isCabinetMinisterLevel, forKey: isCabinetMinisterKey_)
                                preferences.set(mobileLevel, forKey: mobileNumberKey_)
                                preferences.set(nameLevel, forKey: nameKey_)
                                preferences.set(userIdLevel, forKey: userIdKey_)
                                 preferences.set(userRoleIdLevel, forKey: userRoleIdKey_)
                                preferences.set(mapped_departments_id_Level, forKey: mapped_departments_id_key)
                                // preferences.set(PhotoLevel, forKey: photo_key)
                                
                                 preferences.set(true, forKey: mapped_loggedin_key)
                               
                                print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))

                                //  Save to disk
                                let didSave = preferences.synchronize()
                                
                                if !didSave {
                                    DispatchQueue.main.async(execute: {
                                        let alertVC = self.alertService.alert(title: "Erro Message", body: "Unable to get the data from the database.", buttonTitle: "OK")
                                        { [weak self] in
                                            //Go to the Next Story Board
                                            
                                        }
                                        self.present(alertVC, animated: true)
                                        
                                    })
                                }else{
                                    UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                                }
                
                
                
            }else{
                DispatchQueue.main.async(execute: {
                                  let alertVC = self.alertService.alert(title: "Message", body: "Login Failed! Please enter valid Username and Password.", buttonTitle: "OK")
                                  { [weak self] in
                                      //Go to the Next Story Board
                                      
                                  }
                                  self.present(alertVC, animated: true)
                                  
                          })
            }
        }else {
            print("Please enter the Username and Password!")
            print("String is nil or empty")
            DispatchQueue.main.async(execute: {
                let alertVC = self.alertService.alert(title: "Network Message", body: "Please enter Username and Password.", buttonTitle: "OK")
                { [weak self] in
                    //Go to the Next Story Board
                    
                }
                self.present(alertVC, animated: true)
                
            })
        }
        
    }
}
