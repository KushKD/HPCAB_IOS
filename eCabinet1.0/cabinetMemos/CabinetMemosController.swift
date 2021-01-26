    //
    //  CabinetMemosController.swift
    //  eCabinet1.0
    //
    //  Created by HP-DIT on 9/14/20.
    //  Copyright © 2020 HP-DIT. All rights reserved.
    //
    
    import UIKit
    
    class CabinetMemosController: UIViewController {
        
        /*
         Current
         Forwarded
         Backwarded
         getAgenda
         allowedCabinetMemos
         FinalAgendaList
         */
        
        @IBOutlet weak var head: UIView!
        @IBOutlet weak var headingView: UILabel!
        @IBOutlet weak var heading: UILabel!
        @IBOutlet weak var back: UIButton!
        @IBOutlet weak var tableView: UITableView!
        var dept_id: String = ""
        var param: String = ""
        var meetingID : String = ""
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
        
        
        //CabinetMemo
        var cabinetMemos = [CabinetMemo]()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            appUtilities.setHorizontalGradientColor(view: self.head)
            
            // print(UserDefaults.standard.string(forKey: photo_key)!)
            globalRoleId = UserDefaults.standard.string(forKey: userRoleIdKey_)!
            globalUserId = UserDefaults.standard.string(forKey: userIdKey_)!
            globalMappedDepartments = UserDefaults.standard.string(forKey: mapped_departments_id_key)!
            globalBranchedMapped = UserDefaults.standard.string(forKey: branchMappedkey_)!
            
            
            
            if param.caseInsensitiveCompare("Backwarded") == .orderedSame {
                headingView.text = "Sent Back Memos"
            }else  if param.caseInsensitiveCompare("Forwarded") == .orderedSame{
                headingView.text = "Forwarded Cabinet Memos"
            }else  if param.caseInsensitiveCompare("Current") == .orderedSame{
                headingView.text = "Current Memos"
                
            }else  if param.caseInsensitiveCompare("PlacedInCabinet") == .orderedSame{
                headingView.text = "Memos Placed In Cabinet"
                
            }//CabinetDecisions
            else if param.caseInsensitiveCompare("CabinetDecisions") == .orderedSame{
                headingView.text = "Cabinet Decisions (Department Wise)"
            }
            
            
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib.init(nibName: "CustomTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "tableCellMemos")
            
            if param.caseInsensitiveCompare("Forwarded") == .orderedSame {
                
                if Reachability.isConnectedToNetwork(){
                    let objectMenu = GetPojo();
                    objectMenu.url = Constants.url
                    objectMenu.methord = Constants.methordForwardedCabinetMemoListByRole
                    objectMenu.methordHash = (Constants.methordForwardedCabinetMemoListByRoleToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectMenu.taskType = TaskType.GET_PENDING_MEMO_LIST_CABINET
                    objectMenu.timeStamp = appUtilities.getDate()
                    var params2 = [String]()
                    params2.append(dept_id)
                    params2.append(globalUserId)
                    params2.append(globalRoleId)
                    params2.append(globalMappedDepartments)
                    params2.append(globalBranchedMapped)
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
                                            self.tableView.reloadData()
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
                
                
                
                
            } else if param.caseInsensitiveCompare("Backwarded") == .orderedSame {
                
                if Reachability.isConnectedToNetwork(){
                    let objectMenu = GetPojo();
                    objectMenu.url = Constants.url
                    objectMenu.methord = Constants.methordSentBackCabinetMemoListByRole
                    objectMenu.methordHash = (Constants.methordSentBackCabinetMemoListByRoleToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectMenu.taskType = TaskType.GET_PENDING_MEMO_LIST_CABINET
                    objectMenu.timeStamp = appUtilities.getDate()
                    var params2 = [String]()
                    params2.append(dept_id)
                    params2.append(globalUserId)
                    params2.append(globalRoleId)
                    params2.append(globalMappedDepartments)
                    params2.append(globalBranchedMapped)
                    
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
                                            self.tableView.reloadData()
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
            else if param.caseInsensitiveCompare("PlacedInCabinet") == .orderedSame {
                
                if Reachability.isConnectedToNetwork(){
                    let objectMenu = GetPojo();
                    objectMenu.url = Constants.url
                    objectMenu.methord = Constants.PlaceinCabinetagendalists
                    objectMenu.methordHash = (Constants.PlaceinCabinetagendalistsToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectMenu.taskType = TaskType.GET_PENDING_MEMO_LIST_CABINET
                    objectMenu.timeStamp = appUtilities.getDate()
                    var params2 = [String]()
                    params2.append(dept_id)
                    params2.append(globalUserId)
                    params2.append(globalRoleId)
                    params2.append(globalMappedDepartments)
                    params2.append(globalBranchedMapped)
                    
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
                                            self.tableView.reloadData()
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
                
                //CabinetDecisions
            else if param.caseInsensitiveCompare("CabinetDecisions") == .orderedSame {
                
                if Reachability.isConnectedToNetwork(){
                    let objectMenu = GetPojo();
                    objectMenu.url = Constants.url
                    objectMenu.methord = Constants.CabinetDecisionlists
                    objectMenu.methordHash = (Constants.CabinetDecisionlistsToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectMenu.taskType = TaskType.GET_PENDING_MEMO_LIST_CABINET
                    objectMenu.timeStamp = appUtilities.getDate()
                    var params2 = [String]()
                   // params2.append(dept_id)
                    params2.append(globalUserId)
                    params2.append(globalRoleId)
                    params2.append(globalMappedDepartments)
                    params2.append(meetingID)
                    params2.append(globalBranchedMapped)
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
                                            self.tableView.reloadData()
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
                
            else if param.caseInsensitiveCompare("allowedCabinetMemos") == .orderedSame {
                
                if Reachability.isConnectedToNetwork(){
                    let objectMenu = GetPojo();
                    objectMenu.url = Constants.url
                    objectMenu.methord = Constants.methordAllowedCabinetMemo
                    objectMenu.methordHash = (Constants.methordAllowedCabinetMemoToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectMenu.taskType = TaskType.GET_PENDING_MEMO_LIST_CABINET
                    objectMenu.timeStamp = appUtilities.getDate()
                    var params2 = [String]()
                    params2.append(dept_id)
                    params2.append(globalUserId)
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
                                            self.tableView.reloadData()
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
                
                
            }else{
                
                if Reachability.isConnectedToNetwork(){
                    
                    let objectMenu = GetPojo();
                    objectMenu.url = Constants.url
                    objectMenu.methord = Constants.methordCabinetMemoListByRole
                    objectMenu.methordHash = (Constants.methordCabinetMemoListByToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectMenu.taskType = TaskType.GET_PENDING_MEMO_LIST_CABINET
                    objectMenu.timeStamp = appUtilities.getDate()
                    var params2 = [String]()
                    params2.append(dept_id)
                    params2.append(globalUserId)
                    params2.append(globalRoleId)
                    params2.append(globalMappedDepartments)
                    params2.append(globalBranchedMapped)
                    objectMenu.parametersList = params2
                    objectMenu.activityIndicator = self.view
                    
                    networkUtility.getDataDialog(GetDataPojo: objectMenu) { response in
                        if let response = response {
                            
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
                                            self.tableView.reloadData()
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
        
        @IBAction func goBack(_ sender: Any) {
            UIApplication.setRootView(MainViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
        }
    }
    
    extension CabinetMemosController: UITableViewDelegate, UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cabinetMemos.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellMemos", for: indexPath) as? CustomTableViewCell
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
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            if Reachability.isConnectedToNetwork(){
                let storyBoard : UIStoryboard = UIStoryboard(name: "CabinetMemoDetailsStoryBoard", bundle:nil)
                           let cabinetMemoDetailsController = storyBoard.instantiateViewController(withIdentifier: "CabinetMemoDetailsController") as! CabinetMemoDetailsController
                //Earlier Working
                 cabinetMemoDetailsController.cellData = cabinetMemos[indexPath.row]
                           cabinetMemoDetailsController.memoType = param
                           self.present(cabinetMemoDetailsController, animated:true, completion:nil)
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
        }
        
    }
