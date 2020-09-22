//
//  ListConsiderationPoints.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/22/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct ListConsiderationPoints{
    
    
    var CabinetMemoID: String
    var ConsiderationPointID: String
    var ConsiderationPtFinalRemarks: String
     var ConsiderationPtFinalStatus: String
     var ConsiderationPtStatus: String
     var PointNumber: String
     var Title: String
    
       
         init(_ dictionary: [String: Any]) {
         self.CabinetMemoID = dictionary["CabinetMemoID"] as? String ?? ""
         self.ConsiderationPointID = dictionary["ConsiderationPointID"] as? String ?? ""
         self.ConsiderationPtFinalRemarks = dictionary["ConsiderationPtFinalRemarks"] as? String ?? ""
            self.ConsiderationPtFinalStatus = dictionary["ConsiderationPtFinalStatus"] as? String ?? ""
            self.ConsiderationPtStatus = dictionary["ConsiderationPtStatus"] as? String ?? ""
            self.PointNumber = dictionary["PointNumber"] as? String ?? ""
            self.Title = dictionary["Title"] as? String ?? ""
       
       }
    
    
}
