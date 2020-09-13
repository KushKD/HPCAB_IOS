//
//  Menu.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/13/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct Menu{
    
    var Menuid: String
    var MenuName: String
    var MenuIcon: String
    
       
         init(_ dictionary: [String: Any]) {
         self.Menuid = dictionary["Menuid"] as? String ?? ""
         self.MenuName = dictionary["MenuName"] as? String ?? ""
         self.MenuIcon = dictionary["MenuIcon"] as? String ?? ""
       
       }
    
    
}



