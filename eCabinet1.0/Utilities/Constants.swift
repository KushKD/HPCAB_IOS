//
//  Constants.swift
//  eCabinet
//
//  Created by HP-DIT on 9/8/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

struct Constants{
    
    //URL Staging
    static let  url:String? = "http://164.100.138.114/eCabinetService.svc";
    
    //URL Production
     // static let url:String? = "http://ecabinetwcf.hp.gov.in/eCabinetService.svc";
    
    static let  delemeter:String? = "/";
    static let  seperator:String? = "#";
    
    static let  methordGetRoles:String? = "GetRole";
    static let  methordGetRolesToken:String? = "UFG776888a314e7421e7e12f5cfuhuu081f0";
    
    static let  methordDepartmentsViaRoles:String? = "GetMappedDepartmentsListByUserRole";
    static let  methordDepartmentsToken:String? = "klhkhughiknbv12f5cf7171081a0dddss";
    
    // public static final String methordGetDepartments="DepartmentsList";
    // public static final String methordGetDepartmentsToken="aaccaa314e7421e7e12f5cf7171081rr";
    
    static let  methordBranchesViaDept:String? = "GetBranchDetails";
    static let  methordBranchesToken:String? = "ckhijjkkjjhjdddii990001e7e12f5cf71710";
    
    static let  methordUsers:String? = "GetUserRegistration";
    static let  methordUsersToken:String? = "KKuuugghgjhjjdd888898hiuh710";
    
    static let  methordGetOTP:String? = "LoginOTP";
    static let  methordOTPToken:String? = "dff89999a314e7421e7e12f5cf7171081f0";
    
    static let  methordLogin:String? = "Login";
    static let  methordLoginToken:String? = "daccaa314e7421e7e12f5cf7171081a0";
    
    static let  getDepartmentsViaRoles:String? = "DepartmentsListByRole";
    static let  getDepartmentsViaRolesToken:String? = "ccaa314e7421e7e12f5cf7171081a0ddd";
    
    static let  methordMenuList:String? = "GetMenuList";
    static let  methordMenuListToken:String? = "KKdd33444444444frrrr1081a0";
    
    static let  methordGetOnlineCabinetIDMeetingStatus:String? = "ActiveCabinetMemoDuringMeeting";
    static let  methordGetOnlineCabinetIDMeetingToken:String? = "ddddaccssaa314e7421e7e12f5cf7171081arrr";
    
    static let  methordPublishedMeetingDatesListByRole:String? = "PublishedMeetingDatesListByRole";
    static let  methordPublishedMeetingDatesListByRoleToken:String? = "da314e7421e7e12f5cf7171081a0ddd";
    
    static let  methordFinalMeetingAgendaList:String? = "FinalMeetingAgendalist";
    static let   methordFinalMeetingAgendaListToken:String? = "khjlhifutrdfgf2344hhyi666issdfddd345";
    
    static let  methordCabinetMemoListByRole:String? = "CabinetMemoListByRole";
    static let  methordCabinetMemoListByToken :String? = "dsssaccaa314e7421e7e12f5cf7171081a0ss";
    
    static let  methordCabinetMemoDetails:String? = "CabinetMemoDetails";
    static let  methordCabinetMemoDetailsToken:String? = "wwwdaccaa314e7421e7e12f5cf7171081a0ss";
    
    static let  methordsendBackCabinetMemoLists:String? = "SentBackCabinetMemo";
    static let  methordsendBackCabinetMemoListsToken:String? = "ttttdaccaa314e7421e7e12f5cf7171081a0fff";
    
    static let  methordForwardCabinetMemo:String? = "ForwardCabinetMemo";
    static let  methordForwardCabinetMemoToken:String? = "hhhdaccaa314e7421e7e12f5cf7171081a0fff";
    
    static let  methordForwardedCabinetMemoListByRole:String? = "ForwardedCabinetMemoListByRole";
    static let  methordForwardedCabinetMemoListByRoleToken:String? = "ssdaccaa314e7421e7e12f5cf7171081a0ss";
    
    static let  methordSentBackCabinetMemoListByRole:String? = "SentBackCabinetMemoListByRole";
    static let  methordSentBackCabinetMemoListByRoleToken:String? = "daddccaa314e7421e7e12f5cf7171081a0ss";
    
    static let  methordCabinetMemoDetailsOther:String? = "CabinetFSMemoDetails";
    static let  methordCabinetMemoDetailsTokenOther :String? = "YYjj098979YTHKKDRGGGGHHHH";
    
    static let  methordAllowedCabinetMemo:String? = "AllowedCabinetMemo";
    static let  methordAllowedCabinetMemoToken:String? = "ghsssaccaa314e7421e7e12f5cf0sseeddd";
    
   // METHOD SIGNATURE: PlaceinCabinetagendalists/{Token}/{DeptID}/{UserID}/{RoleID}/{LoginDeptID}
   // TOKEN: ssdaccaa314e7421e7e12f5cf7171081a0ss
    
    static let PlaceinCabinetagendalists: String? = "PlaceinCabinetagendalists"
    static let PlaceinCabinetagendalistsToken: String? = "ssdaccaa314e7421e7e12f5cf7171081a0ss"
    
    //GetClosedMeetingDates_API Token,Role
    static let GetClosedMeetingDates_API: String? = "GetClosedMeetingDates_API"
    static let GetClosedMeetingDates_API_TOKEN: String? = "da314e7421e7e12f5cf7171081a0ddd"
    
    //GetCabinetDecisionbyMeetingDates
    static let GetCabinetDecisionbyMeetingDates: String? = "GetCabinetDecisionbyMeetingDates"
       static let GetCabinetDecisionbyMeetingDatesToken: String? = "da314e7421e7e12f5cf7171081a0ddd"
    
    //CabinetDecisionlists/{Token}/{DeptID}/{UserID}/{RoleID}/{LoginDeptID}/{Meetingid}
    static let CabinetDecisionlists: String? = "CabinetDecisionlists"
       static let CabinetDecisionlistsToken: String? = "69FBBF62A31CBC7C761B0AB96696C9EB"
    
    static let   success:String? = "SUCCESS";
    static let   failure:String? = "FAILURE";
    
    let successFailure:String? ;
    let responseCode:String?;
    let respnse:String?;
    
    static let internetNotAvailable: String? = "Internet Not Available. Please Connect to Internet and try again."
    
    
    
    
    
}
