//
//  HamburgerViewController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 1/25/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import UIKit

protocol HamburgerViewControllerDelegate {
    func hideHamburgerMenu()
}
class HamburgerViewController: UIViewController {

    var delegate : HamburgerViewControllerDelegate?
    
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var mobile: UILabel!
    
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupHamburgerUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupHamburgerUI()
    {
        self.mainBackgroundView.layer.cornerRadius = 40
        self.mainBackgroundView.clipsToBounds = true
        
        self.profilePictureImage.layer.cornerRadius = 40
        self.profilePictureImage.clipsToBounds = true
        
        let mapped_loggedin_key = "IS_LOGGED_IN"
        let designationKey_ = "DESIGNATION"
        let mobileNumberKey_ = "MOBILE_NUMBER"
        let nameKey_ = "NAME"
        let userIdKey_ = "USER_ID"
        let userRoleIdKey_ = "ROLE_ID"
        let mapped_departments_id_key  = "DEPARTMENTS_MAPPED"
        let photo_key = "PHOTO"
        
         name.text = UserDefaults.standard.string(forKey: nameKey_)!
        designation.text = UserDefaults.standard.string(forKey: designationKey_)!
        mobile.text = UserDefaults.standard.string(forKey: mobileNumberKey_)!
    }
    
    @IBAction func clickedOnButton(_ sender: Any) {
        self.delegate?.hideHamburgerMenu()
    }
}

