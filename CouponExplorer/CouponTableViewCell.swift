import UIKit

class CouponTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var transactionType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ coupon: Coupon) {
        self.messageLabel.text = coupon.data[0].txnid
        self.createdAt.text = coupon.data[0].createdAt
        self.transactionType.text = coupon.data[0].type
        self.signatureLabel.text = String(coupon.key.reversed())
    }
    
}
