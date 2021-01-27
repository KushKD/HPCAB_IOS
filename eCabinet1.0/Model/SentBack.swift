//
//  SentBack.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 1/27/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation

struct SentBack{
      
    var Pendingwithroleid:String;
    var Name:String
    //var StatusCode:String
    var StatusMessage:String
   
    init(_ dictionary: [String: Any]) {
      self.Pendingwithroleid = dictionary["Pendingwithroleid"] as? String ?? ""
        self.StatusMessage = dictionary["StatusMessage"] as? String ?? ""
        self.Name = dictionary["Name"] as? String ?? ""
    }
}
