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
                launchHomePage()
            }
        }
    }
    
    func launchHomePage() {
        self.performSegue(withIdentifier: "homePage", sender: nil)
    }
}
