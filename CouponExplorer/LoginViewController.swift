//
//  LoginViewController.swift
//  CouponExplorer
//
//  Created by Dinesh Balasubramanian on 18/03/18.
//  Copyright © 2018 Thoughtworks. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBAction func loginTapped(_ sender: Any) {
        if let userName = userNameTextField.text, let password = passwordTextField.text {
            if userName == password {
                if userName == "Kroger" {
                    launchScanPage()
                } else if userName == "NAM" {
                    launchCouponsPage()
                }
            }
        }
    }
    
    func launchScanPage() {
        self.performSegue(withIdentifier: "scan", sender: nil)
    }
    func launchCreatePage() {
        
    }
    func launchCouponsPage() {
        self.performSegue(withIdentifier: "coupons", sender: nil)
    }
}
