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
   // @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var tableView: UITableView!
   // @IBOutlet weak var progressLabel: UILabel!
    let alertService = AlertService();
    let downloadServiceDialog = DownloadServiceDialog();
    var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var documentInteractionController: UIDocumentInteractionController!
    
    private let downloadManager = SDDownloadManager.shared
    let directoryName : String = "b"

    
    // fileprivate var downloadTask1:  DownloadTask?
    
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        DownloadManager.shared.onProgress = { (progress) in
//            OperationQueue.main.addOperation {
//                self.progressView.progress = progress
//            }
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        DownloadManager.shared.onProgress = nil
//    }
    @IBAction func goBack(_ sender: Any) {
        //UIApplication.setRootView(MainViewController.instantiate(from: .Main), options: UIApplication.logoutAnimation)
        self.dismiss(animated: true, completion: nil)
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
       
      //  let _ = DownloadManager.shared.activate()
        let string = self.listToShow[indexPath.row].Attachment.base64Decoded!
       // downloadServiceDialog
        
        if string.isValidURL {
            DispatchQueue.main.async(execute: {
                           
                let downloadAlert = self.downloadServiceDialog.downloadAlert(title: "Downloading Attachment", body: self.listToShow[indexPath.row].Attachment.base64Decoded!  , buttonTitle: "OK")
                           { [weak self] in
                               //Go to the Next Story Board
                               //  UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                            self?.dismiss(animated: true, completion: nil)
                           }
                           self.present(downloadAlert, animated: true)
                       })
          
            
            
        }else{
            //Alert
            DispatchQueue.main.async(execute: {
                
                let alertVC = self.alertService.alert(title: " Message", body:  "Not a valid URL", buttonTitle: "OK")
                { [weak self] in
                    //Go to the Next Story Board
                    //  UIApplication.setRootView(MainViewController.instantiate(from:.Main))
                }
                self.present(alertVC, animated: true)
            })
        }
        
        
        // let url = URL(string: "http://legislative.gov.in/sites/default/files/A1956-32_0.pdf")
        //       let url = URL(string: self.listToShow[indexPath.row].Attachment.base64Decoded!)
        //        let webView = WKWebView(frame: view.frame)
        //        let urlRequest = URLRequest(url: url!)
        //        webView.load(urlRequest)
        //        view.addSubview(webView)
        //Show Alert
        //        DispatchQueue.main.async(execute: {
        //
        //            let alertVC = self.alertService.alert(title: " Message", body:  self.listToShow[indexPath.row].Attachment.base64Decoded!, buttonTitle: "OK")
        //            { [weak self] in
        //                //Go to the Next Story Board
        //                //  UIApplication.setRootView(MainViewController.instantiate(from:.Main))
        //            }
        //            self.present(alertVC, animated: true)
        //        })
        
    }
    
}

extension MemoAttachmentsController: UIDocumentInteractionControllerDelegate {
func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
     return self
 }
}
