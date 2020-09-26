//
//  MemoAttachmentsController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/23/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit
import WebKit

class MemoAttachmentsController: UIViewController {
    var listToShow = [ListAnnuxtures]()
       @IBOutlet weak var heading: UILabel!
       @IBOutlet weak var back: UIButton!
       @IBOutlet weak var tableView: UITableView!
       let alertService = AlertService();
       var activirtIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(listToShow)
              tableView.delegate = self
              tableView.dataSource = self
              let nib = UINib.init(nibName: "AttachmentTableViewCell", bundle: nil)
              tableView.register(nib, forCellReuseIdentifier: "tableCellMemosAttachments")
        // Do any additional setup after loading the view.
    }
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
        
        let url = URL(string: self.listToShow[indexPath.row].Attachment.base64Decoded!)
        FileDownloader.loadFileSync(url: url!) { (path, error) in
            print("PDF Fil downloaded to : \(path!)")
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
