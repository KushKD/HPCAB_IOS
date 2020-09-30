//
//  DownloadServiceDialog.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/27/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

class DownloadServiceDialog {
    
    func downloadAlert(title: String, body: String, buttonTitle: String, url_: String, completion: @escaping () -> Void) -> DownloadAlert {
        
        let storyboard = UIStoryboard(name: "DownloadAlert", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertDownload") as! DownloadAlert
        
        alertVC.alertTitle = title
        
        alertVC.urlServer = url_
        
        alertVC.alertBody = body
        
        alertVC.actionButtonTitle = buttonTitle
        
        alertVC.buttonAction = completion
        
        return alertVC
    }
}
