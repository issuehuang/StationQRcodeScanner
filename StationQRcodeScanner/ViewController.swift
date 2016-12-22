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
        
        if let emailString = emailText.text, let passwordString = passwordText.text{
            if emailString != "" && passwordString != "" {
                
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
                    let lightGreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeScanner")
                    present(lightGreen, animated: true, completion: nil)
                    
                }
                catch {
                    print("error\(error.localizedDescription)")
                }
            }else{
                 showAlert(title: "Opps!", message: "請輸入email和密碼")
            }
            
        }
        
    }
    
//    print("YOOOOOOOOOOOOOOOO")
//    //使用者按下log in 按鈕，打算登入
//    if let emailString = userTextInput.text, let passwordString = passwordTextInput.text{ print("HELLO")
//        //如果不是沒有值的話就作下列判斷
//        if emailString != "" && passwordString != ""{
//            //如果不是空字串的話就登入
//            FIRAuth.auth()?.signIn(withEmail: emailString, password: passwordString, completion: { (user, error) in
//                if error != nil{
//                    //如果登入過程有錯誤的話...
//                    self.showAlert(title:"登入失敗",message:"原因:\(error?.localizedDescription)")
//                    return
//                }
//                //如果登入順利的話ob
//                self.showAlert(title:"順利登入", message: "歡迎回來")
//                self.signOutButton.isHidden = false
//            })
//            userTextInput.text = ""
//            passwordTextInput.text = ""
//        }else{
//            showAlert(title: "Opps!", message: "請輸入email和密碼")
//        }
//        
//        
//    }
//    
//}



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAlert(title:String?,message:String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert,animated: true, completion:  nil)
    }

}

