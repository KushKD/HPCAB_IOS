//
//  AlertViewController.swift
//  Custom Alerts
//
//  Created by Kyle Lee on 2/13/19.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    var appUtilities = UtilitiesApp()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var TopView: UIView!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    var alertTitle = String()
    
    var alertBody = String()
    
    var actionButtonTitle = String()
    
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        
        appUtilities.setHorizontalGradientColorPopUp(view: self.TopView)
        titleLabel.text = alertTitle
        
        bodyLabel.text = alertBody
        
        actionButton.setTitle(actionButtonTitle, for: .normal)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    
    @IBAction func didTapActionButton(_ sender: Any) {
        
        dismiss(animated: true)
        
        buttonAction?()
    }
    
}
