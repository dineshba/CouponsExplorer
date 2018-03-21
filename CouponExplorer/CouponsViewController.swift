import UIKit
struct CData {
    let sign: String
    let publicKey: String
    let txnid: String
    let email: String
    let location: String
    let createdAt: String
    let type: String
    
    public init(sign: String,publicKey: String,txnid: String,email: String,location: String,createdAt: String,type: String){
        self.sign = sign
        self.publicKey = publicKey
        self.txnid = txnid
        self.email = email
        self.type = type
        self.location = location
        self.createdAt = createdAt
    }
}

struct Coupon {
    let key: String
    let nonce: String
    let publicKey: String
    let prevHash: String
    let data: [CData]
    
    public init(value: [String: Any]) {
        let dataJson = value["data"] as? [[String:String]]
//        let data = dataJson.map { (a: [String:String]) -> CData in
//            let sign = a["sign"]
//            let publicKey = a["publicKey"]
//            let txnid = a["txnid"]
//            let email = a["email"]
//            let location = a["location"]
//            let createdAt = a["createdAt"]
//            CData(sign,publicKey,txnid,email,location,createdAt)
//        }
    
        if let data = dataJson?.map({ (args: [String: String]) -> CData in
            let txnid = args["txnid"]
            let sign = args["sign"]
            let publicKey = args["publicKey"]
            let type = args ["type"]
            let createdAt = args["createdAt"]
            var email = ""
            var location = ""
            if type == "create"{
                email = args["email"]!
            }
            if type == "redeem"{
               location = args["location"]!
            }
          
            return CData(sign: sign!, publicKey: publicKey!, txnid: txnid!, email: email, location: location, createdAt: createdAt!, type: type!)
        }) {
            self.data = data
        } else {
            self.data = []
        }
//        self.data = []
        self.key = value["blockSign"] as! String
        self.nonce = value["nonce"] as! String
        self.publicKey = value["publicKey"] as! String
        self.prevHash = value["prevHash"] as! String
    }
}

class CouponsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "couponsCell", for: indexPath) as! CouponTableViewCell
        let coupon = self.coupons[indexPath.row]
        cell.configure(coupon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "couponDetails", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let couponDetailsViewController = segue.destination as? CouponDetailsViewController, let index = sender as? Int {
            let coupon = self.coupons[index]
            couponDetailsViewController.coupon = coupon
            if index > 0 {
                couponDetailsViewController.previousCouponSignature = self.coupons[index - 1].key
            }
        }
    }

    var coupons: [Coupon] = []

    override func viewDidLoad() {
        let nib = UINib(nibName: "CouponTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "couponsCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100.0;
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Coupon Explorer"
        super.viewDidLoad()
        fetchCoupons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func fetchCoupons() {
        let urlString = "http://ec2-13-127-161-80.ap-south-1.compute.amazonaws.com:8080/coupons"
        guard let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url){(data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
            }
            guard let data = data else {
                print("No data to decode")
                return}
            
            do {
                guard let couponsJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [[String: Any]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                self.coupons = couponsJson.map({ (args) -> Coupon in
                    let (value): ([String: Any]) = args
                    return Coupon(value: value)
                })
            } catch {
                print("catch")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }.resume()
    }

}

