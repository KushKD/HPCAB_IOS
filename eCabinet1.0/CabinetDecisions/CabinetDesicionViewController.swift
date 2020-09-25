//
//  CabinetDesicionViewController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/25/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit

class CabinetDesicionViewController: UIViewController {

    @IBOutlet weak var datesSelection: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableContent: UITableView!
    
    var dept_id: String = ""
           var param: String = ""
    
    
    
    //Dates
    
      var pickerViewDates = UIPickerView()
    
    var appUtilities = UtilitiesApp()
    var networkUtility =  NetworkUtility()
    var dates_ = [Dates]()
    //CabinetMemo
    var cabinetMemos = [CabinetMemo]()
      let alertService = AlertService();
    
    let mapped_loggedin_key = "IS_LOGGED_IN"
           let designationKey_ = "DESIGNATION"
           let mobileNumberKey_ = "MOBILE_NUMBER"
           let nameKey_ = "NAME"
           let userIdKey_ = "USER_ID"
           let userRoleIdKey_ = "ROLE_ID"
           let mapped_departments_id_key  = "DEPARTMENTS_MAPPED"
           let photo_key = "PHOTO"
           let branchMappedkey_ = "BRANCH_MAPPED"
    
    var globalUserId:String = ""
           var globalRoleId: String = ""
           var globalMappedDepartments: String = ""
           var globalBranchedMapped: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewDates.dataSource = self
              pickerViewDates.delegate = self
              datesSelection.inputView = pickerViewDates
         datesSelection.textAlignment = .center
        
        tableContent.delegate = self
        tableContent.dataSource = self
        let nib = UINib.init(nibName: "CustomCabinetDecisionTableCell", bundle: nil)
        tableContent.register(nib, forCellReuseIdentifier: "tableCabinetDecisions")
        
                   print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))
                   print(UserDefaults.standard.string(forKey: mobileNumberKey_)!)
                   print(UserDefaults.standard.string(forKey: nameKey_)!)
                   print(UserDefaults.standard.string(forKey: userIdKey_)!)
                   print(UserDefaults.standard.string(forKey: designationKey_)!)
                   print(UserDefaults.standard.string(forKey: userRoleIdKey_)!)
                   print(UserDefaults.standard.string(forKey: mapped_departments_id_key)!)
                   // print(UserDefaults.standard.string(forKey: photo_key)!)
                   globalRoleId = UserDefaults.standard.string(forKey: userRoleIdKey_)!
                   globalUserId = UserDefaults.standard.string(forKey: userIdKey_)!
        globalMappedDepartments = UserDefaults.standard.string(forKey: mapped_departments_id_key)!
                   globalBranchedMapped = UserDefaults.standard.string(forKey: branchMappedkey_)!

        // Do any additional setup after loading the view.
        
        let object = GetPojo();
               object.url = Constants.url
               object.methord = Constants.GetClosedMeetingDates_API
        object.methordHash = (Constants.GetClosedMeetingDates_API_TOKEN! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
               object.taskType = TaskType.GET_DATES
               object.timeStamp = appUtilities.getDate()
               var params2 = [String]()
                          params2.append(globalRoleId)
                          
                          object.parametersList = params2
                          object.activityIndicator = self.view
               
               //ViewControllerUtils().showActivityIndicator(uiView: object.viewController!)
               
               networkUtility.getDataDialog(GetDataPojo: object) { response in
                   //            DispatchQueue.main.async(execute: {
                   //                          ViewControllerUtils().hideActivityIndicator(uiView: object.viewController!)
                   //                      })
                   if let response = response {
                       print(response.respnse!)
                       do{
                           let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                           guard let jsonArray = jsonResponse as? [[String: Any]] else {
                               return
                           }
                           do {
                               var model = [Dates]()
                               for dic in jsonArray{
                                   model.append(Dates(dic))
                               }
                               self.dates_ = model;
                               
                           }
                       } catch let parsingError {
                           print("Error", parsingError)
                       }
                   }
               }
    }
    

     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
      
    @IBAction func goBack(_ sender: Any) {
         UIApplication.setRootView(MainViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
    }
    
}


extension CabinetDesicionViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dates_.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return dates_[row].MeetingDate.base64Decoded
        
        
    }
    
    
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        datesSelection.text = dates_[row].MeetingDate.base64Decoded
        datesSelection.resignFirstResponder()
        print(dates_[row].MeetingDate.base64Decoded!)
        print(dates_[row].MeetingID.base64Decoded!)
       // datesSelection = dates_[row].MeetingID.base64Decoded!
        
        //Check Internet Pending
                       let objectMenu = GetPojo();
                       objectMenu.url = Constants.url
                       objectMenu.methord = Constants.CabinetDecisionlists
                       objectMenu.methordHash = (Constants.CabinetDecisionlistsToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                       objectMenu.taskType = TaskType.GET_PENDING_MEMO_LIST_CABINET
                       objectMenu.timeStamp = appUtilities.getDate()
                       var params2 = [String]()
                       params2.append(dept_id)
                       params2.append(globalUserId)
                       params2.append(globalRoleId)
                       params2.append(globalMappedDepartments)
                       params2.append(dates_[row].MeetingID.base64Decoded!)
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
                                               }
                                               self.present(alertVC, animated: true)
                                           })
                                       }else{
                                           self.cabinetMemos = model;
                                           dump(self.cabinetMemos)
                                           DispatchQueue.main.async {
                                               self.tableContent.reloadData()
                                           }
                                       }
                                       
                                       
                                   }
                               } catch let parsingError {
                                   print("Error", parsingError)
                               }
                           }
                       }
        
    }
    
    
}


 extension CabinetDesicionViewController: UITableViewDelegate, UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cabinetMemos.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCabinetDecisions", for: indexPath) as? CustomCabinetDecisionTableCell 
            print(param)
            cell?.commonInit(cabinetMemos[indexPath.row], param)
            return cell!
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(cabinetMemos[indexPath.row])
//            let cabinetMemoDetailsController = CabinetMemoDetailsController.instantiate(from: .CabinetMemoDetials)
//            cabinetMemoDetailsController.cellData = cabinetMemos[indexPath.row]
//            cabinetMemoDetailsController.memoType = param
//            UIApplication.setRootView(cabinetMemoDetailsController)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "CabinetMemoDetailsStoryBoard", bundle:nil)
                       let cabinetMemoDetailsController = storyBoard.instantiateViewController(withIdentifier: "CabinetMemoDetailsController") as! CabinetMemoDetailsController
                                  cabinetMemoDetailsController.cellData = cabinetMemos[indexPath.row]
                                   cabinetMemoDetailsController.memoType = param
                       self.present(cabinetMemoDetailsController, animated:true, completion:nil)
        }
        
    }


//  UIApplication.setRootView(MainViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
