//
//  MainViewController.swift
//  login
//
//  Created by Oğulcan on 11/05/2018.
//  Copyright © 2018 ogulcan. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    var appUtilities = UtilitiesApp();
    var networkUtility = NetworkUtility()
    var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectDepartment: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pickerViewDepartments = UIPickerView()
    var globalRoleID: String = ""
    var globalUserID: String = ""
    var deptIDPickerView: String = "0"
    
    var departments = [Departments]()
    var menu = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.encodedna.com/images/theme/angularjs.png")
        
        imageView.kf.setImage(with: url)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
        collectionView.register(CollectionViewCell.NIB(), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        pickerViewDepartments.delegate = self
        pickerViewDepartments.dataSource = self
        selectDepartment.inputView = pickerViewDepartments
        
        
        
        let mapped_loggedin_key = "IS_LOGGED_IN"
        let designationKey_ = "DESIGNATION"
        let mobileNumberKey_ = "MOBILE_NUMBER"
        let nameKey_ = "NAME"
        let userIdKey_ = "USER_ID"
        let userRoleIdKey_ = "ROLE_ID"
        let mapped_departments_id_key  = "DEPARTMENTS_MAPPED"
        print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))
        print(UserDefaults.standard.string(forKey: mobileNumberKey_)!)
        print(UserDefaults.standard.string(forKey: nameKey_)!)
        print(UserDefaults.standard.string(forKey: userIdKey_)!)
        print(UserDefaults.standard.string(forKey: designationKey_)!)
        print(UserDefaults.standard.string(forKey: userRoleIdKey_)!)
        print(UserDefaults.standard.string(forKey: mapped_departments_id_key)!)
        globalRoleID = UserDefaults.standard.string(forKey: userRoleIdKey_)!
        globalUserID = UserDefaults.standard.string(forKey: userIdKey_)!
        
        
        let objectMenu = GetPojo();
        objectMenu.url = Constants.url
        objectMenu.methord = Constants.methordMenuList
        objectMenu.methordHash = (Constants.methordMenuListToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
        objectMenu.taskType = TaskType.GET_MENU_LIST
        objectMenu.timeStamp = appUtilities.getDate()
        var params2 = [String]()
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
                        var model = [Menu]()
                        for dic in jsonArray{
                            model.append(Menu(dic))
                        }
                        
                        self.menu = model;
                        dump(self.menu)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                        
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        
        
        
        let object = GetPojo();
        object.url = Constants.url
        object.methord = Constants.getDepartmentsViaRoles
        object.methordHash = (Constants.getDepartmentsViaRolesToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
        object.taskType = TaskType.GET_DEPARTMENTS_VIA_ROLES
        object.timeStamp = appUtilities.getDate()
        var params = [String]()
        params.append(globalUserID)
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
                        
                        let departments_first = Departments(["DeptId":"MA==","DeptName":"QWxs"])
                        
                        var model = [Departments]()
                        model.append(departments_first)
                        for dic in jsonArray{
                            model.append(Departments(dic))
                        }
                        dump(model)
                        
                        self.departments = model;
                        
                        
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        pickerViewDepartments.selectRow(1, inComponent: 0, animated: true)
    }
    
    //    @IBAction func clearLoginTapped(_ sender: UIButton) {
    //       // try! App.keychain?.remove("token")
    //         let preferences = UserDefaults.standard
    //         let mapped_loggedin_key = "IS_LOGGED_IN"
    //        preferences.set(false, forKey: mapped_loggedin_key)
    //          print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))
    //        UIApplication.setRootView(LoginViewController.instantiate(from: .Login), options: UIApplication.logoutAnimation)
    //    }
    
    
    
}



extension MainViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return departments[row].DeptName.base64Decoded
        
        
    }
    
    
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectDepartment.text = departments[row].DeptName.base64Decoded
        selectDepartment.resignFirstResponder()
        print(departments[row].DeptName.base64Decoded!)
        print(departments[row].DeptId.base64Decoded!)
        deptIDPickerView = departments[row].DeptId.base64Decoded!
        
        
        
    }
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // let square = (collectionView.frame.width-8)/3
        
        return CGSize(width: 100, height: 100)
    }
    
}


extension MainViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        //  cell.backgroundColor = .brown
        //cell.configure(with: "https://www.encodedna.com/images/theme/angularjs.png",  within: "Server Image")
        cell.configure(with: menu[indexPath.row].MenuIcon.base64Decoded!, within:  menu[indexPath.row].MenuName.base64Decoded!)
        return cell
    }
    
    
}

extension MainViewController :UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print(menu[indexPath.row].Menuid.base64Decoded!);
        print(menu[indexPath.row].MenuName.base64Decoded!);
        print(menu[indexPath.row].MenuIcon.base64Decoded!);
        
        
        if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("21") == .orderedSame{
            //LogOut
            let preferences = UserDefaults.standard
            let mapped_loggedin_key = "IS_LOGGED_IN"
            preferences.set(false, forKey: mapped_loggedin_key)
            print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))
            UIApplication.setRootView(LoginViewController.instantiate(from: .Login), options: UIApplication.logoutAnimation)
            
        }
    }
}

