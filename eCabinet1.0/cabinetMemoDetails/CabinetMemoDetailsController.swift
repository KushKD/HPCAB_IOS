//
//  CabinetMemoDetailsController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/18/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

class CabinetMemoDetailsController: UIViewController {
    
    var cellData:CabinetMemo? = nil
    var memoType: String = ""
    //CabinetMemo
    var cabinetMemos = [CabinetMemo]()
    var cabinetMemoDetailsObject = CabinetMemoDetailsObject();
    
    var appUtilities = UtilitiesApp()
    var networkUtility = NetworkUtility()
    let alertService = AlertService();
    var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var globalUserId:String = ""
    var globalRoleId: String = ""
    var globalMappedDepartments: String = ""
    var globalBranchedMapped: String = ""
    
    let mapped_loggedin_key = "IS_LOGGED_IN"
    let designationKey_ = "DESIGNATION"
    let mobileNumberKey_ = "MOBILE_NUMBER"
    let nameKey_ = "NAME"
    let userIdKey_ = "USER_ID"
    let userRoleIdKey_ = "ROLE_ID"
    let mapped_departments_id_key  = "DEPARTMENTS_MAPPED"
    let photo_key = "PHOTO"
    let branchMappedkey_ = "BRANCH_MAPPED"
    
    @IBOutlet weak var pointsOfConsideration: UILabel!
    @IBOutlet weak var additionalInformation: UILabel!
    @IBOutlet weak var ministerIncharge: UILabel!
    @IBOutlet weak var approved_channel: UILabel!
    @IBOutlet weak var cabinet_memo_details: UILabel!
    @IBOutlet weak var proposed_Details: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var secIncharge: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dump(cellData)
        dump(memoType)
        // print(UserDefaults.standard.string(forKey: photo_key)!)
        globalRoleId = UserDefaults.standard.string(forKey: userRoleIdKey_)!
        globalUserId = UserDefaults.standard.string(forKey: userIdKey_)!
        globalMappedDepartments = UserDefaults.standard.string(forKey: mapped_departments_id_key)!
        globalBranchedMapped = UserDefaults.standard.string(forKey: branchMappedkey_)!
        
        print(globalUserId)
        print(globalRoleId)
        print(globalMappedDepartments)
        
    
        
        
        if memoType.caseInsensitiveCompare("Current") == .orderedSame {
            // if (AppStatus.getInstance(CabinetMemoDetailsActivity.this).isOnline()) {
            //Check Internet Pending
            let objectMenu = GetPojo();
            objectMenu.url = Constants.url
            objectMenu.methord = Constants.methordCabinetMemoDetails
            objectMenu.methordHash = (Constants.methordCabinetMemoDetailsToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
            objectMenu.taskType = TaskType.CABINET_MEMOS_DETAILS
            objectMenu.timeStamp = appUtilities.getDate()
            var params2 = [String]()
            params2.append((cellData?.CabinetMemoID.base64Decoded)!);
            params2.append((cellData?.Deptid.base64Decoded)!);
            params2.append(globalUserId);
            params2.append(globalRoleId);

            objectMenu.parametersList = params2
            objectMenu.activityIndicator = self.view

            networkUtility.getDataDialog(GetDataPojo: objectMenu) { response in
                if let response = response {
                    print("are We here")
                    print(response.respnse!)

                    do{
                        //here dataResponse received from a network request

                        let jsonResponse = try  JSONSerialization.jsonObject(with: response.respnse!, options: []) as? [String:AnyObject]
                        print("jsonResponse")

                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
        }else{
            let objectOther = GetPojo();
            objectOther.url = Constants.url
            objectOther.methord = Constants.methordCabinetMemoDetailsOther
            objectOther.methordHash = (Constants.methordCabinetMemoDetailsTokenOther! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
            objectOther.taskType = TaskType.CABINET_MEMOS_DETAILS
            objectOther.timeStamp = appUtilities.getDate()
            var params2 = [String]()
            params2.append((cellData?.CabinetMemoID.base64Decoded)!);
            params2.append((cellData?.Deptid.base64Decoded)!);
            params2.append(globalUserId);
            params2.append(globalRoleId);

            objectOther.parametersList = params2
            objectOther.activityIndicator = self.view

            networkUtility.getDataDialog(GetDataPojo: objectOther) { response in
                if let response = response {

                    print("are We here")
                    print(response.respnse!)

                    do{
                        //here dataResponse received from a network request

                        let jsonResponse = try  JSONSerialization.jsonObject(with: response.respnse!, options: []) as? [String:AnyObject]
                        self.cabinetMemoDetailsObject.AdditionalInformation = jsonResponse!["AdditionalInformation"]! as? String
                        self.cabinetMemoDetailsObject.ApprovalStatus = jsonResponse!["ApprovalStatus"]! as? String
                        self.cabinetMemoDetailsObject.CabinetMemoID = jsonResponse!["CabinetMemoID"]! as? String
                        self.cabinetMemoDetailsObject.DeptName = jsonResponse!["DeptName"]! as? String
                        self.cabinetMemoDetailsObject.Deptid = jsonResponse!["Deptid"]! as? String
                        self.cabinetMemoDetailsObject.FileNo = jsonResponse!["FileNo"]! as? String
                        self.cabinetMemoDetailsObject.MinisterIncharge = jsonResponse!["MinisterIncharge"]! as? String
                        self.cabinetMemoDetailsObject.ProposalDetails = jsonResponse!["ProposalDetails"]! as? String
                        self.cabinetMemoDetailsObject.SecIncharge = jsonResponse!["SecIncharge"]! as? String
                        self.cabinetMemoDetailsObject.StatusCode = jsonResponse!["StatusCode"]! as? Int
                        self.cabinetMemoDetailsObject.Subject = jsonResponse!["Subject"]! as? String
                        self.cabinetMemoDetailsObject.Title = jsonResponse!["Title"]! as? String


                        DispatchQueue.main.async(execute: {
                            //pointsOfConsideration.text =
//                            self.additionalInformation.attributedText = self.cabinetMemoDetailsObject.AdditionalInformation!.htmlAttributedString()
                            
                            self.additionalInformation.attributedText = self.cabinetMemoDetailsObject.AdditionalInformation!.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Poppins", size: 16), csscolor: "#475EAB", lineheight: 3, csstextalign: "left")
                            
                            //myUILabel.attributedText = "Swift is awesome!!!".convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Arial", size: 16), csscolor: "black", lineheight: 5, csstextalign: "center")


                            self.ministerIncharge.text = self.cabinetMemoDetailsObject.MinisterIncharge?.base64Decoded!
                            self.approved_channel.text = "By Cabinet Meeting"

                          //  self.approved_channel.text = self.cabinetMemoDetailsObject.AdditionalInformation.Appr
                            self.cabinet_memo_details.text = self.cabinetMemoDetailsObject.FileNo?.base64Decoded!
                            self.proposed_Details.attributedText = self.cabinetMemoDetailsObject.ProposalDetails!.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Poppins", size: 16), csscolor: "#475EAB", lineheight: 3, csstextalign: "left")
                            self.subject.text = self.cabinetMemoDetailsObject.Subject?.base64Decoded!
                            self.secIncharge.text = self.cabinetMemoDetailsObject.SecIncharge!.base64Decoded!

                        })


                    } catch let parsingError {
                        print("Error", parsingError)
                    }

                }
            }
        }
    }
    
}



