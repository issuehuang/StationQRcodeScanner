//
//  WaitingPageViewController.swift
//  StationQRcodeScanner
//
//  Created by mac on 2016/12/24.
//  Copyright © 2016年 VictorBasic. All rights reserved.
//

import UIKit

class WaitingPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "QRCodeScanner") as! QRcodeViewController
        //        controller.isbnNumberFromData = self.getTheCodeToBuild
        //        controller.bookTitleFromData = self.bookTitle.text!
        self.present(controller, animated: true, completion: nil)

        
//        for touch:AnyObject in touches {
//            counterOftouch = 1
//            if counterOftouch == 1{
//                print("摸到一次")
//            }
//            counterOftouch = 0
//            print("歸零了喔")
//        }
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
