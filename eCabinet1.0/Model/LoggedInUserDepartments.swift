//
//  LoggedInUserDepartments.swift
//  eCabinet
//
//  Created by HP-DIT on 9/10/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct LoggedInUserDepartments{
    var Departmentmapped: String
       var Departmentname: String
       
       
          
            init(_ dictionary: [String: Any]) {
            self.Departmentmapped = dictionary["Departmentmapped"] as? String ?? ""
            self.Departmentname = dictionary["Departmentname"] as? String ?? ""
               
          
          }
}
