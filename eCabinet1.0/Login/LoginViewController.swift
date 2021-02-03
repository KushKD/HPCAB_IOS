import UIKit
import Foundation

class LoginViewController: UIViewController {
    

    var window: UIWindow?
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var RolesTextView: UITextField!
    @IBOutlet weak var UsersTextView: UITextField!
    @IBOutlet weak var DepartmentsTextView: UITextField!
    
    @IBOutlet weak var BranchesTextView: UITextField!
    @IBOutlet weak var MobileNumber: UITextField!
    @IBOutlet weak var OTP: UITextField!
    
    
    var appUtilities = UtilitiesApp();
    var roles = [Roles]()
    var usersViaRoles = [UserViaRoles]()
    var departments = [Departments]()
    var branches = [Branches]()
    var statusMessage = [StatusMessage]()
    var LoggedUserDepartments = [LoggedInUserDepartments]()
    var userData = [LoggedInUser]()
    
    
    
    var pickerViewRoles = UIPickerView()
    var pickerViewUsers = UIPickerView()
    var pickerViewDepartments = UIPickerView()
    var pickerBranches = UIPickerView()
    var networkUtility = NetworkUtility()
    
    var globalRoleId: String = ""
    var globalUserId: String = ""
    var globalUserDepartmentId: String = ""
    var globalBranches = ""
    var globalMobile: String = ""
    var serverLoggedInUserDepartemnts = ""
    var globalPhoto = ""
    
    let alertService = AlertService();
    
    var userServer  = SavedUser()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        appUtilities.setHorizontalGradientColor(view: self.topView)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
       // Notifi
        
        pickerViewRoles.dataSource = self
        pickerViewRoles.delegate = self
        pickerViewUsers.dataSource = self
        pickerViewUsers.delegate = self
        pickerViewDepartments.delegate=self
        pickerViewDepartments.dataSource = self
        pickerBranches.dataSource = self
        pickerBranches.delegate = self
        RolesTextView.inputView = pickerViewRoles
        UsersTextView.inputView = pickerViewUsers
        
//        RolesTextView.addBorder(toSide: .Top, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        RolesTextView.addBorder(toSide: .Bottom, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        RolesTextView.addBorder(toSide: .Left, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        RolesTextView.addBorder(toSide: .Right, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
        
//        DepartmentsTextView.addBorder(toSide: .Top, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        DepartmentsTextView.addBorder(toSide: .Bottom, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        DepartmentsTextView.addBorder(toSide: .Left, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        DepartmentsTextView.addBorder(toSide: .Right, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
       // DepartmentsTextView.isUserInteractionEnabled = false
        
//        BranchesTextView.addBorder(toSide: .Top, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        BranchesTextView.addBorder(toSide: .Bottom, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        BranchesTextView.addBorder(toSide: .Left, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        BranchesTextView.addBorder(toSide: .Right, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
         // BranchesTextView.isUserInteractionEnabled = false
        
        
//        UsersTextView.addBorder(toSide: .Top, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        UsersTextView.addBorder(toSide: .Bottom, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        UsersTextView.addBorder(toSide: .Left, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        UsersTextView.addBorder(toSide: .Right, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
         //UsersTextView.isUserInteractionEnabled = false
        
//        MobileNumber.addBorder(toSide: .Top, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        MobileNumber.addBorder(toSide: .Bottom, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        MobileNumber.addBorder(toSide: .Left, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        MobileNumber.addBorder(toSide: .Right, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
        
        
//        OTP.addBorder(toSide: .Top, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        OTP.addBorder(toSide: .Bottom, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        OTP.addBorder(toSide: .Left, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//        OTP.addBorder(toSide: .Right, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
//
        DepartmentsTextView.inputView = pickerViewDepartments
        BranchesTextView.inputView = pickerBranches
        RolesTextView.textAlignment = .center
        UsersTextView.textAlignment = .center
        DepartmentsTextView.textAlignment = .center
        BranchesTextView.textAlignment = .center
        
      //  MobileNumber.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        MobileNumber.maxLength  = 10
        
        /**
         Get Roles via Token on Screen Load
         */
        
