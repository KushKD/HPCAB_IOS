//
//  CabinetDesicionViewController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/25/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit

class CabinetDesicionViewController: UIViewController {

    @IBOutlet weak var head: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableContent: UITableView!
    
    var dept_id: String = ""
    var param: String = ""
    
    
    
    
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
        
        appUtilities.setHorizontalGradientColor(view: head)
        
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
        
     //Check Internet Pending
     let objectMenu = GetPojo();
     objectMenu.url = Constants.url
     objectMenu.methord = Constants.GetCabinetDecisionbyMeetingDates
     objectMenu.methordHash = (Constants.GetCabinetDecisionbyMeetingDatesToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
     objectMenu.taskType = TaskType.GET_PENDING_MEMO_LIST_CABINET
     objectMenu.timeStamp = appUtilities.getDate()
     var params2 = [String]()
     params2.append(globalUserId)
       params2.append(globalMappedDepartments)
        //branch MApped
        params2.append(globalBranchedMapped)
     params2.append(globalRoleId)
     
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
                     var model = [Dates]()
                     for dic in jsonArray{
                        
                         model.append(Dates(dic))
                         
                        
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
                         self.dates_ = model;
                         dump(self.dates_)
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
    

     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
      
    @IBAction func goBack(_ sender: Any) {
         UIApplication.setRootView(MainViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
    }
    
}



        
        
        
    


 extension CabinetDesicionViewController: UITableViewDelegate, UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dates_.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCabinetDecisions", for: indexPath) as? CustomCabinetDecisionTableCell 
            print(param)
            cell?.commonInit(dates_[indexPath.row], param)
            return cell!
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(dates_[indexPath.row])
            
//            let cabinetViewController = CabinetMemosController.instantiate(from: .CabinetMemos)
//            cabinetViewController.dept_id = dates_[indexPath.row].DepartmentID.base64Decoded!
//            cabinetViewController.param = "CabinetDecisions"
//             UIApplication.setRootView(cabinetViewController)
//
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "CabinetMemosStoryBoard", bundle:nil)
                                 let cabinetMemos = storyBoard.instantiateViewController(withIdentifier: "CabinetMemosController") as! CabinetMemosController
                                            cabinetMemos.dept_id = dates_[indexPath.row].DepartmentID.base64Decoded!
                                                       cabinetMemos.param = "CabinetDecisions"
            
            cabinetMemos.meetingID = dates_[indexPath.row].MeetingID.base64Decoded!
                                 self.present(cabinetMemos, animated:true, completion:nil)

        }
        
    }


//  UIApplication.setRootView(MainViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
