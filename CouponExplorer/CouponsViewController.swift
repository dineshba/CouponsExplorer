import UIKit

struct Coupon {
    public let key: String
    public let message: String
    public let owner: String
    public let aadhar: String
    
    init(key: String, value: [String:Any]) {
        self.key = key
        self.message = value["message"] as! String
        self.owner = value["owner"] as! String
        self.aadhar = value["aadhar"] as! String
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
        self.navigationItem.title = "Coupons"
        super.viewDidLoad()
        fetchCoupons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func fetchCoupons() {
        let urlString = "http://ec2-13-127-161-80.ap-south-1.compute.amazonaws.com:8080/coupons-explorer"
        guard let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url){(data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
            }
            guard let data = data else {return}
            do {
                guard let couponsJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: [String: Any]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                self.coupons = couponsJson.map({ (args) -> Coupon in
                    let (key, value): (String, [String: Any]) = args
                    return Coupon(key: key, value: value)
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

