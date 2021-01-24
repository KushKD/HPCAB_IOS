    //
    //  MainViewController.swift
    //  login
    //
    //  Created by Oğulcan on 11/05/2018.
    //  Copyright © 2018 ogulcan. All rights reserved.
    //
    
    import UIKit
    import Kingfisher
    import ImageSlideshow
    
    class MainViewController: UIViewController {
        var appUtilities = UtilitiesApp();
        var networkUtility = NetworkUtility()
        var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        
        
        
        @IBOutlet weak var slideView: ImageSlideshow!
        @IBOutlet weak var selectDepartment: UITextView!
        @IBOutlet weak var collectionView: UICollectionView!
        //   @IBOutlet weak var name: UILabel!
        //  @IBOutlet weak var designation: UILabel!
        let alertService = AlertService();
        
        var pickerViewDepartments = UIPickerView()
        var globalRoleID: String = ""
        var globalUserID: String = ""
        var globalPhoto: String = ""
        var deptIDPickerView: String = "0"
        
        var departments = [Departments]()
        var menu = [Menu]()
        var window:UIWindow?
        let localSource = [BundleImageSource(imageString: "image1"), BundleImageSource(imageString: "image2")]
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            slideView.slideshowInterval = 5.0
            slideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
            slideView.contentScaleMode = UIViewContentMode.scaleAspectFill
            
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor.lightGray
            pageControl.pageIndicatorTintColor = UIColor.white
            
            slideView.pageIndicator = pageControl
            
            
            slideView.activityIndicator = DefaultActivityIndicator()
            slideView.delegate = self
            
            
            slideView.setImageInputs(localSource)
            
            let yourWidth = collectionView.bounds.width/3.0
            let yourHeight = yourWidth
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: yourWidth-5, height: yourHeight)
            collectionView.collectionViewLayout = layout
            collectionView.register(CollectionViewCell.NIB(), forCellWithReuseIdentifier: "CollectionViewCell")
            // collectionView.layer.borderColor = UIColor.red.cgColor
            //collectionView.layer.borderWidth = 3.0
            //  selectDepartment.addBorder(toSide: .Top, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
            // selectDepartment.addBorder(toSide: .Bottom, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
            // selectDepartment.addBorder(toSide: .Left, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
            // selectDepartment.addBorder(toSide: .Right, withColor: UIColor(named: "RedMaroon")!.cgColor, andThickness: 1.0)
            
            // collectionView.layer.cornerRadius = 5.0
            // collectionView.backgroundColor = UIColor.red
            // self.collectionView.backgroundColor = appUtilities.hexStringToUIColor(hex: "#F2F2F2")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .white
            pickerViewDepartments.delegate = self
            pickerViewDepartments.dataSource = self
            selectDepartment.inputView = pickerViewDepartments
            selectDepartment.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0);
            
            
            
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
            
            // name.text = UserDefaults.standard.string(forKey: nameKey_)!
            // designation.text = UserDefaults.standard.string(forKey: designationKey_)!
            
            if Reachability.isConnectedToNetwork(){
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
            
            
            
            if Reachability.isConnectedToNetwork(){
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
            let yourWidth = collectionView.bounds.width/3.0
            let yourHeight = yourWidth
            
            return CGSize(width: yourWidth-5, height: yourHeight)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.zero
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
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
            cell.backgroundColor = appUtilities.hexStringToUIColor(hex: "#FFFFFF")
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
            cell.layer.shadowRadius = 1  //2.0
            cell.layer.shadowOpacity = 1.0
            //cell.layer.masksToBounds = false
            cell.configure(with: menu[indexPath.row].MenuIcon.base64Decoded!, within:  menu[indexPath.row].MenuName.base64Decoded!)
            return cell
        }
        
        
    }
    
    extension MainViewController: ImageSlideshowDelegate {
        func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
            print("current page:", page)
        }
    }
    
    extension MainViewController :UICollectionViewDelegate{
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            
            
            
            if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("21") == .orderedSame{
                //LogOut
                let preferences = UserDefaults.standard
                let mapped_loggedin_key = "IS_LOGGED_IN"
                preferences.set(false, forKey: mapped_loggedin_key)
                print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))
                UIApplication.setRootView(LoginViewController.instantiate(from: .Login), options: UIApplication.logoutAnimation)
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("1") == .orderedSame{
                
                
                let cabinetViewController = CabinetMemosController.instantiate(from: .CabinetMemos)
                cabinetViewController.dept_id = deptIDPickerView
                cabinetViewController.param = "Current"
                
                UIApplication.setRootView(cabinetViewController)
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("2") == .orderedSame{
                
                let cabinetViewController = CabinetMemosController.instantiate(from: .CabinetMemos)
                cabinetViewController.dept_id = deptIDPickerView
                cabinetViewController.param = "Forwarded"
                
                UIApplication.setRootView(cabinetViewController)
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("3") == .orderedSame{
                
                let cabinetViewController = CabinetMemosController.instantiate(from: .CabinetMemos)
                cabinetViewController.dept_id = deptIDPickerView
                cabinetViewController.param = "Backwarded"
                
                UIApplication.setRootView(cabinetViewController)
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("5") == .orderedSame{
                
                DispatchQueue.main.async(execute: {
                    
                    let alertVC = self.alertService.alert(title: "Success Message", body: "Under Process ", buttonTitle: "OK")
                    { [weak self] in
                        //Go to the Next Story Board
                        //  UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                    }
                    self.present(alertVC, animated: true)
                })
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("4") == .orderedSame{
                
                //                let cabinetViewController = CabinetMemosController.instantiate(from: .CabinetMemos)
                //                           cabinetViewController.dept_id = deptIDPickerView
                //                           cabinetViewController.param = "getAgenda"
                //
                //                           UIApplication.setRootView(cabinetViewController)
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("6") == .orderedSame{
                
                let cabinetViewController = CabinetMemosController.instantiate(from: .CabinetMemos)
                cabinetViewController.dept_id = deptIDPickerView
                cabinetViewController.param = "allowedCabinetMemos"
                UIApplication.setRootView(cabinetViewController)
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("7") == .orderedSame{
                
                let cabinetViewController = CabinetMemosController.instantiate(from: .CabinetMemos)
                cabinetViewController.dept_id = deptIDPickerView
                cabinetViewController.param = "FinalAgendaList"
                
                UIApplication.setRootView(cabinetViewController)
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("8") == .orderedSame{
                
                let cabinetViewController = CabinetMemosController.instantiate(from: .CabinetMemos)
                cabinetViewController.dept_id = deptIDPickerView
                cabinetViewController.param = "PlacedInCabinet"
                
                UIApplication.setRootView(cabinetViewController)
                
            } //Cabinet Decisions
            else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("9") == .orderedSame{
                
                let cabinetViewController = CabinetDesicionViewController.instantiate(from: .CabinetDecisions)
                cabinetViewController.dept_id = deptIDPickerView
                cabinetViewController.param = "Cabinet_Decisions"
                
                UIApplication.setRootView(cabinetViewController)
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("10") == .orderedSame{
                
                DispatchQueue.main.async(execute: {
                    
                    let alertVC = self.alertService.alert(title: "Success Message", body: "Under Process ", buttonTitle: "OK")
                    { [weak self] in
                        
                    }
                    self.present(alertVC, animated: true)
                })
                
            }
            
            
            
            
            
            
            
            
            
            
            
        }
    }
    
