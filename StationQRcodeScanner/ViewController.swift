//
//  ViewController.swift
//  StationQRcodeScanner
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 VictorBasic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        let url = URL(string: "http://139.162.76.87/api/v1/login")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.httpMethod = "POST"
        
        
        let loverDictionary = ["email": emailText.text!, "password":passwordText.text!]
        
        do {
            
            print("loverDictionary \(loverDictionary)")
            
            let data = try  JSONSerialization.data(withJSONObject: loverDictionary, options: [])
            let task = URLSession.shared.uploadTask(with: request, from: data) { (data, res, err) in
                let str = String(data: data!, encoding: .utf8)
                print("result \(str)")
                DispatchQueue.main.sync {
                    let name = Notification.Name("addData")
                    NotificationCenter.default.post(name: name, object: nil, userInfo: loverDictionary)
                    
                    _ = self.navigationController?.popViewController(animated: true )
                    
                    
                }
            }
            task.resume()
        }
        catch {
        }
        
        let lightGreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeScanner")
        present(lightGreen, animated: true, completion: nil)

 //       present(controller, animated: true, completion: nil)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

