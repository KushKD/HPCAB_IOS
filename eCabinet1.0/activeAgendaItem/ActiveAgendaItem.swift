//
//  ActiveAgendaItem.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 4/16/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

class ActiveAgendaItem: UIViewController {
    
    
    @IBOutlet weak var activeAgendaItem: UILabel!
    @IBOutlet weak var activeAgendaDeptName: UILabel!
    @IBOutlet weak var activeAgendaType: UILabel!
    @IBOutlet weak var activeAgendaSubject: UILabel!
    
    @IBOutlet weak var back: UIButton!
  
    let alertService = AlertService();
    var appUtilities = UtilitiesApp();
    var networkUtility = NetworkUtility();
    var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                           
                            self.activeAgendaItem.text  = agenda.AgendaItemNo.base64Decoded!
                            self.activeAgendaType.text  = agenda.AgendaItemType.base64Decoded!
                            
                            self.activeAgendaDeptName.text = agenda.DeptName.base64Decoded!
                            
                            self.activeAgendaSubject.text =
                                agenda.Subject.base64Decoded!
                        })
                        
                        
                        
                    }else{
                       // Hide the StackView and Show the Slider
                       //No Agenda Available
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
    
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
