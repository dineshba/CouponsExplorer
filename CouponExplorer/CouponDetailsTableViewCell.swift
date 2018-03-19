import UIKit

class CouponDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, message: String) {
        self.title.text = title
        self.message.text = message
    }
    
}
