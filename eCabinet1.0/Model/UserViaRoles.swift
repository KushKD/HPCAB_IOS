//
//  UserViaRoles.swift
//  eCabinet
//
//  Created by HP-DIT on 9/8/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct UserViaRoles{
    
    var name: String
          var Designation: String
     var MobileNO: String
     var Userid: String
    var Photo: String
       
       init(_ dictionary: [String: Any]) {
         self.name = dictionary["name"] as? String ?? ""
         self.Designation = dictionary["Designation"] as? String ?? ""
        self.MobileNO = dictionary["MobileNO"] as? String ?? ""
        self.Userid = dictionary["Userid"] as? String ?? ""
        self.Photo = dictionary["Photo"] as? String ?? ""
       }
    
    
}
