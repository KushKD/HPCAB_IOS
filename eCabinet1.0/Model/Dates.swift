//
//  Dates.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/25/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation


struct Dates{
    
    var FileNo: String
    var MeetingDate: String
    var MeetingDateTime: String
    var MeetingID: String
    var MeetingStatus: String
    var MeetingTime: String
    var Status: String
    var StatusCode: String
    var StatusMessage: String
    var VenueID: String
    var VenueName: String
    
    
    init(_ dictionary: [String: Any]) {
        self.FileNo = dictionary["FileNo"] as? String ?? ""
        self.MeetingDate = dictionary["MeetingDate"] as? String ?? ""
        self.MeetingDateTime = dictionary["MeetingDateTime"] as? String ?? ""
        self.MeetingID = dictionary["MeetingID"] as? String ?? ""
        self.MeetingStatus = dictionary["MeetingStatus"] as? String ?? ""
        self.MeetingTime = dictionary["MeetingTime"] as? String ?? ""
        self.Status = dictionary["Status"] as? String ?? ""
        self.StatusCode = dictionary["StatusCode"] as? String ?? ""
        self.StatusMessage = dictionary["StatusMessage"] as? String ?? ""
        self.VenueID = dictionary["VenueID"] as? String ?? ""
        self.VenueName = dictionary["VenueName"] as? String ?? ""
        
    }
    
    
}

