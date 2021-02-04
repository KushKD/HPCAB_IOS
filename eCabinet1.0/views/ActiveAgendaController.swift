//
//  ActiveAgendaController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 2/3/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

class ActiveAgendaController: UIViewController {
    
   
    @IBOutlet weak var agendaNumber: UILabel!
    @IBOutlet weak var fileNumber: UILabel!
    @IBOutlet weak var agendaType: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var deptName: UILabel!
    
    var agendaNumber_ = String()
    
    var fileNumber_ = String()
    
    var agendaType_ = String()
    
    var subject_ = String()
    
    var deptName_: String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
}

