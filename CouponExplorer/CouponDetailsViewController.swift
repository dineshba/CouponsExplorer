import UIKit
import Toast_Swift
import Alamofire

class CouponDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var coupon: Coupon!
    var previousCouponSignature: String = ""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBAction func verifyTapped(_ sender: Any) {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = self.view.center
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        
        networkCall({success in
            DispatchQueue.main.async {
                activityView.stopAnimating()
                if success {
                    self.view.makeToast("Coupon Verified")
                } else {
                    self.view.makeToast("Coupon Not Verified")
                }
            }
        })
    }
    
    func networkCall(_ completion: @escaping (Bool) -> Void) {
        let urlString = "http://ec2-13-127-161-80.ap-south-1.compute.amazonaws.com:8080/verifyApi"
        var TxnSign = ""
        for var i in 0..<coupon.data.count{
            TxnSign = TxnSign + coupon.data[i].sign
        }
        let payLoad = (self.coupon.nonce + self.coupon.publicKey + self.coupon.prevHash + TxnSign).replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        
        Alamofire.request(urlString, method: .post, parameters:
            ["sign": self.coupon.key,
             "data": payLoad,
             "publicKey": self.coupon.publicKey
            ], encoding: URLEncoding(destination: .queryString)).response {
            response in
                if response.response?.statusCode == 200 {
                    let responseString = String(data: response.data!, encoding: .utf8)
                    print("responseString = \(String(describing: responseString))")
                    completion(true)
                } else {
                    completion(false)
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.verifyButton.backgroundColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.title = "Block Details"
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
        } else if(indexPath.section != 0 && indexPath.section < self.coupon.data.count+1) {
            for var i in 1..<self.coupon.data.count+1 {
                let (title, message) = self.getTranDetails(at: indexPath.row)
                cell.configure(title: title, message: message)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Block Data"
        }
        for var i in 1..<self.coupon.data.count+1 {
            if section == i {
                return "Transaction "+String(i)
            }
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.coupon.data.count + 1
    }
    
    func getTitleAndMessage(at index: Int) -> (String, String) {
        switch index {
        case 0:
            return ("Signature", String(self.coupon.key.reversed()))
        case 1:
            return ("Nonce", self.coupon.nonce)
        case 2:
            return ("Public Key", self.coupon.publicKey)
        case 3:
            return ("Previous Hash", self.coupon.prevHash)
        default:
            return ("key", "value")
        }
        
        
    }
    func getTranDetails(at index: Int) -> (String, String){
        switch index{
        case 0:
            return ("Signature", self.coupon.data[0].sign)
        case 1:
            return ("Public Key", self.coupon.data[0].publicKey)
        case 2:
            return("Txn Id", self.coupon.data[0].txnid)
        case 3:
            return("Created at", self.coupon.data[0].createdAt)
        case 4:
            if(self.coupon.data[0].type == "create") {
                return("Email", self.coupon.data[0].email)
            }
            return("Location", self.coupon.data[0].location)
        default:
            return ("key", "value")
        }
    }

}
