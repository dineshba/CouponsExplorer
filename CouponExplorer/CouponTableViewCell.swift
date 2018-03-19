import UIKit

class CouponTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ coupon: Coupon) {
        self.messageLabel.text = coupon.message
        self.signatureLabel.text = String(coupon.key.reversed())
    }
    
}
