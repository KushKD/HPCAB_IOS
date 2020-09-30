//
//  MemoAttachmentsController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/23/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

class MemoAttachmentsController: UIViewController {
    var listToShow = [ListAnnuxtures]()
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let alertService = AlertService();
    let downloadServiceDialog = DownloadServiceDialog();
    var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var documentInteractionController: UIDocumentInteractionController!
    
  
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(listToShow)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        self.documentInteractionController?.delegate = self
        self.documentInteractionController?.presentPreview(animated: true)
        
        
        let nib = UINib.init(nibName: "AttachmentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "tableCellMemosAttachments")
        // Do any additional setup after loading the view.
        
    }
    
 
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
}

extension MemoAttachmentsController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellMemosAttachments", for: indexPath) as? AttachmentTableViewCell
        cell?.commonInit(listToShow[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listToShow[indexPath.row].Attachment.base64Decoded!)
        

        let string = self.listToShow[indexPath.row].Attachment.base64Decoded!
        
        if string.isValidURL {
            
            
            if Reachability.isConnectedToNetwork(){
                DispatchQueue.main.async(execute: {
                    
                    let downloadAlert = self.downloadServiceDialog.downloadAlert(title: "Downloading Attachment", body: self.listToShow[indexPath.row].AnnexureName.base64Decoded!  , buttonTitle: "OK", url_ : self.listToShow[indexPath.row].Attachment.base64Decoded!)
                    { [weak self] in
                        self?.dismiss(animated: true, completion: nil)
                    }
                    self.present(downloadAlert, animated: true)
                })
            }
            else{
                DispatchQueue.main.async(execute: {
                    let alertVC = self.alertService.alert(title: "Network Message", body: Constants.internetNotAvailable!, buttonTitle: "OK")
                    { [weak self] in
                       
                        
                    }
                    self.present(alertVC, animated: true)
                    
                })
            }
            
            
            
            
        }else{
            
            DispatchQueue.main.async(execute: {
                
                let alertVC = self.alertService.alert(title: " Message", body:  "Not a valid URL", buttonTitle: "OK")
                { [weak self] in
    
                }
                self.present(alertVC, animated: true)
            })
        }
        
        
        
    }
    
}

extension MemoAttachmentsController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
