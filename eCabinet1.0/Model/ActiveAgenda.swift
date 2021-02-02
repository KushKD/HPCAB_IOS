//
//  ActiveAgenda.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 1/29/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation

struct ActiveAgenda{
      
    var AgendaItemNo:String;
    var AgendaItemType:String
    var DeptName:String
    var FileNo:String
    var Subject: String
   
    init(_ dictionary: [String: Any]) {
      self.AgendaItemNo = dictionary["AgendaItemNo"] as? String ?? ""
        self.AgendaItemType = dictionary["AgendaItemType"] as? String ?? ""
        self.DeptName = dictionary["DeptName"] as? String ?? ""
        self.FileNo = dictionary["FileNo"] as? String ?? ""
        self.Subject = dictionary["Subject"] as? String ?? ""
    }
}
