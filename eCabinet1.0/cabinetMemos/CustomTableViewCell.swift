import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
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
        
        
        if two.caseInsensitiveCompare("Backwarded") == .orderedSame{
          //  memoImage?.image = UIImage(named:"sent_back_memos")!
            self.memoImage.image = UIImage(named:"sent_back_memos")!.withInset(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
            contentThree.isHidden = false
            contentThree.text = "\(one.DeptName.base64Decoded!)"
            contentTwo.isHidden = true
            currentlyWithTime.isHidden = true
        }else  if two.caseInsensitiveCompare("Forwarded") == .orderedSame{
          //  memoImage?.image = UIImage(named:"forward_memos")!
            self.memoImage.image = UIImage(named:"forward_memos")!.withInset(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
            contentThree.isHidden = false
            contentThree.text = "\(one.DeptName.base64Decoded!)"
           // contentThree.text = "\(one.Currentlywith.base64Decoded!)"
            contentTwo.isHidden = true
            currentlyWithTime.isHidden = false
            currentlyWithTime.text = "Currently With:- \(one.Currentlywith.base64Decoded!)"
             // contentTwo.text = "\(one.DeptName.base64Decoded!)"
             //memoImage!.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        }else  if two.caseInsensitiveCompare("Current") == .orderedSame{
            //memoImage?.image = UIImage(named:"cabinet_memos")!
            self.memoImage.image = UIImage(named:"cabinet_memos")!.withInset(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
            contentThree.isHidden = false
            contentThree.text = "Item Number:- \(one.AgendaItemType.base64Decoded!)"
            contentTwo.isHidden = false
            contentTwo.text = "\(one.DeptName.base64Decoded!)"
             memoImage!.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            currentlyWithTime.isHidden = true
        }else if two.caseInsensitiveCompare("CabinetDecisions") == .orderedSame{
            currentlyWithTime.isHidden = true
            contentThree.text = "Agenda Number:- \(one.AgendaItemType.base64Decoded!)"
            
            contentTwo.text = "Agenda Type:- \(one.AgendaItemNo.base64Decoded!)"
            contentThree.isHidden = false
            contentTwo.isHidden = true
        }else if two.caseInsensitiveCompare("PlacedInCabinet") == .orderedSame{
            currentlyWithTime.isHidden = true
            contentThree.text = "Date:- \(one.Meetingdate.base64Decoded!)   Item Number:- \(one.AgendaItemType.base64Decoded!)"
            contentTwo.text = "Agenda Type:- \(one.AgendaItemNo.base64Decoded!)"
            contentThree.isHidden = false
            contentTwo.isHidden = true
        }
        
        contentOne.text = one.Subject.base64Decoded!
        contentOne.contentMode = .scaleToFill
        contentOne.numberOfLines = 10
        contentOne.lineBreakMode = .byWordWrapping
        
    }
    
    
}
