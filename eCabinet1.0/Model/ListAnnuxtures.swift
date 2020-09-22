//
//  ListAnnuxtures.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/22/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct ListAnnuxtures{
    
   
       
    
    var AnnexureID: String
    var AnnexureName: String
    var Attachment: String
    var CabinetMemoID: String
     var Title: String
    
       
         init(_ dictionary: [String: Any]) {
         self.AnnexureID = dictionary["AnnexureID"] as? String ?? ""
         self.AnnexureName = dictionary["AnnexureName"] as? String ?? ""
         self.Attachment = dictionary["Attachment"] as? String ?? ""
             self.CabinetMemoID = dictionary["CabinetMemoID"] as? String ?? ""
             self.Title = dictionary["Title"] as? String ?? ""
       
       }
    
    
}
