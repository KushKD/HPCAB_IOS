//
//  Branches.swift
//  eCabinet
//
//  Created by HP-DIT on 9/9/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct Branches{
    
    var BranchName: String
    var BranchID: String
    
       
         init(_ dictionary: [String: Any]) {
         self.BranchName = dictionary["BranchName"] as? String ?? ""
         self.BranchID = dictionary["BranchID"] as? String ?? ""
       
       }
    
    
}
