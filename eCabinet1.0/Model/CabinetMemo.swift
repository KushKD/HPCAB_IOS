//
//  CabinetMemo.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/17/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct CabinetMemo{
    
    var AdditionalInformation: String
    var AgendaItemNo: String
    var AgendaItemType: String
    var ApprovalStatus: String
    var CabinetMemoID: String
    var DeptName: String
    var Deptid: String
    var FileNo: String
    var ListAdvisoryDepartments: String
    var Meetingdate: String
    var MemoStatus: String
    var MinisterIncharge: String
    var ProposalDetails: String
    var SecIncharge: String
    var Subject: String
    var Date: String
    var StatusMessage: String
    var CabinetMemoType: String
    var BranchId: String;
    var Currentlywith: String;
    var ForwardedOnDated: String;
    
       
         init(_ dictionary: [String: Any]) {
         self.AdditionalInformation = dictionary["AdditionalInformation"] as? String ?? ""
         self.AgendaItemNo = dictionary["AgendaItemNo"] as? String ?? ""
         self.AgendaItemType = dictionary["AgendaItemType"] as? String ?? ""
         self.ApprovalStatus = dictionary["ApprovalStatus"] as? String ?? ""
            self.CabinetMemoID = dictionary["CabinetMemoID"] as? String ?? ""
            self.DeptName = dictionary["DeptName"] as? String ?? ""
            self.Deptid = dictionary["Deptid"] as? String ?? ""
            self.FileNo = dictionary["FileNo"] as? String ?? ""
            self.ListAdvisoryDepartments = dictionary["ListAdvisoryDepartments"] as? String ?? ""
            self.Meetingdate = dictionary["Meetingdate"] as? String ?? ""
            self.MemoStatus = dictionary["MemoStatus"] as? String ?? ""
              self.MinisterIncharge = dictionary["MinisterIncharge"] as? String ?? ""
              self.ProposalDetails = dictionary["ProposalDetails"] as? String ?? ""
              self.SecIncharge = dictionary["SecIncharge"] as? String ?? ""
              self.Subject = dictionary["Subject"] as? String ?? ""
              self.Date = dictionary["Date"] as? String ?? ""
              self.StatusMessage = dictionary["StatusMessage"] as? String ?? ""
            self.CabinetMemoType = ""
            self.BranchId = dictionary["BranchID"] as? String ?? ""
            self.Currentlywith = dictionary["Currentlywith"] as? String ?? ""
            self.ForwardedOnDated = dictionary["ForwardedOnDated"] as? String ?? ""
       
       }
    
    
}



