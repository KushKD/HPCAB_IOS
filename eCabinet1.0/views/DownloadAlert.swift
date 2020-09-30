//
//  DownloadAlert.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/27/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation
import UIKit


class DownloadAlert : UIViewController {

    var appUtilities = UtilitiesApp()
   
    var directoryName : String = "Files"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var TopView: UIView!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    var alertTitle = String()
    
    var alertService  = AlertService()
    
    var alertBody = String()
    
    var labelprogress = String()
    
    var actionButtonTitle = String()
    
    var buttonAction: (() -> Void)?
    
    var urlServer: String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.setProgress(0, animated: false)
        self.progressLabel.text = "0.0 %"

        setupView()
    }

    func setupView() {
        
        appUtilities.setHorizontalGradientColorPopUp(view: self.TopView)
        titleLabel.text = alertTitle
        bodyLabel.text = alertBody
        actionButton.setTitle(actionButtonTitle, for: .normal)
          let downloadManager = SDDownloadManager.shared
          let _ = DownloadManager.shared.activate()
        directoryName.append(appUtilities.getDatess())
        //
        let url = URL(string: urlServer)!
        let request = URLRequest(url: url)
        let downloadKey = downloadManager.downloadFile(withRequest: request,
                                                                       inDirectory: directoryName,
                                                                       onProgress:  { [weak self] (progress) in
                                                                           let percentage = String(format: "%.1f %", (progress * 100))
                                                                           self?.progressView.setProgress(Float(progress), animated: true)
                                                                           self?.progressLabel.text = "\(percentage) %"
                   }) { [weak self] (error, url) in
                       if let error = error {
                                                   
                            DispatchQueue.main.async(execute: {
                                self!.dismiss(animated: true)
                               let alertVC = self!.alertService.alert(title: " Message", body:  "File Already Exist", buttonTitle: "OK")
                                         { [weak self] in
                                         }
                               self!.present(alertVC, animated: true)
                                     })
                                 
                       } else {
                           if let url = url {
                               print("Downloaded file's url is \(url.path)")
                            DispatchQueue.main.async(execute: {
                                                           self!.dismiss(animated: true)
                                let documento = NSData(contentsOfFile: url.path)
                                                              
                                                            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento!], applicationActivities: nil)
                                                             activityViewController.popoverPresentationController?.sourceView = self!.view
                                                              self?.present(activityViewController, animated: true, completion: nil)
                              
                            })
                           
                              
                               
                              
                              
                           }
                       }
                   }
                   
                   print("The key is \(downloadKey!)")
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
               
               buttonAction?()
    }
}

