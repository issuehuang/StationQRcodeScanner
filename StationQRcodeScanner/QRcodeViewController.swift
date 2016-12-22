//
//  QRcodeViewController.swift
//  StationQRcodeScanner
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 VictorBasic. All rights reserved.
//

import UIKit
import AVFoundation


class QRcodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
        
    
    
    @IBOutlet weak var imageForScanner: UIView!
    var getTheCode:String?
    var sv:UIView?
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
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
            if metadataObj.stringValue != nil {
                //                dismiss(animated: true, completion: {
                //                    self.performSegue(withIdentifier: "StatusViewController", sender: self.getTheCode)
                //                })
                
                //               let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let svc = self.storyboard?.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
                svc.QRcodeStatus = metadataObj.stringValue
                
                
                //                ViewController.QRcodeStatus = self.getTheCode
                //                self.present(controller, animated: true, completio:nil)
                //                        svc.view.frame = self.view.bounds
                //                  svc.delegate = metadataObj.stringValue as! StatusViewController?
                
                var count = 0
                for viewController in self.childViewControllers {
                    if (viewController is StatusViewController) {
                        count = count + 1
                    }
                }
                if count == 0 {
                    sv = svc.view
                    self.view.addSubview(sv!)
                    self.addChildViewController(svc)
                    print(metadataObj.stringValue)
                    svc.didMove(toParentViewController: self)
                    print("靠邀")
                }
            }else{
                
            
            }
        }
    }
    
}
