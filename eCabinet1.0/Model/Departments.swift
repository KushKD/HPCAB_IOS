//
//  Departments.swift
//  eCabinet
//
//  Created by HP-DIT on 9/9/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct Departments{
    
    var DeptId: String
    var DeptName: String
    
       
         init(_ dictionary: [String: Any]) {
         self.DeptId = dictionary["DeptId"] as? String ?? ""
         self.DeptName = dictionary["DeptName"] as? String ?? ""
       
       }
    
    
}
