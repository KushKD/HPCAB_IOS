//
//  AttachmentTableViewCell.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/23/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit

class AttachmentTableViewCell: UITableViewCell {

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
           
           func commonInit(_ one: ListAnnuxtures){
               print("Inside Table Cell")
               contentOne.text = one.AnnexureName.base64Decoded!
               contentOne.contentMode = .scaleToFill
               contentOne.numberOfLines = 5
               contentOne.lineBreakMode = .byWordWrapping
               contentTwo.text = "Date:- \(one.AnnexureID.base64Decoded!)"
              // contentThree.text = one.DeptName.base64Decoded!
               contentThree.isHidden = true
           }
    
}
