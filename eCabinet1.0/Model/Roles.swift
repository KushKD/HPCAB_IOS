//
//  Roles.swift
//  eCabinet
//
//  Created by HP-DIT on 9/8/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct Roles{
       var RoleName: String
       var Roleid: String
    
    init(_ dictionary: [String: Any]) {
      self.RoleName = dictionary["RoleName"] as? String ?? ""
      self.Roleid = dictionary["Roleid"] as? String ?? ""
    }
}

