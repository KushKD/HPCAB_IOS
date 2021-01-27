//
//  Actions.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 1/27/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation

struct Actions{
      
    var ChannelID: String
   
    var StatusCode: String
   
    init(_ dictionary: [String: Any]) {
      self.ChannelID = dictionary["ChannelID"] as? String ?? ""
        self.StatusCode = dictionary["Channel"] as? String ?? ""
    }
}

