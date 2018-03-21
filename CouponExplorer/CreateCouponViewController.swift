//
//  CreateCouponViewController.swift
//  CouponExplorer
//
//  Created by SHUKLA on 21/03/18.
//  Copyright © 2018 Thoughtworks. All rights reserved.
//

import UIKit
import Alamofire

class CreateCouponViewController: UIViewController {
    @IBOutlet var couponId: UILabel!
    @IBOutlet var textEntry: UITextField!
    
    @IBAction func loginTapped(_ sender: Any) {
        networkCall({
            DispatchQueue.main.async {
                self.view.makeToast("Coupon Created")
            }})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func networkCall(_ completion: @escaping () -> Void) {
        let urlString = "http://ec2-13-127-161-80.ap-south-1.compute.amazonaws.com:8080/createApi"
   
        Alamofire.request(urlString, method: .post, parameters:
            ["sign": "MFkwEw",
             "txnid": textEntry.text as! String,
             "email": "dummyEmail@anymail.com"
            ], encoding: URLEncoding(destination: .queryString)).response {
                response in
                if response.response?.statusCode == 200 {
                    let responseString = String(data: response.data!, encoding: .utf8)
                    print("responseString = \(String(describing: responseString))")
                    completion()
                }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
