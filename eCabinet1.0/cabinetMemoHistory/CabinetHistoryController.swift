//
//  CabinetHistoryController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/22/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit
import Foundation

class CabinetHistoryController: UIViewController {
    
    @IBOutlet weak var head: UIView!
    var listToShow = [ListCabinetMemoTrackingHistoryLists]()
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let alertService = AlertService();
    var appUtilities = UtilitiesApp();
    var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appUtilities.setHorizontalGradientColor(view: head)
        dump(listToShow)
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib.init(nibName: "CabinetHistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "tableCellMemosHistory")
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
    //UIApplication.setRootView(MainViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CabinetHistoryController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellMemosHistory", for: indexPath) as? CabinetHistoryTableViewCell
        cell?.commonInit(listToShow[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listToShow[indexPath.row])
        if listToShow[indexPath.row].Remarks.isEmpty{
            DispatchQueue.main.async(execute: {
                       
                       let alertVC = self.alertService.alert(title: " Message", body:  "Remarks Not Added ", buttonTitle: "OK")
                       { [weak self] in
                           //Go to the Next Story Board
                           //  UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                       }
                       self.present(alertVC, animated: true)
                   })
        }else{
            DispatchQueue.main.async(execute: {
                       
                       let alertVC = self.alertService.alert(title: " Message", body:  self.listToShow[indexPath.row].Remarks.base64Decoded!, buttonTitle: "OK")
                       { [weak self] in
                           //Go to the Next Story Board
                           //  UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                       }
                       self.present(alertVC, animated: true)
                   })
        }
        
    }
    
}

