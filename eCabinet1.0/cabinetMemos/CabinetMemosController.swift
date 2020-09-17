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
        
        @IBOutlet weak var heading: UILabel!
        var dept_id: String = ""
        var param: String = ""
        var nameArray = ["Luv","Kush","Minki"]
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
        
        @IBOutlet weak var back: UIButton!
        @IBOutlet weak var tableView: UITableView!
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            // print(UserDefaults.standard.string(forKey: photo_key)!)
            globalRoleId = UserDefaults.standard.string(forKey: userRoleIdKey_)!
            globalUserId = UserDefaults.standard.string(forKey: userIdKey_)!
            globalMappedDepartments = UserDefaults.standard.string(forKey: mapped_departments_id_key)!
            globalBranchedMapped = UserDefaults.standard.string(forKey: branchMappedkey_)!
            
            print(dept_id)
            print(param)
            print(globalUserId)
            print(globalRoleId)
            print(globalMappedDepartments)
            
            
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib.init(nibName: "CustomTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "tableCellMemos")
            
            if param.caseInsensitiveCompare("Forwarded") == .orderedSame {
                
                //Check Internet Pending
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
                
            } else if param.caseInsensitiveCompare("Backwarded") == .orderedSame {
                
                //Check Internet Pending
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
                
            else if param.caseInsensitiveCompare("allowedCabinetMemos") == .orderedSame {
                
                //Check Internet Pending
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
            }else{
                
                //Check Internet Pending
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
            cell?.commonInit(cabinetMemos[indexPath.row])
            return cell!
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(cabinetMemos[indexPath.row])
        }
        
    }
