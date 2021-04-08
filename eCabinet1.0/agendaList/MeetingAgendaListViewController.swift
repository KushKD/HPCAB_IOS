//
//  MeetingAgendaListViewController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 4/7/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

class MeetingAgendaListViewController: UIViewController {
    
    var dept_id: String = ""
    var param: String = ""
    
    @IBOutlet weak var datesPicker: UITextView!
    var deptIDPickerView: String = "0"
   
    @IBOutlet weak var table: UITableView!
    var globalRoleID: String = ""
    var globalUserID: String = ""
    //CabinetMemo
    var cabinetMemos = [CabinetMemo]()
    
    var pickerViewDepartments = UIPickerView()
    var dates = [Dates]()
    
    let alertService = AlertService();
    var appUtilities = UtilitiesApp();
    var networkUtility = NetworkUtility()
    let activeAgendaDialogController = ActiveAgendaDialogController();
    var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        table.delegate = self
        table.dataSource = self
        let nib = UINib.init(nibName: "FinalAgendaList", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "AgendaListFinalCell")
        
        pickerViewDepartments.delegate = self
        pickerViewDepartments.dataSource = self
        datesPicker.inputView = pickerViewDepartments
        datesPicker.inputView = pickerViewDepartments
        datesPicker.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
        datesPicker.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0);
        
        
        let mapped_loggedin_key = "IS_LOGGED_IN"
        let designationKey_ = "DESIGNATION"
        let mobileNumberKey_ = "MOBILE_NUMBER"
        let nameKey_ = "NAME"
        let userIdKey_ = "USER_ID"
        let userRoleIdKey_ = "ROLE_ID"
        let mapped_departments_id_key  = "DEPARTMENTS_MAPPED"
        let photo_key = "PHOTO"
        
        globalRoleID = UserDefaults.standard.string(forKey: userRoleIdKey_)!
        globalUserID = UserDefaults.standard.string(forKey: userIdKey_)!
        
        if Reachability.isConnectedToNetwork(){
            let object = GetPojo();
            object.url = Constants.url
            object.methord = Constants.methordPublishedMeetingDatesListByRole
            object.methordHash = (Constants.methordPublishedMeetingDatesListByRoleToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
            object.taskType = TaskType.GET_PUBLISHED_MEETING_ID_BY_ROLE
            object.timeStamp = appUtilities.getDate()
            var params = [String]()
          //  params.append(globalUserID)
            params.append(globalRoleID)
            
            object.parametersList = params
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
                            
                           // let departments_first = Dates(["DeptId":"MA==","DeptName":"QWxs"])
                            
                            var model = [Dates]()
                           // model.append(departments_first)
                            for dic in jsonArray{
                                model.append(Dates(dic))
                            }
                            dump(model)
                            
                            self.dates = model;
                            
                            
                        }
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
        }
        else{
            DispatchQueue.main.async(execute: {
                let alertVC = self.alertService.alert(title: "Network Message", body: Constants.internetNotAvailable!, buttonTitle: "OK")
                { [weak self] in
                    //Go to the Next Story Board
                    
                }
                self.present(alertVC, animated: true)
                
            })
        }
        
        
        
        
        
        pickerViewDepartments.selectRow(1, inComponent: 0, animated: true)
        
    }
    
  
    
    @IBAction func back(_ sender: Any) {
        
        UIApplication.setRootView(MainViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
    }
}

