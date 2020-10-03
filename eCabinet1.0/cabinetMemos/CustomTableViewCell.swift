import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
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
    
    func commonInit(_ one: CabinetMemo, _ two: String){
       
          
        if two.caseInsensitiveCompare("Backwarded") == .orderedSame{
            memoImage?.image = UIImage(named:"sent_back_memos")!
            contentThree.isHidden = false
                        contentThree.text = "\(one.DeptName.base64Decoded!)"
                       contentTwo.isHidden = true
        }else  if two.caseInsensitiveCompare("Forwarded") == .orderedSame{
            memoImage?.image = UIImage(named:"forward_memos")!
            contentThree.isHidden = false
             contentThree.text = "\(one.DeptName.base64Decoded!)"
            contentTwo.isHidden = true
           //  contentTwo.text = "\(one.DeptName.base64Decoded!)"
           // memoImage!.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        }else  if two.caseInsensitiveCompare("Current") == .orderedSame{
            memoImage?.image = UIImage(named:"cabinet_memos")!
            contentThree.isHidden = false
             contentThree.text = "Item Number:- \(one.AgendaItemType.base64Decoded!)"
                      contentTwo.isHidden = true
           // memoImage!.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        }else if two.caseInsensitiveCompare("CabinetDecisions") == .orderedSame{
                 contentThree.text = "Agenda Number:- \(one.AgendaItemType.base64Decoded!)"
            
                  contentTwo.text = "Agenda Type:- \(one.AgendaItemNo.base64Decoded!)"
                  contentThree.isHidden = false
                    contentTwo.isHidden = true
        }else if two.caseInsensitiveCompare("PlacedInCabinet") == .orderedSame{
                 contentThree.text = "Date:- \(one.Meetingdate.base64Decoded!)   Item Number:- \(one.AgendaItemType.base64Decoded!)"
                  contentTwo.text = "Agenda Type:- \(one.AgendaItemNo.base64Decoded!)"
                  contentThree.isHidden = false
                    contentTwo.isHidden = true
        }
        
        contentOne.text = one.Subject.base64Decoded!
        contentOne.contentMode = .scaleToFill
        contentOne.numberOfLines = 5
        contentOne.lineBreakMode = .byWordWrapping
      
    }
    
    
}
