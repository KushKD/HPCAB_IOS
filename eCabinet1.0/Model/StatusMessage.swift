//
//  StatusMessage.swift
//  eCabinet
//
//  Created by HP-DIT on 9/9/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct StatusMessage{
    
    var StatusMessage: String
   // var StatusCode: String
    
       
         init(_ dictionary: [String: Any]) {
         self.StatusMessage = dictionary["StatusMessage"] as? String ?? ""
        // self.StatusCode = dictionary["StatusCode"] as? String ?? ""
       
       }
    
    
}
