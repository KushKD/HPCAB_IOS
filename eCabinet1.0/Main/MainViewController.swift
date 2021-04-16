    //
    //  MainViewController.swift
    //  login
    //
    //
    
    import UIKit
    import Kingfisher
    import ImageSlideshow
    
    class MainViewController: UIViewController, HamburgerViewControllerDelegate {
        
        var appUtilities = UtilitiesApp();
        var networkUtility = NetworkUtility()
        let activeAgendaDialogController = ActiveAgendaDialogController();
        var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        
        var refresher:UIRefreshControl!
        
        @IBOutlet weak var subject: UILabel!
        
        @IBOutlet weak var leadingConstraintForHamburgerView: NSLayoutConstraint!
        @IBOutlet weak var mainBackView: UIView!
        @IBOutlet weak var hamburgerView: UIView!
        @IBOutlet weak var slideView: ImageSlideshow!
        @IBOutlet weak var selectDepartment: UITextView!
        @IBOutlet weak var collectionView: UICollectionView!
        //   @IBOutlet weak var name: UILabel!
        //  @IBOutlet weak var designation: UILabel!
        @IBOutlet weak var agendaStackView: UIStackView!
        let alertService = AlertService();
        
        @IBOutlet weak var activeAgendaDept: UILabel!
        @IBOutlet weak var agendaItemNumber: UILabel!
        var pickerViewDepartments = UIPickerView()
        var globalRoleID: String = ""
        var globalUserID: String = ""
        var globalPhoto: String = ""
        var deptIDPickerView: String = "0"
        
        
        var departments = [Departments]()
        var menu = [Menu]()
        var activeAgenda = [ActiveAgenda]()
        var window:UIWindow?
        let localSource = [BundleImageSource(imageString: "image1"), BundleImageSource(imageString: "image2")]
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
           // self.refresher = UIRefreshControl()
           // self.collectionView!.alwaysBounceVertical = true
           // self.refresher.tintColor = UIColor.red
           // self.refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
           // self.collectionView!.addSubview(refresher)
            self.mainBackView.isHidden = true
            slideView.slideshowInterval = 5.0
            slideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
            slideView.contentScaleMode = UIViewContentMode.scaleAspectFill
            
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor.lightGray
            pageControl.pageIndicatorTintColor = UIColor.white
            
            slideView.pageIndicator = pageControl
            
            
            agendaStackView.visibility = .gone
            
            
            self.agendaItemNumber.isUserInteractionEnabled = true
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
            tapgesture.numberOfTapsRequired = 1
            self.agendaItemNumber.addGestureRecognizer(tapgesture)
            
            
        
            
            
            
            slideView.visibility = .visible
            
            slideView.activityIndicator = DefaultActivityIndicator()
            slideView.delegate = self
            
            
            slideView.setImageInputs(localSource)
            
            let yourWidth = collectionView.bounds.width/3.0
            let yourHeight = yourWidth
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: yourWidth-5, height: yourHeight)
            collectionView.collectionViewLayout = layout
            collectionView.register(CollectionViewCell.NIB(), forCellWithReuseIdentifier: "CollectionViewCell")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .white
            pickerViewDepartments.delegate = self
            pickerViewDepartments.dataSource = self
            selectDepartment.inputView = pickerViewDepartments
            selectDepartment.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
           // collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0);  earlier working
            
            
            
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
            
            
            /**
                        Check the active agenda after 2 seconds
             */
            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                print("I am called every 5 seconds")
                
                //Get Active Agenda TODO
                if Reachability.isConnectedToNetwork(){
                    let objectMenu = GetPojo();
                    objectMenu.url = Constants.url
                    objectMenu.methord = Constants.methordGetOnlineCabinetIDMeetingStatus
                    objectMenu.methordHash = (Constants.methordGetOnlineCabinetIDMeetingToken! + Constants.seperator! + self.appUtilities.getDate()).base64Encoded!
                    objectMenu.taskType = TaskType.GET_ACTIVE_AGENDA
                    objectMenu.timeStamp = self.appUtilities.getDate()
                    
                    objectMenu.activityIndicator = self.view
                    
                    self.networkUtility.getDataDialog(GetDataPojo: objectMenu) { response in
                        if let response = response {
                            print(response.respnse!)
                            
                            let agenda:ActiveAgenda =   try! JSONDecoder().decode(ActiveAgenda.self, from: response.respnse!)
                            print(agenda.AgendaItemNo)
                            print(agenda.StatusMessage.base64Decoded!)
         
                            
                            if(agenda.AgendaItemNo.count>0){
                                //Open Active Agenda Pop Up
                                
                                DispatchQueue.main.async(execute: {
                                    //Earlier Working
//                                    let alertVC = self.alertService.alert(title: "Active Agenda Message", body: agenda.Subject.base64Decoded!, buttonTitle: "OK")
//                                    { [weak self] in
//                                        //Go to the Next Story Board
//
//                                    }
//                                    self.present(alertVC, animated: true)
                                    
                                    //Hide the SLider
                                   /**
                                     let viewHeight:CGFloat = switchbutton.isOn ? 100 : 0.0
                                         self.testView?.visiblity(gone: !switchbutton.isOn, dimension: viewHeight)

                                         // set visibility for width constraint
                                         //let viewWidth:CGFloat = switchbutton.isOn ? 300 : 0.0
                                         //self.testView?.visiblity(gone: !switchbutton.isOn, dimension: viewWidth, attribute: .width)
                                     */
                                    
                                    self.slideView.visibility = .gone
                                    self.agendaStackView.visibility = .visible
                                    
                                        
                                  
                                    print(agenda.Subject.base64Decoded!)
                                    print(agenda.AgendaItemNo.base64Decoded!)
                                    //Show the StackView
                                    self.agendaItemNumber.text  = agenda.AgendaItemNo.base64Decoded!
                                    
                                    self.activeAgendaDept.text = agenda.DeptName.base64Decoded!
                                    
                                    self.subject.text =
                                        agenda.Subject.base64Decoded!
                                })
                                
                                
                                
                            }else{
                               // Hide the StackView and Show the Slider
                                self.slideView.visibility = .visible
                                self.agendaStackView.visibility = .gone
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
        
       
//        @objc func refreshData() {
//           self.collectionView!.refreshControl?.beginRefreshing()
//
//            DispatchQueue.main.async {
//                self.collectionView!.refreshControl!.endRefreshing()
//            }
//         }

//        func stopRefresher() {
//            self.collectionView!.refreshControl?.endRefreshing()
//         }
        
        private var isHamburgerMenuShown:Bool = false
        private var beginPoint:CGFloat = 0.0
        private var difference:CGFloat = 0.0
        
        
     //tappedOnLabel
        @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
              
                   print("user tapped on terms and conditions text")
            /**
                            Go To Other Active Agenda Screen From Here
             TODO
             */
            let storyBoard : UIStoryboard = UIStoryboard(name: "ActiveAgendaItem", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ActiveAgendaItem") as! ActiveAgendaItem
          //  nextViewController.listToShow = listCabinetMemoTrackingHistoryLists
            self.present(nextViewController, animated:true, completion:nil)
              
           }
        
        func hideHamburgerMenu() {
            //Logout
            self.hideHamburgerView()
            let preferences = UserDefaults.standard
            let mapped_loggedin_key = "IS_LOGGED_IN"
            preferences.set(false, forKey: mapped_loggedin_key)
            print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))
            UIApplication.setRootView(LoginViewController.instantiate(from: .Login), options: UIApplication.logoutAnimation)
           
        }
        
        
        @IBAction func tappedOnHamburgerbackView(_ sender: Any) {
            self.hideHamburgerView()
        }
        
        
        @IBAction func showHamburgerMenu(_ sender: Any) {
            
            UIView.animate(withDuration: 0.1) {
                self.leadingConstraintForHamburgerView.constant = -10
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.mainBackView.alpha = 0.75
                self.mainBackView.isHidden = false
                UIView.animate(withDuration: 0.1) {
                    self.leadingConstraintForHamburgerView.constant = -10
                    self.view.layoutIfNeeded()
                } completion: { (status) in
                    self.isHamburgerMenuShown = true
                }

            }

            self.mainBackView.isHidden = false
            
            
            
        }
        
        private func hideHamburgerView()
        {
            UIView.animate(withDuration: 0.1) {
                self.leadingConstraintForHamburgerView.constant = -10
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.mainBackView.alpha = 0.0
                UIView.animate(withDuration: 0.1) {
                    self.leadingConstraintForHamburgerView.constant = -290
                    self.view.layoutIfNeeded()
                } completion: { (status) in
                    self.mainBackView.isHidden = true
                    self.isHamburgerMenuShown = false
                }
            }
        }
        
        
        var hamburgerViewController : HamburgerViewController?
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "hamburgerSegue")
            {
                if let controller = segue.destination as? HamburgerViewController
                {
                    self.hamburgerViewController = controller
                    self.hamburgerViewController?.delegate = self
                    
                }
            }
        }
        
        
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if (isHamburgerMenuShown)
            {
                if let touch = touches.first
                {
                    let location = touch.location(in: mainBackView)
                    beginPoint = location.x
                }
            }
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            if (isHamburgerMenuShown)
            {
                if let touch = touches.first
                {
                    let location = touch.location(in: mainBackView)
                    
                    let differenceFromBeginPoint = beginPoint - location.x
                    
                    if (differenceFromBeginPoint>0 || differenceFromBeginPoint<290)
                    {
                        difference = differenceFromBeginPoint
                        self.leadingConstraintForHamburgerView.constant = -differenceFromBeginPoint
                        self.mainBackView.alpha = 0.75-(0.75*differenceFromBeginPoint/290)
                    }
                }
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            if (isHamburgerMenuShown)
            {
                if (difference>140)
                {
                    UIView.animate(withDuration: 0.1) {
                        self.leadingConstraintForHamburgerView.constant = -290
                    } completion: { (status) in
                        self.mainBackView.alpha = 0.0
                        self.isHamburgerMenuShown = false
                        self.mainBackView.isHidden = true
                    }
                }
                else{
                    UIView.animate(withDuration: 0.1) {
                        self.leadingConstraintForHamburgerView.constant = -10
                    } completion: { (status) in
                        self.mainBackView.alpha = 0.75
                        self.isHamburgerMenuShown = true
                        self.mainBackView.isHidden = false
                    }
                }
            }
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
                
                //Get Active Agenda TODO
                if Reachability.isConnectedToNetwork(){
                    let objectMenu = GetPojo();
                    objectMenu.url = Constants.url
                    objectMenu.methord = Constants.methordGetOnlineCabinetIDMeetingStatus
                    objectMenu.methordHash = (Constants.methordGetOnlineCabinetIDMeetingToken! + Constants.seperator! + appUtilities.getDate()).base64Encoded!
                    objectMenu.taskType = TaskType.GET_ACTIVE_AGENDA
                    objectMenu.timeStamp = appUtilities.getDate()
                    
                    objectMenu.activityIndicator = self.view
                    
                    networkUtility.getDataDialog(GetDataPojo: objectMenu) { response in
                        if let response = response {
                            print(response.respnse!)
                            
                            let agenda:ActiveAgenda =   try! JSONDecoder().decode(ActiveAgenda.self, from: response.respnse!)
                            print(agenda.AgendaItemNo)
                            print(agenda.StatusMessage.base64Decoded!)
         
                            
                            if(agenda.AgendaItemNo.count>0){
                                //Open Active Agenda Pop Up
                                
                                DispatchQueue.main.async(execute: {
                                    let alertVC = self.alertService.alert(title: "Active Agenda Message", body: agenda.Subject.base64Decoded!, buttonTitle: "OK")
                                    { [weak self] in
                                        //Go to the Next Story Board

                                    }
                                    self.present(alertVC, animated: true)

                                })
                                
                                
                                
                            }else{
//                                DispatchQueue.main.async(execute: {
//                                    let alertVC = self.activeAgendaDialogController.alert(data: agenda)
//                                    { [weak self] in
//                                        //Go to the Next Story Board
//
//                                    }
//                                    self.present(alertVC, animated: true)
//
//                                })
                                DispatchQueue.main.async(execute: {
                                    let alertVC = self.alertService.alert(title: "Active Agenda Message", body: agenda.StatusMessage.base64Decoded!, buttonTitle: "OK")
                                    { [weak self] in
                                        //Go to the Next Story Board

                                    }
                                    self.present(alertVC, animated: true)

                                })
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
                
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("6") == .orderedSame{
                
                let cabinetViewController = CabinetMemosController.instantiate(from: .CabinetMemos)
                cabinetViewController.dept_id = deptIDPickerView
                cabinetViewController.param = "allowedCabinetMemos"
                UIApplication.setRootView(cabinetViewController)
                
            }else if menu[indexPath.row].Menuid.base64Decoded!.caseInsensitiveCompare("7") == .orderedSame{
                
                let agendaListController = MeetingAgendaListViewController.instantiate(from: .MeetingAgendaList)
                agendaListController.dept_id = deptIDPickerView
                agendaListController.param = "FinalAgendaList"
                
                UIApplication.setRootView(agendaListController)
                
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
    
