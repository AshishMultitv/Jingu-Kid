//
//  ContactUsViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 16/03/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit
import FormToolbar
import AFNetworking


class ContactUsViewController: UIViewController {

    @IBOutlet var SubmitButton: UIButton!
    @IBOutlet var description_txview: UITextView!
    @IBOutlet var Email_tx: UITextField!
    var toolbar = FormToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        self.toolbar = FormToolbar(inputs: [description_txview, Email_tx])
         Common.getRounduibutton(button: SubmitButton, radius: 10.0)
        Common.setbuttonborderwidth(button: SubmitButton, borderwidth: 1.0)


        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view.
    }

    @IBAction func TaptoMenu(_ sender: Any) {
        slideMenuController()?.openLeft()

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "How may we help you?") {
           textView.text = ""
        }
         else
        {
            
        }
    }
    @IBAction func TaptoSubmit(_ sender: UIButton) {
        
        
        if(!Common.isValidEmail(testStr: Email_tx.text!)) {
   
        EZAlertController.alert(title: "Please Enter Valid Email id")
            return
        }
        else if(description_txview.text == "How may we help you?" )
        {
            EZAlertController.alert(title: "Description Can't be blank")
            return

        }
        else if(!Common.isEmptyOrWhitespace(testStr: description_txview.text)) {
        EZAlertController.alert(title: "Description Can't be blank")
        return
        }
        contactUsApi()
    }
    
    func contactUsApi()
    {
        Common.startloder(view: self.view)
          var parameters = [String : String]()
        
        parameters = [
            "email": Email_tx.text!,
            "device": "ios",
            "message":description_txview.text,
            "subject":"JinguKid"
        ]
        var url = String(format: "%@%@", LoginCredentials.ContactUsapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                Common.stoploder(view: self.view)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    EZAlertController.alert(title: "\(dict.value(forKey: "error") as! String)")
                }
                else
                {
                    EZAlertController.alert(title: "We have received your message and will get back to you.")
                    self.description_txview.text = "How may we help you?"
                    self.Email_tx.text = ""
                }
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
            EZAlertController.alert(title: error.localizedDescription)

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
   
}
