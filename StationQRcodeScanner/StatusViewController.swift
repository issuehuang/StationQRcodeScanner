//
//  StatusViewController.swift
//  StationQRcodeScanner
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 VictorBasic. All rights reserved.
//

import UIKit

protocol StatusViewControllerDelegate{
    func dismissView()
}


class StatusViewController: UIViewController {
    
    @IBOutlet weak var dollarOfRent: UILabel!
    var delegate:StatusViewControllerDelegate? = nil
    var QRcodeStatus:String? //接受上一頁的值

    @IBOutlet weak var statusImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("QRcode:",QRcodeStatus)
        print("阿幹")
        
//        if QRcodeStatus == "1234" {
        statusImage.image = UIImage(named: "Success_to_return-1")
 //       }else{
  //          statusImage.image = UIImage(named: "Fail_to_return")
 //        }

        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 5, target: self, selector:#selector(StatusViewController.dismiss as (StatusViewController) -> () -> ()), userInfo: nil, repeats: false)
        
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(checkTouch), userInfo: nil, repeats: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(StatusViewController.dismiss as (StatusViewController) -> () -> ()))
        self.view.addGestureRecognizer(tap)
    }
    
    func checkTouch(){
        print("checkTouch")
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
    
    func dismiss() {
        self.willMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }

}
