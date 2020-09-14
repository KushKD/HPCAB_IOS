//
//  CabinetMemosController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/14/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit

class CabinetMemosController: UIViewController {

   
    var dept_id: String = ""
    var param: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dept_id)
         print(param)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func goBack(_ sender: Any) {
        
      
        
     UIApplication.setRootView(MainViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
