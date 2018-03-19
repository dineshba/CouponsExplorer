import UIKit

class CouponDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var coupon: Coupon!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Coupon Details"
        let nib = UINib(nibName: "CouponDetailsTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "couponCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell") as! CouponDetailsTableViewCell
        if indexPath.section == 0 {
            let (title, message) = self.getTitleAndMessage(at: indexPath.row)
            cell.configure(title: title, message: message)
        } else {
            cell.configure(title: "Message", message: self.coupon.message)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Messages"
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func getTitleAndMessage(at index: Int) -> (String, String) {
        switch index {
        case 0:
            return ("Signature", self.coupon.key)
        case 1:
            return ("Owner", self.coupon.owner)
        case 2:
            return ("Aadhar", self.coupon.aadhar)
        default:
            return ("key", "value")
        }
        
    }

}
