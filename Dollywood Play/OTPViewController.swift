//
//  OTPViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 22/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking
import FormToolbar


class OTPViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var otptx: UITextField!
    var mobileno = String()
    var user_id = String()
    var type = String()
    var value = String()
    var data = NSMutableDictionary()
    var toolbar = FormToolbar()
    var resendotp = String()

    @IBOutlet weak var resendbutton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        otptx.keyboardType = .numberPad
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        self.toolbar = FormToolbar(inputs: [otptx])
        Common.getRounduibutton(button: resendbutton, radius: 10.0)
        Common.setbuttonborderwidth(button: resendbutton, borderwidth: 1.0)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func taptoresend(_ sender: UIButton) {
        
        
        if(type == "phone")
        {
            type = "mobile"
        }
        
        Common.startloder(view: self.view)
        let parameters = [
            "user_id": user_id,
            "type": type,
            "value":value,
            ]
        var url = String(format: "%@%@", LoginCredentials.Otpgenerateapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
       print(url)
        print(parameters)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                Common.stoploder(view: self.view)
                EZAlertController.alert(title: "OTP Send Successfully.")
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
    }
    
    @IBAction func Taptoresendotp(_ sender: Any) {
        
        
        if(type == "phone")
        {
            type = "mobile"
        }
        
        Common.startloder(view: self.view)
        let parameters = [
            "user_id": user_id,
            "type": "mobile",
            "value":mobileno,
        ]
        var url = String(format: "%@%@", LoginCredentials.Otpgenerateapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                Common.stoploder(view: self.view)
                EZAlertController.alert(title: "OTP Send Successfully.")
 
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
        
        
        
    }
    @IBAction func Taptoverify(_ sender: UIButton) {
        
        if Common.isEmptyOrWhitespace(testStr: otptx.text!) {
            
                 verifyoptapi()
          }
        else
        {
            EZAlertController.alert(title: "Please enter OTP")
        }
        
    }
    
    
 
    func verifyoptapi()
    {
        
        Common.startloder(view: self.view)
        let parameters = [
            "user_id": user_id,
            "otp": otptx.text!,
            "device": "ios"
        ] as [String : String]
        var url = String(format: "%@%@", LoginCredentials.Verifyotpapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                  EZAlertController.alert(title: "Please enter correct OTP.")
                }
                else
                {
                    let Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(Catdata_dict)
                    dataBase.deletedataentity(entityname: "Logindata")
                    dataBase.Savedatainentity(entityname: "Logindata", key: "logindatadict", data: Catdata_dict)
                    dataBase.deletedataentity(entityname: "Slidermenu")
                   // LoginCredentials.Agegroup = Catdata_dict.value(forKey: "age_group") as! String
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "usersession"), object: nil)
                    // self.gotouserintersetview()
                    self.gotohomeacreen()
                    
                }
                
                
                
                Common.stoploder(view: self.view)
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
    }
    
    
    
    func gotouserintersetview()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userintersetViewController = storyboard.instantiateViewController(withIdentifier: "UserintersetViewController") as! UserintersetViewController
        self.navigationController?.pushViewController(userintersetViewController, animated: true)
    }
    
    func gotohomeacreen()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
       // self.slideMenuController()?.changeMainViewController(viewController, close: true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func Taptoback(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        self.toolbar.update()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
       self.view.frame.origin.y = -50
       //  myscroll.contentInset = contentInsets
       // myscroll.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0.0
       // myscroll.contentInset = .zero
      //  myscroll.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
  
    
}
