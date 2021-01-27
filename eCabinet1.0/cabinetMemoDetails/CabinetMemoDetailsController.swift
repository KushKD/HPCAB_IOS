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
    
    @IBOutlet weak var departmentName: UILabel!
    var cellData:CabinetMemo? = nil
    var memoType: String = ""
    //CabinetMemo
    var cabinetMemos = [CabinetMemo]()
    var cabinetMemoDetailsObject = CabinetMemoDetailsObject();
    var listAnnuxtures = [ListAnnuxtures]()
    var listCabinetMemoTrackingHistoryLists = [ListCabinetMemoTrackingHistoryLists]()
    var considerationPoints = [ListConsiderationPoints]()
    
    var appUtilities = UtilitiesApp()
    var networkUtility = NetworkUtility()
    let alertService = AlertService();
    var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var globalUserId:String = ""
    var globalRoleId: String = ""
    var globalMappedDepartments: String = ""
    var globalBranchedMapped: String = ""
    var globalPhoneNumber: String = ""
    var globalActionId: String = ""
    var globalSentBackTo: String = ""
    var globalDeptID: String = ""
    var globalBranchID: String = ""
    var globalName:String = ""
    var globalMinisterIncharge:String = ""
    var globalSecretaryIncharge:String = ""
    
    let mapped_loggedin_key = "IS_LOGGED_IN"
    let designationKey_ = "DESIGNATION"
    let mobileNumberKey_ = "MOBILE_NUMBER"
    let nameKey_ = "NAME"
    let userIdKey_ = "USER_ID"
    let userRoleIdKey_ = "ROLE_ID"
    let mapped_departments_id_key  = "DEPARTMENTS_MAPPED"
    let photo_key = "PHOTO"
    let branchMappedkey_ = "BRANCH_MAPPED"
    var pointsconsiderationServer: String = ""
    
    var buttonName  = ""
    
    @IBOutlet weak var head_cabinet_memo_details: UILabel!
    @IBOutlet weak var pointsOfConsideration: UILabel!
    @IBOutlet weak var additionalInformation: UILabel!
    @IBOutlet weak var ministerIncharge: UILabel!
    @IBOutlet weak var approved_channel: UILabel!
    @IBOutlet weak var cabinet_memo_details: UILabel!
    @IBOutlet weak var proposed_Details: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var secIncharge: UILabel!
    @IBOutlet weak var buttonOne: UIStackView!
    @IBOutlet weak var buttonTwo: UIStackView!
    
    @IBOutlet weak var enterRemarksLabel: UILabel!
    @IBOutlet weak var enterRemarksTextView: UITextView!
    
    @IBOutlet weak var sendBack: UIButton!
    @IBOutlet weak var forward: UIButton!
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var otpNumberLabel: UILabel!
    
    @IBOutlet weak var enterOtpLabel: UILabel!
    @IBOutlet weak var enterOtpTextView: UITextView!
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var proceed: UIButton!
    
    @IBOutlet weak var actionChannel: UITextField!
    @IBOutlet weak var sentBackTo: UITextField!
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var SentBackLabel: UILabel!
    
    var pickerViewActions = UIPickerView()
    var pickerViewSentBackTo = UIPickerView()
    
    var tapGesture = UITapGestureRecognizer()
    var tapGestureAttachments = UITapGestureRecognizer()
    var actions = [Actions]()
    var sentBackToData = [SentBack]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewActions.dataSource = self
        pickerViewActions.delegate = self
        actionChannel.inputView = pickerViewActions
        
        pickerViewSentBackTo.dataSource = self
        pickerViewSentBackTo.delegate = self
        sentBackTo.inputView = pickerViewSentBackTo
        
        print("Branch Id Below")
        print(globalBranchID)
        
        
        // print(UserDefaults.standard.string(forKey: photo_key)!)
        globalRoleId = UserDefaults.standard.string(forKey: userRoleIdKey_)!
        globalUserId = UserDefaults.standard.string(forKey: userIdKey_)!
        globalMappedDepartments = UserDefaults.standard.string(forKey: mapped_departments_id_key)!
        globalBranchedMapped = UserDefaults.standard.string(forKey: branchMappedkey_)!
        globalPhoneNumber  = UserDefaults.standard.string(forKey: mobileNumberKey_)!
        globalName = UserDefaults.standard.string(forKey: nameKey_)!
        
        print(globalUserId)
        print(globalRoleId)
        print(globalMappedDepartments)
        print(globalName)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(CabinetMemoDetailsController.history(_:)))
        tapGestureAttachments = UITapGestureRecognizer(target: self, action: #selector(CabinetMemoDetailsController.attachments(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGestureAttachments.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGestureAttachments.numberOfTouchesRequired = 1
        buttonOne.addGestureRecognizer(tapGesture)
        buttonTwo.addGestureRecognizer(tapGestureAttachments)
        buttonOne.isUserInteractionEnabled = true
        buttonTwo.isUserInteractionEnabled = true
        
        // action and sent back
        if Reachability.isConnectedToNetwork(){
            let object = GetPojo();
            object.url = Constants.url
            object.methord = Constants.GetChannelistbyRole
            object.methordHash = (Constants.GetChannelistbyRoleToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
            object.taskType = TaskType.GET_ACTION
            object.timeStamp = appUtilities.getDate()
            var params2 = [String]()
            params2.append(globalRoleId);
            
            object.parametersList = params2
            object.activityIndicator = self.view
            
            
            networkUtility.getDataDialog(GetDataPojo: object) { response in
                if let response = response {
                    print(response.respnse!)
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                        guard let jsonArray = jsonResponse as? [[String: Any]] else {
                            return
                        }
                        do {
                            var model = [Actions]()
                            for dic in jsonArray{
                                model.append(Actions(dic))
                            }
                            self.actions = model;
                            
                        }
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
        }else{
            DispatchQueue.main.async(execute: {
                let alertVC = self.alertService.alert(title: "Network Message", body: Constants.internetNotAvailable!, buttonTitle: "OK")
                { [weak self] in
                    //Go to the Next Story Board
                    
                }
                self.present(alertVC, animated: true)
                
            })
        }
        
        
        
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
                        print(jsonResponse)
                        self.cabinetMemoDetailsObject.AdditionalInformation = jsonResponse!["AdditionalInformation"]! as? String
                        self.cabinetMemoDetailsObject.ApprovalStatus = jsonResponse!["ApprovalStatus"]! as? String
                        self.cabinetMemoDetailsObject.CabinetMemoID = jsonResponse!["CabinetMemoID"]! as? String
                        self.cabinetMemoDetailsObject.DeptName = jsonResponse!["DeptName"]! as? String
                        self.cabinetMemoDetailsObject.Deptid = jsonResponse!["Deptid"]! as? String
                        self.globalDeptID = (self.cabinetMemoDetailsObject.Deptid?.base64Decoded!)!
                        self.cabinetMemoDetailsObject.BranchID = jsonResponse!["BranchID"]! as? String
                        self.cabinetMemoDetailsObject.FileNo = jsonResponse!["FileNo"]! as? String
                        self.cabinetMemoDetailsObject.MinisterIncharge = jsonResponse!["MinisterIncharge"]! as? String
                        self.globalMinisterIncharge = (self.cabinetMemoDetailsObject.MinisterIncharge?.base64Decoded!)!
                        self.cabinetMemoDetailsObject.ProposalDetails = jsonResponse!["ProposalDetails"]! as? String
                        self.cabinetMemoDetailsObject.SecIncharge = jsonResponse!["SecIncharge"]! as? String
                        self.globalSecretaryIncharge = (self.cabinetMemoDetailsObject.SecIncharge?.base64Decoded!)!
                        self.cabinetMemoDetailsObject.StatusCode = jsonResponse!["StatusCode"]! as? Int
                        self.cabinetMemoDetailsObject.Subject = jsonResponse!["Subject"]! as? String
                        self.cabinetMemoDetailsObject.Title = jsonResponse!["Title"]! as? String
                        
                        
                        //Consideration Points
                        if let considerationPointsServer = jsonResponse!["ListConsiderationPoints"]! as? NSArray{
                            do{
                                
                                guard let jsonArray = considerationPointsServer as? [[String: Any]] else {
                                    return
                                }
                                
                                do {
                                    var model = [ListConsiderationPoints]()
                                    for dic in jsonArray{
                                        model.append(ListConsiderationPoints(dic))
                                    }
                                    
                                    self.considerationPoints = model;
                                    print("Consideration Points are:- ")
                                    dump(self.considerationPoints)
                                    
                                    for x in self.considerationPoints {
                                        self.pointsconsiderationServer.append(x.PointNumber.base64Decoded!)
                                        self.pointsconsiderationServer.append("). ")
                                        self.pointsconsiderationServer.append(x.Title.base64Decoded!)
                                        self.pointsconsiderationServer.append("\n")
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                        
                        //List Annexers Points
                        if let ListAnnuxturesServer = jsonResponse!["ListAnnexures"]! as? NSArray{
                            do{
                                
                                guard let jsonArray = ListAnnuxturesServer as? [[String: Any]] else {
                                    return
                                }
                                
                                do {
                                    var model = [ListAnnuxtures]()
                                    for dic in jsonArray{
                                        model.append(ListAnnuxtures(dic))
                                    }
                                    
                                    self.listAnnuxtures = model;
                                    print("ListAnnuxtures Points are:- ")
                                    dump(self.listAnnuxtures)
                                    
                                    
                                    
                                }
                            }
                        }
                        
                        // List ListCabinetMemoTrackingHistoryLists
                        if let serverCabinetMemoHistory = jsonResponse!["ListCabinetMemoTrackingHistoryLists"]! as? NSArray{
                            do{
                                
                                guard let jsonArray = serverCabinetMemoHistory as? [[String: Any]] else {
                                    return
                                }
                                
                                do {
                                    var model = [ListCabinetMemoTrackingHistoryLists]()
                                    for dic in jsonArray{
                                        model.append(ListCabinetMemoTrackingHistoryLists(dic))
                                    }
                                    
                                    self.listCabinetMemoTrackingHistoryLists = model;
                                    print("ListCabinetMemoTrackingHistoryLists Points are:- ")
                                    dump(self.listCabinetMemoTrackingHistoryLists)
                                    
                                }
                            }
                        }
                        
                        DispatchQueue.main.async(execute: {
                            //pointsOfConsideration.text =
                            //                            self.additionalInformation.attributedText = self.cabinetMemoDetailsObject.AdditionalInformation!.htmlAttributedString()
                            
                            self.pointsOfConsideration.text = self.pointsconsiderationServer
                            
                            self.additionalInformation.attributedText = self.cabinetMemoDetailsObject.AdditionalInformation!.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Poppins", size: 14), csscolor: "#545454", lineheight: 3, csstextalign: "left")
                            
                            
                            
                            
                            self.ministerIncharge.text = self.cabinetMemoDetailsObject.MinisterIncharge?.base64Decoded!
                            self.approved_channel.text = "By Cabinet Meeting"
                            
                            //  self.approved_channel.text = self.cabinetMemoDetailsObject.AdditionalInformation.Appr
                            self.cabinet_memo_details.text = self.cabinetMemoDetailsObject.FileNo?.base64Decoded!
                            self.proposed_Details.attributedText = self.cabinetMemoDetailsObject.ProposalDetails!.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Poppins", size: 14), csscolor: "#545454", lineheight: 3, csstextalign: "left")
                            self.subject.text = self.cabinetMemoDetailsObject.Subject?.base64Decoded!
                            self.secIncharge.text = self.cabinetMemoDetailsObject.SecIncharge!.base64Decoded!
                            self.departmentName.text = self.cabinetMemoDetailsObject.DeptName!.base64Decoded!
                            
                            
                            self.actionLabel.isHidden = false
                            self.actionChannel.isHidden = false
                            self.SentBackLabel.isHidden = false
                            self.sentBackTo.isHidden = false
                            self.enterRemarksLabel.isHidden = false
                            self.enterRemarksTextView .isHidden = false
                            self.sendBack.isHidden = false
                            self.forward.isHidden = false
                            self.otpLabel.isHidden = true
                            self.otpNumberLabel.isHidden = true
                            self.enterOtpLabel.isHidden = true
                            self.enterOtpTextView.isHidden = true
                            self.cancel.isHidden = true
                            self.proceed.isHidden = true
                            
                            
                        })
                        
                        
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
                        let jsonResponse = try  JSONSerialization.jsonObject(with: response.respnse!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject]
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
                        
                        //Consideration Points
                        if let considerationPointsServer = jsonResponse!["ListConsiderationPoints"]! as? NSArray{
                            do{
                                
                                guard let jsonArray = considerationPointsServer as? [[String: Any]] else {
                                    return
                                }
                                
                                do {
                                    var model = [ListConsiderationPoints]()
                                    for dic in jsonArray{
                                        model.append(ListConsiderationPoints(dic))
                                    }
                                    
                                    self.considerationPoints = model;
                                    print("Consideration Points are:- ")
                                    dump(self.considerationPoints)
                                    
                                    for x in self.considerationPoints {
                                        self.pointsconsiderationServer.append(x.PointNumber.base64Decoded!)
                                        self.pointsconsiderationServer.append("). ")
                                        self.pointsconsiderationServer.append(x.Title.base64Decoded!)
                                        self.pointsconsiderationServer.append("\n")
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                        
                        //List Annexers Points
                        if let ListAnnuxturesServer = jsonResponse!["ListAnnexures"]! as? NSArray{
                            do{
                                
                                guard let jsonArray = ListAnnuxturesServer as? [[String: Any]] else {
                                    return
                                }
                                
                                do {
                                    var model = [ListAnnuxtures]()
                                    for dic in jsonArray{
                                        model.append(ListAnnuxtures(dic))
                                    }
                                    
                                    self.listAnnuxtures = model;
                                    print("ListAnnuxtures Points are:- ")
                                    dump(self.listAnnuxtures)
                                    
                                    
                                    
                                }
                            }
                        }
                        
                        // List ListCabinetMemoTrackingHistoryLists
                        if let serverCabinetMemoHistory = jsonResponse!["ListCabinetMemoTrackingHistoryLists"]! as? NSArray{
                            do{
                                
                                guard let jsonArray = serverCabinetMemoHistory as? [[String: Any]] else {
                                    return
                                }
                                
                                do {
                                    var model = [ListCabinetMemoTrackingHistoryLists]()
                                    for dic in jsonArray{
                                        model.append(ListCabinetMemoTrackingHistoryLists(dic))
                                    }
                                    
                                    self.listCabinetMemoTrackingHistoryLists = model;
                                    print("ListCabinetMemoTrackingHistoryLists Points are:- ")
                                    dump(self.listCabinetMemoTrackingHistoryLists)
                                    
                                }
                            }
                        }
                        
                        
                        
                        
                        
                        DispatchQueue.main.async(execute: {
                            self.pointsOfConsideration.text = self.pointsconsiderationServer
                            
                            
                            self.additionalInformation.attributedText = self.cabinetMemoDetailsObject.AdditionalInformation!.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Poppins", size: 14), csscolor: "#545454", lineheight: 3, csstextalign: "left")
                            
                            self.ministerIncharge.text = self.cabinetMemoDetailsObject.MinisterIncharge?.base64Decoded!
                            self.approved_channel.text = "By Cabinet Meeting"
                            
                            //  self.approved_channel.text = self.cabinetMemoDetailsObject.AdditionalInformation.Appr
                            self.cabinet_memo_details.text = self.cabinetMemoDetailsObject.FileNo?.base64Decoded!
                            self.proposed_Details.attributedText = self.cabinetMemoDetailsObject.ProposalDetails!.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Poppins", size: 14), csscolor: "#545454", lineheight: 3, csstextalign: "left")
                            self.subject.text = self.cabinetMemoDetailsObject.Subject?.base64Decoded!
                            self.secIncharge.text = self.cabinetMemoDetailsObject.SecIncharge!.base64Decoded!
                            self.departmentName.text = self.cabinetMemoDetailsObject.DeptName!.base64Decoded!
                            
                            
                            self.enterRemarksLabel.isHidden = true
                            self.enterRemarksTextView .isHidden = true
                            self.sendBack.isHidden = true
                            self.forward.isHidden = true
                            self.otpLabel.isHidden = true
                            self.otpNumberLabel.isHidden = true
                            self.enterOtpLabel.isHidden = true
                            self.enterOtpTextView.isHidden = true
                            self.cancel.isHidden = true
                            self.proceed.isHidden = true
                            self.actionLabel.isHidden = true
                            self.actionChannel.isHidden = true
                            self.SentBackLabel.isHidden = true
                            self.sentBackTo.isHidden = true
                            
                            
                        })
                        
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func sendBack(_ sender: Any) {
        
        buttonName = "back"
        if globalRoleId.caseInsensitiveCompare("4") == .orderedSame || globalRoleId.caseInsensitiveCompare("11") == .orderedSame {
            
            if !enterRemarksTextView.text.isEmpty {
                
                self.enterRemarksLabel.isHidden = false
                self.enterRemarksTextView .isHidden = false
                self.sendBack.isHidden = true
                self.forward.isHidden = true
                self.otpLabel.isHidden = false
                self.otpNumberLabel.isHidden = false
                self.enterOtpLabel.isHidden = false
                self.enterOtpTextView.isHidden = false
                self.cancel.isHidden = false
                self.proceed.isHidden = false
                
                
                
                
                
                otpNumberLabel.text = globalPhoneNumber
                //Check Internet
                //Get OTP
                if otpNumberLabel.text!.count == 10{
                    print(otpNumberLabel.text!)
                    
                    let objectUsers = GetPojo();
                    objectUsers.url = Constants.url
                    objectUsers.methord = Constants.methordGetOTP
                    objectUsers.methordHash = (Constants.methordOTPToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectUsers.taskType = TaskType.GET_OTP_VIA_MOBILE
                    objectUsers.timeStamp = appUtilities.getDate()
                    
                    
                    var params = [String]()
                    params.append(otpNumberLabel.text!)
                    params.append(globalUserId)
                    params.append(globalRoleId)
                    
                    objectUsers.parametersList = params
                    objectUsers.activityIndicator = self.view
                    
                    networkUtility.getDataDialog(GetDataPojo: objectUsers) { response in
                        if let response = response {
                            print(response.respnse!)
                            do{
                                //here dataResponse received from a network request
                                
                                let jsonResponse = try  JSONSerialization.jsonObject(with: response.respnse!, options: []) as? [String:AnyObject]
                                print("kush")
                                let statusMessage: String = jsonResponse!["StatusMessage"]! as! String
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    let alertVC = self.alertService.alert(title: "Success?", body: statusMessage.base64Decoded!, buttonTitle: "Confirm")
                                    { [weak self] in
                                        //Functionality of Confirm Button Goes Here
                                    }
                                    self.present(alertVC, animated: true)
                                })
                                
                                
                            } catch let parsingError {
                                print("Error", parsingError)
                            }
                        }
                    }
                }else{
                    let alertVC = self.alertService.alert(title: "Error Message", body: "Please contact the department regarding the Phone number.", buttonTitle: "OK")
                    { [weak self] in
                    }
                    self.present(alertVC, animated: true)
                }
                
                
                
            }else{
                DispatchQueue.main.async(execute: {
                    
                    self.enterRemarksLabel.isHidden = false
                    self.enterRemarksTextView .isHidden = false
                    self.sendBack.isHidden = false
                    self.forward.isHidden = false
                    self.otpLabel.isHidden = true
                    self.otpNumberLabel.isHidden = true
                    self.enterOtpLabel.isHidden = true
                    self.enterOtpTextView.isHidden = true
                    self.cancel.isHidden = true
                    self.proceed.isHidden = true
                    let alertVC = self.alertService.alert(title: "Error Message", body: "Please enter remarks ", buttonTitle: "OK")
                    { [weak self] in
                        
                    }
                    
                    self.present(alertVC, animated: true)
                })
            }
            
            
        }else{
            
            if !enterRemarksTextView.text.isEmpty{
                //Post the Data Directly Kush
                var postObject =  PostObject ()
                postObject.userid = globalUserId
                postObject.cabinetMemoId = cellData?.CabinetMemoID.base64Decoded!
                postObject.roleid = globalRoleId
                postObject.deptId = cellData?.Deptid.base64Decoded!
                postObject.remarks = ""
                postObject.phone = ""
                postObject.otp = ""
                postObject.token = (Constants.methordsendBackCabinetMemoListsToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                
                postObject.PendingWithRoleID=globalSentBackTo
                postObject.UserName=globalName
                postObject.MinisterinCharge=globalMinisterIncharge
                postObject.SecinIncharge = globalSecretaryIncharge
                
                
                let methodName = Constants.url
                let url = Constants.methordsendBackCabinetMemoLists
                var activityIndicator: UIView? =  self.view
                print(postObject)
                
                
                networkUtility.postDataDialog(PostObject: postObject, URL_: url!, methord: methodName!, uiview: activityIndicator!) { response in
                    if let response = response {
                        print(response.responseCode)
                        if response.responseCode == 200{
                            do{
                                // print("success: \(String(describing: response.stringData))")
                                DispatchQueue.main.async(execute: {
                                    
                                    let alertVC = self.alertService.alert(title: "Success Message", body: response.stringData! , buttonTitle: "OK")
                                    { [weak self] in
                                        //Close the Screen
                                        if response.stringData!.caseInsensitiveCompare("\"OK\"") == .orderedSame{
                                            UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                                        }else{
                                            //Do Nothing
                                        }
                                    }
                                    self.present(alertVC, animated: true)
                                })
                                
                                
                                
                            } catch let parsingError {
                                print("Error", parsingError)
                            }
                        }else{
                            // print("success: \(String(describing: response.stringData))")
                            do{
                                DispatchQueue.main.async(execute: {
                                    
                                    let alertVC = self.alertService.alert(title: "Message Faliure", body: response.stringData! , buttonTitle: "OK")
                                    { [weak self] in
                                        //Close the Screen
                                        
                                    }
                                    self.present(alertVC, animated: true)
                                })
                                
                                
                                
                            } catch let parsingError {
                                print("Error", parsingError)
                            }
                        }
                        
                        
                        
                    }
                }
                
                
                
                
            }else{
                let alertVC = self.alertService.alert(title: "Error Message", body: "Please enter remarks ", buttonTitle: "OK")
                { [weak self] in
                }
                self.present(alertVC, animated: true)
            }
        }
    }
    
    @IBAction func forwardToNextLevel(_ sender: Any) {
        
        buttonName = "forward"
        if globalRoleId.caseInsensitiveCompare("4") == .orderedSame || globalRoleId.caseInsensitiveCompare("11") == .orderedSame {
            
            if !enterRemarksTextView.text.isEmpty {
                
                self.enterRemarksLabel.isHidden = false
                self.enterRemarksTextView .isHidden = false
                self.sendBack.isHidden = true
                self.forward.isHidden = true
                self.otpLabel.isHidden = false
                self.otpNumberLabel.isHidden = false
                self.enterOtpLabel.isHidden = false
                self.enterOtpTextView.isHidden = false
                self.cancel.isHidden = false
                self.proceed.isHidden = false
                
                
                
                
                
                otpNumberLabel.text = globalPhoneNumber
                //Check Internet
                //Get OTP
                if otpNumberLabel.text!.count == 10{
                    print(otpNumberLabel.text!)
                    
                    let objectUsers = GetPojo();
                    objectUsers.url = Constants.url
                    objectUsers.methord = Constants.methordGetOTP
                    objectUsers.methordHash = (Constants.methordOTPToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectUsers.taskType = TaskType.GET_OTP_VIA_MOBILE
                    objectUsers.timeStamp = appUtilities.getDate()
                    
                    
                    var params = [String]()
                    params.append(otpNumberLabel.text!)
                    params.append(globalUserId)
                    params.append(globalRoleId)
                    
                    objectUsers.parametersList = params
                    objectUsers.activityIndicator = self.view
                    
                    networkUtility.getDataDialog(GetDataPojo: objectUsers) { response in
                        if let response = response {
                            print(response.respnse!)
                            do{
                                //here dataResponse received from a network request
                                
                                let jsonResponse = try  JSONSerialization.jsonObject(with: response.respnse!, options: []) as? [String:AnyObject]
                                print("kush")
                                let statusMessage: String = jsonResponse!["StatusMessage"]! as! String
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    let alertVC = self.alertService.alert(title: "Success?", body: statusMessage.base64Decoded!, buttonTitle: "Confirm")
                                    { [weak self] in
                                        //Functionality of Confirm Button Goes Here
                                    }
                                    self.present(alertVC, animated: true)
                                })
                                
                                
                            } catch let parsingError {
                                print("Error", parsingError)
                            }
                        }
                    }
                }else{
                    let alertVC = self.alertService.alert(title: "Error Message", body: "Please contact the department regarding the Phone number.", buttonTitle: "OK")
                    { [weak self] in
                    }
                    self.present(alertVC, animated: true)
                }
                
                
                
            }else{
                DispatchQueue.main.async(execute: {
                    
                    self.enterRemarksLabel.isHidden = false
                    self.enterRemarksTextView .isHidden = false
                    self.sendBack.isHidden = false
                    self.forward.isHidden = false
                    self.otpLabel.isHidden = true
                    self.otpNumberLabel.isHidden = true
                    self.enterOtpLabel.isHidden = true
                    self.enterOtpTextView.isHidden = true
                    self.cancel.isHidden = true
                    self.proceed.isHidden = true
                    let alertVC = self.alertService.alert(title: "Error Message", body: "Please enter remarks ", buttonTitle: "OK")
                    { [weak self] in
                        
                    }
                    
                    self.present(alertVC, animated: true)
                })
            }
            
            
        }else{
            
            if !enterRemarksTextView.text.isEmpty{
                //Post the Data Directly Kush
                var postObject =  PostObject ()
                postObject.userid = globalUserId
                postObject.cabinetMemoId = cellData?.CabinetMemoID.base64Decoded!
                postObject.roleid = globalRoleId
                postObject.deptId = cellData?.Deptid.base64Decoded!
                postObject.remarks = ""
                postObject.phone = ""
                postObject.otp = ""
                postObject.token = (Constants.methordForwardCabinetMemoToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                postObject.PendingWithRoleID=globalSentBackTo
                postObject.UserName=globalName
                postObject.MinisterinCharge=globalMinisterIncharge
                postObject.SecinIncharge = globalSecretaryIncharge
                
                print(postObject)
                let methodName = Constants.url
                let url = Constants.methordForwardCabinetMemo
                var activityIndicator: UIView? =  self.view
                
                networkUtility.postDataDialog(PostObject: postObject, URL_: url!, methord: methodName!, uiview: activityIndicator!) { response in
                    if let response = response {
                        print(response.responseCode)
                        if response.responseCode == 200{
                            do{
                                // print("success: \(String(describing: response.stringData))")
                                DispatchQueue.main.async(execute: {
                                    
                                    let alertVC = self.alertService.alert(title: "Success Message", body: response.stringData! , buttonTitle: "OK")
                                    { [weak self] in
                                        //Close the Screen
                                        if response.stringData!.caseInsensitiveCompare("\"OK\"") == .orderedSame{
                                            UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                                        }else{
                                            //Do Nothing
                                        }
                                    }
                                    self.present(alertVC, animated: true)
                                })
                                
                                
                                
                            } catch let parsingError {
                                print("Error", parsingError)
                            }
                        }else{
                            // print("success: \(String(describing: response.stringData))")
                            do{
                                DispatchQueue.main.async(execute: {
                                    
                                    let alertVC = self.alertService.alert(title: "Message Faliure", body: response.stringData! , buttonTitle: "OK")
                                    { [weak self] in
                                        //Close the Screen
                                        
                                    }
                                    self.present(alertVC, animated: true)
                                })
                                
                                
                                
                            } catch let parsingError {
                                print("Error", parsingError)
                            }
                        }
                        
                        
                        
                    }
                }
                
                
                
            }else{
                let alertVC = self.alertService.alert(title: "Error Message", body: "Please enter remarks ", buttonTitle: "OK")
                { [weak self] in
                }
                self.present(alertVC, animated: true)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.otpLabel.isHidden = true
        self.otpNumberLabel.isHidden = true
        self.enterOtpLabel.isHidden = true
        self.enterOtpTextView.isHidden = true
        self.cancel.isHidden = true
        self.proceed.isHidden = true
        self.enterOtpTextView.text = ""
        self.sendBack.isHidden = false
        self.forward.isHidden = false
    }
    
    @IBAction func proceed(_ sender: Any) {
        
        if buttonName.caseInsensitiveCompare("back") == .orderedSame{
            
            //Post the Data Directly Kush
            var postObject =  PostObject ()
            postObject.userid = globalUserId
            postObject.cabinetMemoId = cellData?.CabinetMemoID.base64Decoded!
            postObject.roleid = globalRoleId
            postObject.deptId = cellData?.Deptid.base64Decoded!
            postObject.remarks = enterRemarksTextView.text!
            postObject.phone = globalPhoneNumber
            postObject.otp = enterOtpTextView.text!
            postObject.token = (Constants.methordsendBackCabinetMemoListsToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
            postObject.PendingWithRoleID=globalSentBackTo
            postObject.UserName=globalName
            postObject.MinisterinCharge=globalMinisterIncharge
            postObject.SecinIncharge = globalSecretaryIncharge
            let methodName = Constants.methordsendBackCabinetMemoLists
            let url = Constants.url
            let activityIndicator: UIView? =  self.view
            print(postObject)
            
            
            networkUtility.postDataDialog(PostObject: postObject, URL_: url!, methord: methodName!, uiview: activityIndicator!) { response in
                if let response = response {
                    print(response.responseCode)
                    if response.responseCode == 200{
                        do{
                            // print("success: \(String(describing: response.stringData))")
                            DispatchQueue.main.async(execute: {
                                
                                let alertVC = self.alertService.alert(title: "Success Message", body: response.stringData! , buttonTitle: "OK")
                                { [weak self] in
                                    //Close the Screen
                                    if response.stringData!.caseInsensitiveCompare("\"OK\"") == .orderedSame{
                                        UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                                    }else{
                                        //Do Nothing
                                    }
                                }
                                self.present(alertVC, animated: true)
                            })
                            
                            
                            
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }else{
                        // print("success: \(String(describing: response.stringData))")
                        do{
                            DispatchQueue.main.async(execute: {
                                
                                let alertVC = self.alertService.alert(title: "Message Faliure", body: response.stringData! , buttonTitle: "OK")
                                { [weak self] in
                                    //Close the Screen
                                    
                                }
                                self.present(alertVC, animated: true)
                            })
                            
                            
                            
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }
                    
                    
                    
                }
            }
            
            
            
            
        }else{
            //Post the Data Directly Kush
            var postObject =  PostObject ()
            postObject.userid = globalUserId
            postObject.cabinetMemoId = cellData?.CabinetMemoID.base64Decoded!
            postObject.roleid = globalRoleId
            postObject.deptId = cellData?.Deptid.base64Decoded!
            postObject.remarks = enterRemarksTextView.text!
            postObject.phone = globalPhoneNumber
            postObject.otp = enterOtpTextView.text!
            postObject.token = (Constants.methordForwardCabinetMemoToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
            postObject.PendingWithRoleID=globalSentBackTo
            postObject.UserName=globalName
            postObject.MinisterinCharge=globalMinisterIncharge
            postObject.SecinIncharge = globalSecretaryIncharge
            print(postObject)
            
            let methodName = Constants.methordForwardCabinetMemo
            let url = Constants.url
            let activityIndicator: UIView? =  self.view
            
            networkUtility.postDataDialog(PostObject: postObject, URL_: url!, methord: methodName!, uiview: activityIndicator!) { response in
                if let response = response {
                    print(response.stringData)
                    if response.responseCode == 200{
                        do{
                            // print("success: \(String(describing: response.stringData))")
                            DispatchQueue.main.async(execute: {
                                
                                let alertVC = self.alertService.alert(title: "Success Message", body: response.stringData! , buttonTitle: "OK")
                                { [weak self] in
                                    //Close the Screen
                                    if response.stringData!.caseInsensitiveCompare("\"OK\"") == .orderedSame{
                                        UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                                    }else{
                                        //Do Nothing
                                    }
                                    
                                }
                                self.present(alertVC, animated: true)
                            })
                            
                            
                            
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }else{
                        // print("success: \(String(describing: response.stringData))")
                        do{
                            DispatchQueue.main.async(execute: {
                                
                                let alertVC = self.alertService.alert(title: "Message Faliure", body: response.stringData! , buttonTitle: "OK")
                                { [weak self] in
                                    //Close the Screen
                                    
                                }
                                self.present(alertVC, animated: true)
                            })
                            
                            
                            
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }
                    
                    
                    
                }
            }
        }
    }
    
    
    
    @objc func history(_ sender: UITapGestureRecognizer) {
        
        print("Button Clicked History")
        dump(listCabinetMemoTrackingHistoryLists)
        if listCabinetMemoTrackingHistoryLists.count > 0{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "CabinetHistory", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CabinetHistoryController") as! CabinetHistoryController
            nextViewController.listToShow = listCabinetMemoTrackingHistoryLists
            self.present(nextViewController, animated:true, completion:nil)
            
            
        }else{
            
            DispatchQueue.main.async(execute: {
                let alertVC = self.alertService.alert(title: "Success Message", body: "No Comments Found ", buttonTitle: "OK")
                { [weak self] in
                }
                self.present(alertVC, animated: true)
            })
        }
    }
    
    
    @objc func attachments(_ sender: UITapGestureRecognizer) {
        
        print("Button Clicked attachments")
        dump(listAnnuxtures)
        if listAnnuxtures.count > 0{
            let storyBoard : UIStoryboard = UIStoryboard(name: "MemoAttachments", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MemoAttachmentsController") as! MemoAttachmentsController
            nextViewController.listToShow = listAnnuxtures
            self.present(nextViewController, animated:true, completion:nil)
        }else{
            DispatchQueue.main.async(execute: {
                
                let alertVC = self.alertService.alert(title: "Success Message", body: "No Attachments Found ", buttonTitle: "OK")
                { [weak self] in
                }
                self.present(alertVC, animated: true)
            })
        }
    }
    
    
    
    
}


extension CabinetMemoDetailsController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewActions{
            return actions.count
        }else{
            return sentBackToData.count
        }
    }
        
        
        
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerViewActions{
            return actions[row].StatusCode.base64Decoded
        }else{
            return sentBackToData[row].Name.base64Decoded
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerViewActions{
            actionChannel.text = ""
            actionChannel.text = actions[row].StatusCode.base64Decoded
            actionChannel.resignFirstResponder()
            globalActionId = actions[row].ChannelID.base64Decoded!;
            
            if(actions[row].StatusCode.base64Decoded!.caseInsensitiveCompare("Send Back") == .orderedSame){
                //GEt Sendback Data
                sentBackTo.text = ""
                if Reachability.isConnectedToNetwork(){
                    let object = GetPojo();
                    object.url = Constants.url
                    object.methord = Constants.GetSentBackListsbyDeptBranch
                    object.methordHash = (Constants.GetSentBackListsbyDeptBranchToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    object.taskType = TaskType.SEND_BACK
                    object.timeStamp = appUtilities.getDate()
                    var params2 = [String]()
                    params2.append(globalUserId);
                    params2.append(globalDeptID)
                    params2.append(globalBranchID)
                    params2.append(globalRoleId);
                    params2.append(globalActionId)
                    
                    object.parametersList = params2
                    object.activityIndicator = self.view
                    
                    
                    networkUtility.getDataDialog(GetDataPojo: object) { response in
                        if let response = response {
                            print(response.respnse!)
                            do{
                                let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                    return
                                }
                                do {
                                    var model = [SentBack]()
                                    for dic in jsonArray{
                                        model.append(SentBack(dic))
                                    }
                                    self.sentBackToData = model;
                                    
                                }
                            } catch let parsingError {
                                print("Error", parsingError)
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async(execute: {
                        let alertVC = self.alertService.alert(title: "Network Message", body: Constants.internetNotAvailable!, buttonTitle: "OK")
                        { [weak self] in
                            //Go to the Next Story Board
                            
                        }
                        self.present(alertVC, animated: true)
                        
                    })
                }
            }else{
                //GEt Other Channel Data
                sentBackTo.text = ""
                if Reachability.isConnectedToNetwork(){
                    let object = GetPojo();
                    object.url = Constants.url
                    object.methord = Constants.GetSectListsbyDeptBranch
                    object.methordHash = (Constants.GetSectListsbyDeptBranchToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    object.taskType = TaskType.SEND_BACK
                    object.timeStamp = appUtilities.getDate()
                    var params2 = [String]()
                    params2.append(globalUserId);
                    params2.append(globalDeptID)
                    params2.append(globalBranchID)
                    params2.append(globalRoleId);
                    params2.append(globalActionId)
                    
                    object.parametersList = params2
                    object.activityIndicator = self.view
                    
                    
                    networkUtility.getDataDialog(GetDataPojo: object) { response in
                        if let response = response {
                            print(response.respnse!)
                            do{
                                let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                    return
                                }
                                do {
                                    var model = [SentBack]()
                                    for dic in jsonArray{
                                        model.append(SentBack(dic))
                                    }
                                    self.sentBackToData = model;
                                    
                                }
                            } catch let parsingError {
                                print("Error", parsingError)
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async(execute: {
                        let alertVC = self.alertService.alert(title: "Network Message", body: Constants.internetNotAvailable!, buttonTitle: "OK")
                        { [weak self] in
                            //Go to the Next Story Board
                            
                        }
                        self.present(alertVC, animated: true)
                        
                    })
                }
            }
        
        }else {
            sentBackTo.text = ""
            sentBackTo.text = sentBackToData[row].Name.base64Decoded
            sentBackTo.resignFirstResponder()
            globalSentBackTo = sentBackToData[row].Pendingwithroleid.base64Decoded!;
            print(globalActionId)
            print(globalSentBackTo)
            
        }
    
    }
}
    


