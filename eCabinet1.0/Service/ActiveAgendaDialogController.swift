//
//  ActiveAgendaDialogController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 2/3/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

class ActiveAgendaDialogController {
    
    func alert(data: ActiveAgenda, completion: @escaping () -> Void) -> ActiveAgendaController {
        
        let storyboard = UIStoryboard(name: "ActiveAgendaStoryBoard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "active_agenda_alert") as! ActiveAgendaController
        
        alertVC.agendaNumber_ = data.AgendaItemNo
        
        alertVC.agendaType_ = data.AgendaItemType
        
        alertVC.subject_ = data.Subject
        
        alertVC.deptName_ = data.DeptName
        alertVC.fileNumber_ = data.FileNo
        
        return alertVC
    }
}
