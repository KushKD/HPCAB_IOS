//
//  LoggedInUser.swift
//  eCabinet
//
//  Created by HP-DIT on 9/10/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation
/**
 private String Branchmapped;
    private String Desgination;
    private String IsCabinetMinister;
    private String MobileNumber;
    private String Name;
    private String UserID;
    private String RoleId;
    private List<DepartmentsUserPojo> departmentsUser;
    private String Photo;
 
 [
   {
     
     "Departmentmapped": "NTI=",
     "Departmentname": "4KS44KWC4KSa4KSo4KS+IOCkquCljeCksOCli+CkpuCljeCkr+Cli+Ckl+Ckv+CkleClgA==",
    
   }
 ]
 */

struct LoggedInUser{
    
    var Branchmapped: String
    var Desgination: String
    var IsCabinetMinister:String
    var MobileNumber: String
    var Name : String
    var UserID : String
    var RoleId : String
    //var StatusCode : Int
    var StatusMessage : String
    
    
       
         init(_ dictionary: [String: Any]) {
         self.Branchmapped = dictionary["Branchmapped"] as? String ?? ""
         self.Desgination = dictionary["Desgination"] as? String ?? ""
             self.IsCabinetMinister = dictionary["IsCabinetMinister"] as? String ?? ""
             self.MobileNumber = dictionary["MobileNumber"] as? String ?? ""
             self.Name = dictionary["Name"] as? String ?? ""
             self.UserID = dictionary["UserID"] as? String ?? ""
             self.RoleId = dictionary["RoleId"] as? String ?? ""
          //  self.StatusCode = dictionary["StatusCode"] as? String ?? ""
             self.StatusMessage = dictionary["StatusMessage"] as? String ?? ""
            
       
       }
    
    
}
