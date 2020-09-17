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
    
    func commonInit(_ one: CabinetMemo){
        print("Inside Table Cell")
        contentOne.text = one.Subject.base64Decoded!
        contentOne.contentMode = .scaleToFill
        contentOne.numberOfLines = 5
        contentOne.lineBreakMode = .byWordWrapping
        contentTwo.text = "Agenda Number:- \(one.AgendaItemType.base64Decoded!)"
        contentThree.text = one.DeptName.base64Decoded!
        contentThree.isHidden = true
    }
    
    
}
