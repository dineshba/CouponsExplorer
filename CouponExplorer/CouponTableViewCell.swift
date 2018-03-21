import UIKit

class CouponTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var transactionType: UILabel!
   
    @IBOutlet weak var secondCreatedAt: UILabel!
    
    @IBOutlet weak var secondTransactionType: UILabel!
    @IBOutlet weak var secondMessageLabel: UILabel!
    
    
    @IBOutlet weak var SecondStackView: UIStackView!
    @IBOutlet weak var FirstStackView: UIStackView!
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
        
        if coupon.data.count == 1{
        self.SecondStackView.isHidden = true
        }
        else{
            self.secondCreatedAt.text = coupon.data[1].createdAt
            self.secondMessageLabel.text = coupon.data[1].txnid
            self.secondTransactionType.text = coupon.data[1].type
        }
    }
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

