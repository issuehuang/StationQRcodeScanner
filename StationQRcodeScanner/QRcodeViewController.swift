//
//  QRcodeViewController.swift
//  StationQRcodeScanner
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 VictorBasic. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class QRcodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    var location = "1"
    var counterOftouch = 0
    @IBOutlet weak var imageForScanner: UIView!
    var getTheCode:String?
    var sv:UIView?
    var counter = 30
    var timer:Timer?
    var scannerCount = true
    var jsonRentMoney2 = ""
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var qrcode = ""
    
    var catchJSONToNext:[String : String]?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //準備取用appDelegate的值
    
    var svc:StatusViewController?

    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        counter = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(QRcodeViewController.callingWaitingPage), userInfo: nil, repeats: true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("user_ID:\(appDelegate.jsonBackUserID)")
        print("Token:\(appDelegate.jsonBackToken)")
        print("staion1:\(location)")
        
        
        
        

        
        
      
        
 //       let timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(QRcodeViewController.callingWaitingPage), userInfo: nil, repeats: true)

        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.frame = CGRect(x: imageForScanner.frame.origin.x, y: imageForScanner.frame.origin.y, width: imageForScanner.frame.width, height:imageForScanner.frame.height )
           view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the message label to the top view
 //           view.bringSubview(toFront: messageLabel)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            //綠色框框
//            if let qrCodeFrameView = qrCodeFrameView {
//                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
//                qrCodeFrameView.layer.borderWidth = 2
//                view.addSubview(qrCodeFrameView)
//                view.bringSubview(toFront: qrCodeFrameView)
//            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toTheNext"{
//            if let orange = segue.destination as? StatusViewController{
//                orange.QRcodeStatus = sender as? String
//                print(orange.QRcodeStatus!)
//                print("HERE")
//            }
//            
//        }
//    }
    func requestData(){
        print("進入requestData")
        let urlString = "http://139.162.76.87/api/v1/user/[:id]/show_last"
        //此動作等同postman裡頭的輸入值測試
        let parameter:Parameters = [
            "auth_token" : appDelegate.jsonBackToken,
            "user_id":appDelegate.jsonBackUserID
//            "last_rent_history":appDelegate.jsonHistory,
//            "charged_amount":appDelegate.jsonMoney
        ]
        Alamofire.request(urlString, parameters: parameter).responseJSON {
            (response) in
            switch response.result{
            case .success:
                let jsonPackage = JSON(response.result.value)
                //print("站點傘數量json資料包",json)
                let jsonRentMoney1 = jsonPackage["last_rent_history"]
                 self.jsonRentMoney2 = jsonRentMoney1["charged_amount"].stringValue
                
                
                
                print("jsonPack",jsonPackage)
                print("Money",self.jsonRentMoney2)
                
                DispatchQueue.main.async {
                    print("2222kk")
                    self.svc?.dollarOfRent.text = self.jsonRentMoney2
                    self.svc = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
                    self.svc?.QRcodeStatus = self.qrcode
                    print("kkkkkkk")
                    var count = 0
                    for viewController in self.childViewControllers {
                        if (viewController is StatusViewController) {
                            count = count + 1
                        }
                    }
                    if count == 0 { //計數器為零才再增加新的view
                        print("lllllll")
                        
                        self.sv = self.svc?.view
                        self.view.addSubview(self.sv!)
                        self.addChildViewController(self.svc!)
                        self.svc?.didMove(toParentViewController: self)
                        print("靠邀")
                        self.scannerCount = true
                    }
                    print("ccccc")
                }
                
                
            case .failure(let error):
                print(error)
                
            }
        }
        
        
        
        
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
//            messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
                   if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
//            var getTheCode = metadataObj.stringValue
//            if metadataObj.stringValue != nil {
//                messageLabel.text = metadataObj.stringValue
                
                
           }
            
            //http://139.162.76.87/api/v1/umbrellas/borrow?auth_token=-CaWvhTGLkiy4Jitzh1i&user_id=1&umbrella_number=1
            //http://139.162.76.87/api/v1/umbrellas/return?auth_token=-CaWvhTGLkiy4Jitzh1i&user_id=1&umbrella_number=1&location_id=5
            
            if scannerCount {
            if metadataObj.stringValue != nil {
                
                scannerCount = false
                let url = URL(string: "http://139.162.76.87/api/v1/umbrellas/return")
                var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
               // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
//                let paramString = "auth_token=\(appDelegate.jsonBackToken)&user_id=\(appDelegate.jsonBackUserID)&umbrella_number=\(metadataObj.stringValue!)&location_id=\(location)"
                let paramString = "auth_token=\(appDelegate.jsonBackToken)&user_id=\(appDelegate.jsonBackUserID)&umbrella_number=\(metadataObj.stringValue!)&location_id=\(location)"

                print("****************",paramString)
                request.httpBody = paramString.data(using: String.Encoding.utf8)
                print("aaaa")
                do {
                print("bbbb")    

//                    let data = try  JSONSerialization.data(withJSONObject: loverDictionary, options: [])
                    let task = URLSession.shared.dataTask(with: request){ //這個是接受參數的aPI
//                    let task = URLSession.shared.uploadTask(with: request, from: data) {
                        (data, res, err) in
                        print("res:",res)
                        if err == nil{ //如果錯誤= nil 意思就是沒有錯誤 執行下面這個程式碼
                            let str = String(data: data!, encoding: .utf8)
                            print("result \(str)")

                            
                            do{
                                try? self.catchJSONToNext = JSONSerialization.jsonObject(with: data!) as! [String : String]
                                print("1還傘成功")
                                let getTheJSON = self.catchJSONToNext?["success"]
                                print("getTheJSON",getTheJSON)
                                if getTheJSON == "還傘成功"{
                                    print("還傘程序及金額")
                                    self.requestData()
                                    }
                                
                           }
                        catch{
                                print(err)
                            }
                        }else{
                            print("error",err) // 若有錯誤列印錯誤
                        }
                    }
                    task.resume()
                    self.qrcode = metadataObj.stringValue
                    print(metadataObj.stringValue)

//                    let svc = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
//                    svc = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
//                    svc?.QRcodeStatus = metadataObj.stringValue
//                    var count = 0
//                    for viewController in self.childViewControllers {
//                        if (viewController is StatusViewController) {
//                            count = count + 1
//                        }
//                    }
//                    if count == 0 { //計數器為零才再增加新的view
//                        sv = svc?.view
//                        self.view.addSubview(sv!)
//                        self.addChildViewController(svc!)
//                        print(metadataObj.stringValue)
//                        svc?.didMove(toParentViewController: self)
//                        print("靠邀")
//                    }


                }
                catch {
                    print("error\(error.localizedDescription)")

                }

                
                            }
            }
        }
    }
    
    
    func callingWaitingPage() {
        
        print("倒數計時",counter)
        counter -= 1
        
        if counter == 0 {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "WaitingPageViewController") as! WaitingPageViewController
//        controller.isbnNumberFromData = self.getTheCodeToBuild
//        controller.bookTitleFromData = self.bookTitle.text!
        self.present(controller, animated: true, completion: nil)
        counter = 30
        }
        
    }
    }
    
    

