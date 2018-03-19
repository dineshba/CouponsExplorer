import UIKit
import Toast_Swift
import Alamofire

class CouponDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var coupon: Coupon!
    var previousCouponSignature: String = ""
    let publicKey: String = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEg852ykK06NGb/LwK3SEJoDH+QUXXxddlZ66raHOwqm1XR5fjjTo+LAc7qBobFcMtJqFcSWLxWmqcK96hxM+1ZQ=="
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBAction func verifyTapped(_ sender: Any) {
//        networkCall()
        networkCall1()
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = self.view.center
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            activityView.stopAnimating()
            self.view.makeToast("Coupon Verified")
        })
    }
    
    func networkCall1() {
        let urlString = "http://ec2-13-127-161-80.ap-south-1.compute.amazonaws.com:8080/verify"
        let postString = "sign=\(self.coupon.key)&data=\(self.coupon.message + self.coupon.owner + self.coupon.aadhar + self.previousCouponSignature)&pubKey=\(self.publicKey)"
        
        Alamofire.request(urlString, method: .post, parameters:
            ["sign": self.coupon.key,
             "data": self.coupon.message + self.coupon.owner + self.coupon.aadhar + self.previousCouponSignature,
             "pubKey": self.publicKey
            ]).response {
            response in
                if response.response?.statusCode == 200 {
                    let responseString = String(data: response.data!, encoding: .utf8)
                    print("responseString = \(String(describing: responseString))")
                }
        }
    }
    
    func networkCall() {
        let url = URL(string: "http://ec2-13-127-161-80.ap-south-1.compute.amazonaws.com:8080/verify")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "sign=\(self.coupon.key)&data=\(self.coupon.message + self.coupon.owner + self.coupon.aadhar + self.previousCouponSignature)&pubKey=\(self.publicKey)"
        request.httpBody = postString.data(using: .utf8)
        print(request.httpBody)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.verifyButton.backgroundColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
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
        } else if indexPath.section == 1 {
            cell.configure(title: "Message", message: self.coupon.message)
        } else if indexPath.section == 2 {
            cell.configure(title: "Key", message: publicKey)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Messages"
        } else if section == 2 {
            return "Your Public Key"
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func getTitleAndMessage(at index: Int) -> (String, String) {
        switch index {
        case 0:
            return ("Signature", String(self.coupon.key.reversed()))
        case 1:
            return ("Owner", self.coupon.owner)
        case 2:
            return ("Aadhar", self.coupon.aadhar)
        default:
            return ("key", "value")
        }
        
    }

}
