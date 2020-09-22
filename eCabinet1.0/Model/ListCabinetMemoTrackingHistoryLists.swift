//
//  ListCabinetMemoTrackingHistoryLists.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/22/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct ListCabinetMemoTrackingHistoryLists{
    
    
    var Action: String
    var Date: String
    var Remarks: String
    
       
         init(_ dictionary: [String: Any]) {
         self.Action = dictionary["Action"] as? String ?? ""
         self.Date = dictionary["Date"] as? String ?? ""
         self.Remarks = dictionary["Remarks"] as? String ?? ""
       
       }
    
    
}