extension MeetingAgendaListViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return dates[row].MeetingDate.base64Decoded
        
        
    }
    
    
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        datesPicker.text = dates[row].MeetingDate.base64Decoded
        datesPicker.resignFirstResponder()
        print(dates[row].MeetingDate.base64Decoded!)
        print(dates[row].MeetingID.base64Decoded!)
        deptIDPickerView = dates[row].MeetingID.base64Decoded!
        
        
        /**
                Call Service Here
         */
    
        if Reachability.isConnectedToNetwork(){
            let objectMenu = GetPojo();
            objectMenu.url = Constants.url
            objectMenu.methord = Constants.methordFinalMeetingAgendaList
            objectMenu.methordHash = (Constants.methordFinalMeetingAgendaListToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
            objectMenu.taskType = TaskType.FINAL_MEETING_AGENDA_LIST
            objectMenu.timeStamp = appUtilities.getDate()
            var params2 = [String]()
           
            params2.append(dates[row].MeetingID.base64Decoded!)  // Meeting Id
            params2.append(globalRoleID)
           
            objectMenu.parametersList = params2
            objectMenu.activityIndicator = self.view
            
            networkUtility.getDataDialog(GetDataPojo: objectMenu) { response in
                if let response = response {
                    print(response.respnse!)
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                        guard let jsonArray = jsonResponse as? [[String: Any]] else {
                            return
                        }
                        
                        do {
                            var model = [CabinetMemo]()
                            for dic in jsonArray{
                                
                                model.append(CabinetMemo(dic))
                                
                                
                            }
                            
                            if model[0].StatusMessage.base64Decoded!.caseInsensitiveCompare("No Record Found") == .orderedSame{
                                DispatchQueue.main.async(execute: {
                                    
                                    let alertVC = self.alertService.alert(title: "Success Message", body: "No Record Found", buttonTitle: "OK")
                                    { [weak self] in
                                        //Go to the Next Story Board
                                        UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                                       // self?.table.reloadData()
                                        //DispatchQueue.main.async {
                                         //   self?.table.reloadData()
                                       // }
                                    }
                                    self.present(alertVC, animated: true)
                                })
                            }else{
                                self.cabinetMemos = model;
                                dump(self.cabinetMemos)
                                DispatchQueue.main.async {
                                    self.table.reloadData()  
                                }
                            }
                            
                            
                        }
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
        }
        else{
            DispatchQueue.main.async(execute: {
                let alertVC = self.alertService.alert(title: "Network Message", body: Constants.internetNotAvailable!, buttonTitle: "OK")
                { [weak self] in
                    //Go to the Next Story Board
                     UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                   
                }
                self.present(alertVC, animated: true)
                
            })
        }
        
    }
    
    
}


extension MeetingAgendaListViewController: UITableViewDelegate, UITableViewDataSource{
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cabinetMemos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaListFinalCell", for: indexPath) as? ViewSwiftController
        cell?.backgroundColor = appUtilities.hexStringToUIColor(hex: "#FFFFFF")
        cell?.layer.cornerRadius = 5
        cell?.layer.borderWidth = 0.5
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.backgroundColor = UIColor.white.cgColor
        cell?.layer.shadowColor = UIColor.gray.cgColor
        cell?.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        cell?.layer.shadowRadius = 0.5  //2.0
        cell?.layer.shadowOpacity = 0.5
        cell?.commonInit(cabinetMemos[indexPath.row], param)
        return cell!
    }
    
    func table(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
//        if Reachability.isConnectedToNetwork(){
//            let storyBoard : UIStoryboard = UIStoryboard(name: "CabinetMemoDetailsStoryBoard", bundle:nil)
//                       let cabinetMemoDetailsController = storyBoard.instantiateViewController(withIdentifier: "CabinetMemoDetailsController") as! CabinetMemoDetailsController
//            //Earlier Working
//             cabinetMemoDetailsController.cellData = cabinetMemos[indexPath.row]
//                       cabinetMemoDetailsController.memoType = param
//            cabinetMemoDetailsController.globalBranchID = cabinetMemos[indexPath.row].BranchId.base64Decoded!
//                       self.present(cabinetMemoDetailsController, animated:true, completion:nil)
//        }
//        else{
//                     DispatchQueue.main.async(execute: {
//                    let alertVC = self.alertService.alert(title: "Network Message", body: Constants.internetNotAvailable!, buttonTitle: "OK")
//                                                   { [weak self] in
//                                                       //Go to the Next Story Board
//
//                                                   }
//                                                   self.present(alertVC, animated: true)
//
//                })
//                }
    }
    
}
