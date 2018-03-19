//
//  DetailsViewController.swift
//  CouponExplorer
//
//  Created by SHUKLA on 19/03/18.
//  Copyright © 2018 Thoughtworks. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController{
    var scannedCode: String?
    var dictonary:NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(scannedCode!)
        let url = URL(string: "http://ec2-13-127-161-80.ap-south-1.compute.amazonaws.com:8080/create")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "sign=MFkwEw&message="+scannedCode!+"&owner=Dev&aadhar=122"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
           
        }
        task.resume()
//        let urlString = "http://ec2-13-127-161-80.ap-south-1.compute.amazonaws.com:8080/create?sign=MFkwEw&message="+scannedCode!+"&owner=Dev&aadhar=122"
//        print(urlString)
//        guard let url = URL(string: urlString) else{return}
//        URLSession.shared.dataTask(with: url){(data, response, error) in
//            if error != nil{
//                print(error!.localizedDescription)
//            }
//            guard let data = data else {return}
//            print(data)
//
//            }.resume()
        view.addSubview(codeLabel)
        codeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        codeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        codeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        if let scannedCode = scannedCode {
            codeLabel.text = scannedCode
        }
        
        view.addSubview(scanButton)
        scanButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scanButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
    
    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.textAlignment = .center
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    lazy var scanButton:UIButton = {
        let scanButton = UIButton(type: .system)
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        scanButton.backgroundColor = .orange
        scanButton.layer.cornerRadius = 25
        scanButton.addTarget(self, action: #selector(displayScannerViewController), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        
        return scanButton
    }()
    
    @objc func displayScannerViewController() {
        print("123")
        let scanViewController = ScanViewController()
        //navigationController?.pushViewController(scanViewController, animated: true)
        //navigationController?.present(scanViewController, animated: true, completion: nil)
        present(scanViewController, animated: true, completion: nil)
    }
}

