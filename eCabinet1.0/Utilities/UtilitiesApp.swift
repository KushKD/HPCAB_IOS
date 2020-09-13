//
//  UtilitiesApp.swift
//  eCabinet
//
//  Created by HP-DIT on 9/7/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

class UtilitiesApp{
    
    public func getDate()->String{
        let dateFormatter : DateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyyMMddHHmm"
              let date = Date()
              let dateString = dateFormatter.string(from: date)
              print(dateString)
        return dateString
    }
    
    
    public func createUrl(GetDataPojo data: GetPojo) -> String{
        var url = ""
        url += data.url!
        url += Constants.delemeter!
        url += data.methord!
        url += Constants.delemeter!
        url += data.methordHash!
        
        if !data.parametersList.isEmpty && data.parametersList.count != 0{
            
            for parameter in data.parametersList {
                url += Constants.delemeter!
                url += parameter
            }
        }
        print(url)
      return url;
    }
   
    public func saveUserDetails(data_user data: LoggedInUser, user_server: [LoggedInUserDepartments] ) -> SavedUser{
        
        let saveUser = SavedUser()
        var departmentsId: String  = ""
        var departmentsName: String = ""
        
        saveUser.Branchmapped = data.Branchmapped.base64Decoded!
        saveUser.Desgination = data.Desgination.base64Decoded!
        saveUser.IsCabinetMinister = data.IsCabinetMinister.base64Decoded!
        saveUser.MobileNumber = data.MobileNumber.base64Decoded!
        saveUser.Name = data.Name.base64Decoded!
        saveUser.RoleId = data.RoleId
        saveUser.UserID = data.UserID.base64Decoded!
        saveUser.Photo = data.Photo
        
        for x in user_server {
            departmentsId += x.Departmentmapped.base64Decoded!
            departmentsId += ","
        }
        
        for x in user_server {
                   departmentsName += x.Departmentname.base64Decoded!
                   departmentsName += ","
               }
        
        saveUser.departmentsId = departmentsId
        saveUser.departmentsName = departmentsName
        
         return saveUser;
       }
    
    
    //Writing data to NSUserDeatils
    public func writeUserData(data user_details : SavedUser) -> Bool{
        
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
        

        let branchMappedLevel = user_details.Branchmapped
        let designationLevel = user_details.Desgination
        let isCabinetMinisterLevel = user_details.IsCabinetMinister
        let nameLevel = user_details.Name
        let userIdLevel = user_details.UserID
          let mobileLevel = user_details.MobileNumber
        let mapped_departments_id_Level = user_details.departmentsId
           let userRoleIdLevel = user_details.RoleId
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
            return false
        }else{
            return true
        }
        
    }
    
    
    func  hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