        if Reachability.isConnectedToNetwork(){
            let object = GetPojo();
            object.url = Constants.url
            object.methord = Constants.methordGetRoles
            object.methordHash = (Constants.methordGetRolesToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
            object.taskType = TaskType.GET_ROLES
            object.timeStamp = appUtilities.getDate()
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
                            var model = [Roles]()
                            for dic in jsonArray{
                                model.append(Roles(dic))
                            }
                            self.roles = model;
                            
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
                    print("Close Here");
                    UIApplication.setRootView(NoInternetController.instantiate(from:.NoInternet))
                    
                }
                self.present(alertVC, animated: true)
                
            })
        }
        
        
        
        
        
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func getOtp(_ sender: Any) {
        if MobileNumber.text!.count == 10{
            
            
                 //Check User Id and Role ID
                 if  !globalRoleId.isEmpty && !globalUserId.isEmpty{
                        if Reachability.isConnectedToNetwork(){
                                                  print(MobileNumber.text!)
                                                  globalMobile = MobileNumber.text!
                                                  let objectUsers = GetPojo();
                                                  objectUsers.url = Constants.url
                                                  objectUsers.methord = Constants.methordGetOTP
                                                  objectUsers.methordHash = (Constants.methordOTPToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                                                  objectUsers.taskType = TaskType.GET_OTP_VIA_MOBILE
                                                  objectUsers.timeStamp = appUtilities.getDate()
                                                  
                                                  
                                                  var params = [String]()
                                                  params.append(MobileNumber.text!)
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
                    }else{
                        DispatchQueue.main.async(execute: {
                            let alertVC = self.alertService.alert(title: "Input Message", body: "Please Select Role and User", buttonTitle: "OK")
                            { [weak self] in
                                //Go to the Next Story Board
            
                            }
                            self.present(alertVC, animated: true)
            
                        })
                    }
                     
                   
                  
                   
                   
                   
                   
                   
                   
               }else{
                   print("Please Enter a Valid 10 Digit Mobile Number.")
               }

        
    }
    @IBAction func adminLogin(_ sender: Any) {
        
        print("Admin Login");
        UIApplication.setRootView(AdminLoginController.instantiate(from:.AdminLogin))
    }
    /**
     Login Button
     */
    @IBAction func login(_ sender: Any) {
        
        //Check OTP
        // Check Mobile
        // Check Other Params
        //Check Internet
        
        if OTP.text?.count == 6 {
            if MobileNumber.text?.count == 10 {
                
                if Reachability.isConnectedToNetwork(){
                           let loginObject = GetPojo();
                           loginObject.url = Constants.url
                           loginObject.methord = Constants.methordLogin
                           loginObject.methordHash = (Constants.methordLoginToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                           loginObject.taskType = TaskType.LOGIN
                           loginObject.timeStamp = appUtilities.getDate()
                           
                           
                           var params = [String]()
                           params.append(globalMobile)
                           params.append(OTP.text!)
                           params.append(globalUserId)
                           params.append(globalRoleId)
                           
                           loginObject.parametersList = params
                           loginObject.activityIndicator = self.view
                           
                           
                           networkUtility.getDataDialog(GetDataPojo: loginObject) { response in
                               if let response = response {
                                   do{
                                       //here dataResponse received from a network request
                                       let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                                       guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                           return
                                       }
                                       do {
                                           var model = [LoggedInUserDepartments]()
                                           for dic in jsonArray{
                                               model.append(LoggedInUserDepartments(dic))
                                           }
                                           self.LoggedUserDepartments = model;
                                           
                                       }
                                       do {
                                           var userDataServer = [LoggedInUser]()
                                           for dic in jsonArray{
                                               userDataServer.append(LoggedInUser(dic))
                                           }
                                           self.userData = userDataServer;
                                           print(userDataServer[0].Branchmapped.base64Decoded!)
                                       }
                                       
                                       if self.userData[0].StatusMessage.base64Decoded!.caseInsensitiveCompare("Record Found") == .orderedSame{
                                           self.userData[0].RoleId = self.globalRoleId
                                           // self.userData[0].Photo = self.globalPhoto
                                           self.userServer =  self.appUtilities.saveUserDetails(data_user: self.userData[0] , user_server: self.LoggedUserDepartments);
                                           //Save Data Saved Prefrences TODO
                                           let isAllowed: Bool = self.appUtilities.writeUserData(data: self.userServer)
                                           print(isAllowed)
                                           if isAllowed{
                                               //Go to Othrer Screen
                                               DispatchQueue.main.async(execute: {
                                                   
                                                   let alertVC = self.alertService.alert(title: "Success Message", body: "Login Successful. Please click OK to continue.", buttonTitle: "OK")
                                                   { [weak self] in
                                                       //Go to the Next Story Board
                                                       UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                                                   }
                                                   self.present(alertVC, animated: true)
                                               })
                                           }else{
                                               DispatchQueue.main.async(execute: {
                                                   
                                                   let alertVC = self.alertService.alert(title: "Error Mesage", body: "Something Bad Happened. Please restart the application", buttonTitle: "OK")
                                                   { [weak self] in
                                                       //Functionality of Confirm Button Goes Here TODO
                                                   }
                                                   self.present(alertVC, animated: true)
                                               })
                                           }
                                           
                                       }else{
                                           DispatchQueue.main.async(execute: {
                                               
                                               let alertVC = self.alertService.alert(title: "Success?", body: self.userData[0].StatusMessage.base64Decoded!, buttonTitle: "Confirm")
                                               { [weak self] in
                                                   //Functionality of Confirm Button Goes Here TODO
                                               }
                                               self.present(alertVC, animated: true)
                                           })
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
                
            }else{
                DispatchQueue.main.async(execute: {
                                         let alertVC = self.alertService.alert(title: "Input Message", body: "Please enter a valid 10 Digit Mobile Number.", buttonTitle: "OK")
                                         { [weak self] in
                                             //Go to the Next Story Board
                                             
                                         }
                                         self.present(alertVC, animated: true)
                                         
                                     })
            }
            
            
        }else{
            DispatchQueue.main.async(execute: {
                          let alertVC = self.alertService.alert(title: "Input Message", body: "Please enter a valid OTP Number that has been sent to your Mobile Number", buttonTitle: "OK")
                          { [weak self] in
                              //Go to the Next Story Board
                              
                          }
                          self.present(alertVC, animated: true)
                          
                      })
        }
        
    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//
//            if textField.text!.count == 10{
//
//
//                     //Check User Id and Role ID
//                     if  !globalRoleId.isEmpty && !globalUserId.isEmpty{
//                            if Reachability.isConnectedToNetwork(){
//                                                      print(textField.text!)
//                                                      globalMobile = textField.text!
//                                                      let objectUsers = GetPojo();
//                                                      objectUsers.url = Constants.url
//                                                      objectUsers.methord = Constants.methordGetOTP
//                                                      objectUsers.methordHash = (Constants.methordOTPToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
//                                                      objectUsers.taskType = TaskType.GET_OTP_VIA_MOBILE
//                                                      objectUsers.timeStamp = appUtilities.getDate()
//
//
//                                                      var params = [String]()
//                                                      params.append(textField.text!)
//                                                      params.append(globalUserId)
//                                                      params.append(globalRoleId)
//
//                                                      objectUsers.parametersList = params
//                                                      objectUsers.activityIndicator = self.view
//
//                                                      networkUtility.getDataDialog(GetDataPojo: objectUsers) { response in
//                                                          if let response = response {
//                                                              print(response.respnse!)
//                                                              do{
//                                                                  //here dataResponse received from a network request
//
//                                                                  let jsonResponse = try  JSONSerialization.jsonObject(with: response.respnse!, options: []) as? [String:AnyObject]
//                                                                  print("kush")
//                                                                  let statusMessage: String = jsonResponse!["StatusMessage"]! as! String
//
//                                                                  DispatchQueue.main.async(execute: {
//
//                                                                      let alertVC = self.alertService.alert(title: "Success?", body: statusMessage.base64Decoded!, buttonTitle: "Confirm")
//                                                                      { [weak self] in
//                                                                          //Functionality of Confirm Button Goes Here
//                                                                      }
//                                                                      self.present(alertVC, animated: true)
//                                                                  })
//
//
//                                                              } catch let parsingError {
//                                                                  print("Error", parsingError)
//                                                              }
//                                                          }
//                                                      }
//
//
//
//                                                  }
//                                                  else{
//                                                      DispatchQueue.main.async(execute: {
//                                                          let alertVC = self.alertService.alert(title: "Network Message", body: Constants.internetNotAvailable!, buttonTitle: "OK")
//                                                          { [weak self] in
//                                                              //Go to the Next Story Board
//
//                                                          }
//                                                          self.present(alertVC, animated: true)
//
//                                                      })
//                                                  }
//                        }else{
//                            DispatchQueue.main.async(execute: {
//                                let alertVC = self.alertService.alert(title: "Input Message", body: "Please Select Role and User", buttonTitle: "OK")
//                                { [weak self] in
//                                    //Go to the Next Story Board
//
//                                }
//                                self.present(alertVC, animated: true)
//
//                            })
//                        }
//
//
//
//
//
//
//
//
//
//                   }else{
//                       print("Please Enter a Valid 10 Digit Mobile Number.")
//                   }
//
//
//
//
//    }
    
    
}


extension LoginViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewRoles{
            return roles.count
        }else if pickerView == pickerViewUsers {
            return usersViaRoles.count
        }else if pickerView == pickerBranches{
            return branches.count
        }else{
            return departments.count
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerViewRoles{
            
            return roles[row].RoleName.base64Decoded
        }else if pickerView == pickerViewUsers {
            return usersViaRoles[row].name.base64Decoded
        }else if pickerView == pickerBranches{
            return branches[row].BranchName.base64Decoded
        }else{
            return departments[row].DeptName.base64Decoded
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerViewRoles{
            UsersTextView.text = ""
            RolesTextView.text = roles[row].RoleName.base64Decoded
            RolesTextView.resignFirstResponder()
            
            globalRoleId = roles[row].Roleid.base64Decoded!;
            
            if globalRoleId.caseInsensitiveCompare("7") == .orderedSame || globalRoleId.caseInsensitiveCompare("6") == .orderedSame ||
            globalRoleId.caseInsensitiveCompare("5") == .orderedSame || globalRoleId.caseInsensitiveCompare("4") == .orderedSame
            {
                
                
                if Reachability.isConnectedToNetwork(){
                    DepartmentsTextView.isHidden = true
                    BranchesTextView.isHidden = true
                    
                    let objectUsers = GetPojo();
                    objectUsers.url = Constants.url
                    objectUsers.methord = Constants.methordUsers
                    objectUsers.methordHash = (Constants.methordUsersToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectUsers.taskType = TaskType.GET_USERS
                    objectUsers.timeStamp = appUtilities.getDate()
                    
                    
                    var params = [String]()
                    params.append("0")
                    params.append("0")
                    params.append(globalRoleId)
                    
                    objectUsers.parametersList = params
                    objectUsers.activityIndicator = self.view
                    
                    networkUtility.getDataDialog(GetDataPojo: objectUsers) { response in
                        if let response = response {
                            do{
                                //here dataResponse received from a network request
                                let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                    return
                                }
                                do {
                                    var model = [UserViaRoles]()
                                    for dic in jsonArray{
                                        model.append(UserViaRoles(dic))
                                    }
                                    self.usersViaRoles = model;
                                    //self.globalPhoto = model[0].Photo.base64Decoded!
                                    // print(model[0].RoleName.base64Decoded!) // 1211
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
                           // Go to the Next Story Board
                           // present(UIViewController(), animated: true, completion: nil)
//                            if Constants.internetNotAvailable{
//
//                            }
                            UIApplication.setRootView(NoInternetController.instantiate(from:.NoInternet))
                            
                        }
                        self.present(alertVC, animated: true)
                       
                        
                    })
                }
                
            }else{
                
                if Reachability.isConnectedToNetwork(){
                    DepartmentsTextView.isHidden = false
                    DepartmentsTextView.isUserInteractionEnabled = true
                    BranchesTextView.isHidden = false
                    BranchesTextView.isUserInteractionEnabled = true
                    let objectUserDepartments = GetPojo();
                    objectUserDepartments.url = Constants.url
                    objectUserDepartments.methord = Constants.methordDepartmentsViaRoles
                    objectUserDepartments.methordHash = (Constants.methordDepartmentsToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectUserDepartments.taskType = TaskType.GET_DEPARTMENTS_VIA_ROLES
                    objectUserDepartments.timeStamp = appUtilities.getDate()
                    
                    
                    var params = [String]()
                    params.append(globalRoleId)
                    
                    objectUserDepartments.parametersList = params
                    objectUserDepartments.activityIndicator = self.view
                    
                    networkUtility.getDataDialog(GetDataPojo: objectUserDepartments) { response in
                        if let response = response {
                            do{
                                //here dataResponse received from a network request
                                let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                    return
                                }
                                do {
                                    var model = [Departments]()
                                    for dic in jsonArray{
                                        model.append(Departments(dic))
                                    }
                                    self.departments = model;
                                    // print(model[0].RoleName.base64Decoded!) // 1211
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
                            UIApplication.setRootView(NoInternetController.instantiate(from:.NoInternet))
                        }
                        self.present(alertVC, animated: true)
                        
                    })
                }
                
                
            }
            
            
        }else if pickerView == pickerViewUsers{
            UsersTextView.text = usersViaRoles[row].name.base64Decoded
            UsersTextView.resignFirstResponder()
            globalUserId = usersViaRoles[row].Userid.base64Decoded!;
            
            
            
        }else if pickerView == pickerViewDepartments{
            DepartmentsTextView.text = departments[row].DeptName.base64Decoded
            DepartmentsTextView.resignFirstResponder()
            globalUserDepartmentId = departments[row].DeptId.base64Decoded!;
            
            if globalRoleId.caseInsensitiveCompare("4") == .orderedSame || globalRoleId.caseInsensitiveCompare("5") == .orderedSame {
                
                if Reachability.isConnectedToNetwork(){
                    //Get USers
                    BranchesTextView.isHidden=true
                    let objectUsers = GetPojo();
                    objectUsers.url = Constants.url
                    objectUsers.methord = Constants.methordUsers
                    objectUsers.methordHash = (Constants.methordUsersToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectUsers.taskType = TaskType.GET_USERS
                    objectUsers.timeStamp = appUtilities.getDate()
                    
                    
                    var params = [String]()
                    params.append(globalUserDepartmentId)
                    params.append("0")
                    params.append(globalRoleId)
                    
                    objectUsers.parametersList = params
                    objectUsers.activityIndicator = self.view
                    
                    networkUtility.getDataDialog(GetDataPojo: objectUsers) { response in
                        if let response = response {
                            do{
                                //here dataResponse received from a network request
                                let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                    return
                                }
                                do {
                                    var model = [UserViaRoles]()
                                    for dic in jsonArray{
                                        model.append(UserViaRoles(dic))
                                    }
                                    self.usersViaRoles = model;
                                    // print(model[0].RoleName.base64Decoded!) // 1211
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
                            UIApplication.setRootView(NoInternetController.instantiate(from:.NoInternet))
                        }
                        self.present(alertVC, animated: true)
                        
                    })
                }
                
            }else{
                
                
                if Reachability.isConnectedToNetwork(){
                    BranchesTextView.isUserInteractionEnabled = true
                    let objectBranches = GetPojo();
                    objectBranches.url = Constants.url
                    objectBranches.methord = Constants.methordBranchesViaDept
                    objectBranches.methordHash = (Constants.methordBranchesToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectBranches.taskType = TaskType.GET_BRANCHES
                    objectBranches.timeStamp = appUtilities.getDate()
                    
                    
                    var params = [String]()
                    params.append(globalUserDepartmentId)
                    
                    objectBranches.parametersList = params
                    objectBranches.activityIndicator = self.view
                    
                    networkUtility.getDataDialog(GetDataPojo: objectBranches) { response in
                        if let response = response {
                            do{
                                //here dataResponse received from a network request
                                let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                    return
                                }
                                do {
                                    var model = [Branches]()
                                    for dic in jsonArray{
                                        model.append(Branches(dic))
                                    }
                                    self.branches = model;
                                    // print(model[0].RoleName.base64Decoded!) // 1211
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
                            UIApplication.setRootView(NoInternetController.instantiate(from:.NoInternet))
                            
                        }
                        self.present(alertVC, animated: true)
                        
                    })
                }
                
                
                
                
                
                
            }
        }else if pickerView == pickerBranches{
            
            BranchesTextView.text = branches[row].BranchName.base64Decoded
            BranchesTextView.resignFirstResponder()
            globalBranches = branches[row].BranchID.base64Decoded!;
            
            
            if Reachability.isConnectedToNetwork(){
                let objectUsers = GetPojo();
                objectUsers.url = Constants.url
                objectUsers.methord = Constants.methordUsers
                objectUsers.methordHash = (Constants.methordUsersToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                objectUsers.taskType = TaskType.GET_USERS
                objectUsers.timeStamp = appUtilities.getDate()
                
                
                var params = [String]()
                params.append(globalUserDepartmentId)
                params.append(globalBranches)
                params.append(globalRoleId)
                
                objectUsers.parametersList = params
                objectUsers.activityIndicator = self.view
                UsersTextView.isUserInteractionEnabled = true
                
                networkUtility.getDataDialog(GetDataPojo: objectUsers) { response in
                    if let response = response {
                        do{
                            //here dataResponse received from a network request
                            let jsonResponse = try JSONSerialization.jsonObject(with: response.respnse!, options: [])
                            guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                return
                            }
                            do {
                                var model = [UserViaRoles]()
                                for dic in jsonArray{
                                    model.append(UserViaRoles(dic))
                                }
                                self.usersViaRoles = model;
                                // print(model[0].RoleName.base64Decoded!) // 1211
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
                        UIApplication.setRootView(NoInternetController.instantiate(from:.NoInternet))
                        
                    }
                    self.present(alertVC, animated: true)
                    
                })
            }
            
            
        }
        
        
        
        
        
    }
    
}
