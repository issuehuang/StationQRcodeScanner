//
//  ViewController.swift
//  StationQRcodeScanner
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 VictorBasic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
var appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController, UIPickerViewDataSource ,UIPickerViewDelegate {
  


    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var linePicker: UIPickerView!
    
    @IBOutlet weak var stationPicker: UIPickerView!
    let lineArray = ["板南線","新店線","文湖線","淡水線","中蘆線"]
    let blStationArray = ["南京復興"]
    let gStationArray = ["松江南京"]
    let brStationArray = ["大直"]
    let rStationArray = ["雙連"]
    let oStaionArray = ["行天宮"]
    var didSelectLineArray = "板南線" //
    var station1 = "1"
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    var loginJSON = [String:Any]()
    var loginStatus = ""
    var loginAuthToken = ""
    var loginUserID = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == linePicker{
            return lineArray.count
        }
        else{
            if didSelectLineArray == "板南線"{
                print("bl")
                return blStationArray.count
            }else if didSelectLineArray == "新店線"{
                print("g")
                return gStationArray.count
            }else if didSelectLineArray == "文湖線"{
                print("br")
                return brStationArray.count
            }else if didSelectLineArray == "淡水線"{
                print("R")
                return rStationArray.count
            }else if didSelectLineArray == "中蘆線"{
                print("y")
                return oStaionArray.count
            }else{
                print("有問題")
                return 0
            }
//                return 1
        }
    }
    //決定要顯示的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == linePicker{
            return lineArray[row]
        }else{
            if didSelectLineArray == "板南線"{
                return blStationArray[row]
            }else if didSelectLineArray == "新店線"{
                return gStationArray[row]
            }else if didSelectLineArray == "文湖線"{
                return brStationArray[row]
            }else if didSelectLineArray == "淡水線"{
                return rStationArray[row]
            }else if didSelectLineArray == "中蘆線"{
                return oStaionArray[row]
            }else{
            return blStationArray[row]
           }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == linePicker{
            if lineArray[row] == "板南線" {
                print("aaa")
                didSelectLineArray = "板南線"
            station1 = "1"
            }else if lineArray[row] == "新店線"{ // lineArray 的第一個等於didSelectLineArray
            didSelectLineArray = "新店線"
                station1 = "2"
                print("bbb")
            }else if lineArray[row] == "文湖線"{
            didSelectLineArray = "文湖線"
                station1 = "3"
                print("ccc")
            }else if lineArray[row] == "淡水線"{
                didSelectLineArray = "淡水線"
            station1 = "4"
                print("ddd")
            }else if lineArray[row] == "中蘆線"{
                didSelectLineArray = "中蘆線"
            station1 = "5"
            print("eee")
            }


            stationPicker.reloadAllComponents()
            
            print(didSelectLineArray)
        }else{
          //  print(brStationArray)
        }

    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("isLoginStatus",isLoginStatus)
//        print("token-->>",appDelegate.jsonBackToken)
//        print("UserID-->>",appDelegate.jsonBackUserID)
//        print(appDelegate)
//        if (appDelegate.jsonBackToken != "") &&  (appDelegate.jsonBackUserID != ""){
//            labelForUserNameDidLogin.text = appDelegate.userNameDidLogin
//            isLoginStatus = "Login"
//            print("登入狀態")
//        }else{
//            isLoginStatus = "Logout"
//            print("登出狀態")
//        }

        
    }
    
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
                    let task = URLSession.shared.uploadTask(with: request, from: data) {
                        (data, res, err) in
                        
                        if err == nil{ //如果錯誤= nil 意思就是沒有錯誤 執行下面這個程式碼
                            let str = String(data: data!, encoding: .utf8)
                            print("result \(str)")
                            
                            do{
                                try? self.loginJSON = JSONSerialization.jsonObject(with: data!) as! [String : Any]
                                let getTheJSON = "\(self.loginJSON["message"]!)"
                                print("getTheJSON:\(getTheJSON)")

                                if getTheJSON == "Ok"{
                                    
                                    requestData()

                                    
                                    print("有在這邊嗎")

                                    self.appDelegate.jsonBackToken = "\(self.loginJSON["auth_token"]!)" ?? ""
                                    self.appDelegate.jsonBackUserID = "\(self.loginJSON["user_id"]!)" ?? ""
                                    //  self.appDelegate.userNameDidLogin = self.textfieldUserName.text! ?? ""
                                    //   print("a=",a)
                                    //  print("b=",self.appDelegate.jsonBackToken)
                                    //  print("c=",self.appDelegate.jsonBackUserID)
                                    // if "\(a)" == "Ok" {
                                    print(self.appDelegate.jsonBackUserID)
                                    DispatchQueue.main.async {  //目前看起來沒有用
                                        //轉場去下一個畫面
                                        let lightGreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeScanner") as? QRcodeViewController
                                        lightGreen?.location = self.station1
                                        self.present(lightGreen!, animated: true, completion: nil)
                                        

                                        
                                        //                                          self.labelForUserNameDidLogin.text = "歡迎\((loginDataDictionary["email"])!)"
                                        //    self.showLogoutUI()
                                        //    self.textfieldUserName.text = ""
                                        //    self.textfieldUserPassword.text = ""
                                        //                                            if self.whoSend == "QRCodePage"{
                                        //                                                print("切換回去")
                                        //                                                self.whoSend = "" //清空
                                        //                                                self.navigationController?.popViewController(animated: true)  轉到下一頁
                                        //                                                self.tabBarController?.selectedIndex = 2
                                        //                                                //self.dismiss(animated: true, completion: nil) //ok
                                        //                                                //                    return self.loginJson
                                        //                                            }
                                    }
                                    // }
                                }else{
                                    DispatchQueue.main.sync {
                                        let name = Notification.Name("addData")
                                        NotificationCenter.default.post(name: name, object: nil, userInfo: loverDictionary)
                                        
                                        _ = self.navigationController?.popViewController(animated: true )
                                    }
                                }
                            }catch{
                                print(err)
                            }
                        }else{
                            print(err) // 若有錯誤列印錯誤
                        }
                    }
                    task.resume()
                    
                                 }
                catch {
                    print("error\(error.localizedDescription)")
                }
            }else{
                showAlert(title: "Opps!", message: "請輸入email和密碼")
            }
            
        }
        
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
func requestData(){
    let urlString = "http://139.162.76.87/api/v1/user/[:id]/show_last"
    let parameter:Parameters = [
        "auth_token" : appDelegate.jsonBackToken,
        "user_id":appDelegate.jsonBackUserID,
        "last_rent_history":appDelegate.jsonHistory,
        "charged_amount":appDelegate.jsonMoney
    ]
    Alamofire.request(urlString, parameters: parameter).responseJSON {
        (response) in
        switch response.result{
        case .success:
            let jsonPackage = JSON(response.result.value)
            //print("站點傘數量json資料包",json)
            let jsonArrayAllLocation = jsonPackage["last_rent_history"].string
            print("jsonPack",jsonPackage)
            //print("所有站點json資料包",jsonArrayAllLocation)
//           let jsonHistoryArray =
            
 //           let jsonArrayLocationName = jsonArrayAllLocation.first?["location_name"].stringValue
//           for i in 0...jsonArrayAllLocation.count-1{
//                let jsonArrayLocationName = jsonArrayAllLocation[i]["location_name"].stringValue ?? ""
//                let jsonArrayLocationLat = (jsonArrayAllLocation[i]["location_coordinate"]["latitude"]).doubleValue
//                let jsonArrayLocationLon = (jsonArrayAllLocation[i]["location_coordinate"]["longitude"]).doubleValue
//                let jsonArrayLocationPlaceID = jsonArrayAllLocation[i]["location_id"].stringValue ?? ""
//                let jsonArrayLocationRoute1a = jsonArrayAllLocation[i]["mrt_line"].arrayValue
//                let jsonArrayLocationRoute1b = jsonArrayLocationRoute1a.first?["line_name"].stringValue ?? ""
//                let jsonArrayLocationUMBNumber = jsonArrayAllLocation[i]["rentable_umbrella_number"].stringValue ?? ""
//                let distanceCalculate1 = CLLocation(latitude: jsonArrayLocationLat, longitude: jsonArrayLocationLon)
//                let distanceCalculate2 = self.userLocation?.distance(from: distanceCalculate1)
//                if distanceCalculate2 != nil{
//                    self.distanceCalculate3 =  Int(distanceCalculate2!)
//                }
//            }
//            
            DispatchQueue.main.async {
                
//                self.deCodeJsonStationResultSorted = self.deCodeJsonStationResult.sorted(by: { (lhs:StructStation, rhs:StructStation) -> Bool in
//                    return lhs.distanceFromUserToStation < rhs.distanceFromUserToStation
//                    // return lhs.distanceFromUserToStation > rhs.distanceFromUserToStation
//                    //return lhs.distanceFromUserToStation.compare(rhs.distanceFromUserToStation) == .orderedDescending
//                })
//                print(self.deCodeJsonStationResultSorted)
//                self.tableViewStationList.reloadData()
            }
            
            
        case .failure(let error):
            print(error)
            
        }
    }
    
    
    
    
}
// last







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
//
//    let numberArray = ["1","2","3","4","5","6","7","8"]
//    let fruitArray = ["apple","banana","mango","watermelon"]
//    let fruitArray2 = ["guava","pineapple","orange","chocolate"]
//
//    //1.picker view 有幾個component
//    func numberOfComponents(in pickerView: UIPickerView) -> Int{
//        return 2
//    }
//    //2.picker vieq 每個component有幾列，有幾個選項要顯示
//    func pickerView(_ pickerView:UIPickerView, numberOfRowsInComponent component: Int) ->Int {
//        if component == 0{
//            return numberArray.count
//        }else{
//            return fruitArray.count
//        }
//
//    }
//
//
//    //3.決定要顯示的內容
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
////        for i in 1...10
//        if component == 0{
//
//            return numberArray[row]
//
//        }else{
//            return fruitArray[row]
//        }
//
//
//    }
//    //4.選到某一列會觸發的方法
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if component == 0{
//            print("number:\(numberArray)[row])")
//        }else{
//            print("fruit:\(fruitArray[row])")
//        }
