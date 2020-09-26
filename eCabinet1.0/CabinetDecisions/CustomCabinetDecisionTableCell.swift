//
//  CustomCabinetDecisionTableCell.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/25/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit

class CustomCabinetDecisionTableCell: UITableViewCell {

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
       
       func commonInit(_ one: Dates, _ two: String){
          
             
//           if two.caseInsensitiveCompare("Backwarded") == .orderedSame{
//               memoImage?.image = UIImage(named:"sent_back_memos")!
//              // memoImage!.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//           }else  if two.caseInsensitiveCompare("Forwarded") == .orderedSame{
//               memoImage?.image = UIImage(named:"forward_memos")!
//              // memoImage!.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//           }else  if two.caseInsensitiveCompare("Current") == .orderedSame{
//               memoImage?.image = UIImage(named:"cabinet_memos")!
//              // memoImage!.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//           }
           
           contentOne.text = one.DepartmentName.base64Decoded!
           contentOne.contentMode = .scaleToFill
           contentOne.numberOfLines = 1
           contentOne.lineBreakMode = .byWordWrapping
           contentTwo.text = "Total Number:  - \(one.TotalCabinetMemos.base64Decoded!)"
           contentTwo.isHidden = false
           contentThree.text = "Date:  - \(one.MeetingDate.base64Decoded!)"
           contentThree.isHidden = false
       }
}
