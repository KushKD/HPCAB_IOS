//
//  CabinetHistoryTableViewCell.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/22/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit

class CabinetHistoryTableViewCell: UITableViewCell {
        @IBOutlet weak var memoImage: UIImageView!
        
        @IBOutlet weak var contentTwo: UILabel!
        @IBOutlet weak var contentOne: UILabel!
        @IBOutlet weak var contentThree: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()

        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
        func commonInit(_ one: ListCabinetMemoTrackingHistoryLists){
            print("Inside Table Cell")
            
            memoImage?.layer.masksToBounds = true
            memoImage?.layer.borderWidth = 0.5
            let margin:CGFloat = 16
            
            memoImage?.layer.borderColor = UIColor.white.cgColor
            contentOne.text = one.Action.base64Decoded!
            contentOne.contentMode = .scaleToFill
            contentOne.numberOfLines = 5
            contentOne.lineBreakMode = .byWordWrapping
            contentTwo.text = "Date:- \(one.Date.base64Decoded!)"
           // contentThree.text = one.DeptName.base64Decoded!
            contentThree.isHidden = true
        }
        
    
}
