//
//  ViewSwiftController.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 4/9/21.
//  Copyright © 2021 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

class ViewSwiftController: UITableViewCell {
    
    
    @IBOutlet weak var memoImage: UIImageView!
    
    @IBOutlet weak var contentTwo: UILabel!
    @IBOutlet weak var contentOne: UILabel!
    @IBOutlet weak var contentThree: UILabel!
    
    @IBOutlet weak var currentlyWithTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func commonInit(_ one: CabinetMemo, _ two: String){
        
        memoImage?.layer.masksToBounds = true
        memoImage?.layer.borderWidth = 0.5
        let margin:CGFloat = 16
        
        memoImage?.layer.borderColor = UIColor.white.cgColor
       // memoImage?.layer.cornerRadius = memoImage.bounds.width / 2
        
        
       
          //  memoImage?.image = UIImage(named:"forward_memos")!
            self.memoImage.image = UIImage(named:"cabinet_memos")!.withInset(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
            contentThree.isHidden = false
            contentThree.text = "Date:- \(one.Meetingdate.base64Decoded!)"
           // contentThree.text = "\(one.Currentlywith.base64Decoded!)"
            contentTwo.isHidden = false

        currentlyWithTime.text =  "Agenda Type:-  \(one.AgendaItemType.base64Decoded!)  (\(one.DeptName.base64Decoded!))"
            contentTwo.text = "\(one.Subject.base64Decoded!)"
             //memoImage!.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
     
        
        contentOne.text = "Item Number:- \(one.AgendaItemNo.base64Decoded!)"
        contentTwo.contentMode = .scaleToFill
        contentTwo.numberOfLines = 10
        contentTwo.lineBreakMode = .byWordWrapping
        
    }
    
    
}
