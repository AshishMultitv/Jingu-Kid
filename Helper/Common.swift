//
//  Common.swift
//  Eschool
//
//  Created by Desk28 on 03/08/15.
//  Copyright (c) 2015 Shree Ram. All rights reserved.
//

import UIKit
import CryptoSwift
import MBProgressHUD
import Foundation
import SystemConfiguration
import ReachabilitySwift
import CoreTelephony
import AFNetworking





////////////////////////////////PRODUCTION///////////////////////////////
//var MaterBaseUrl = "http://staging.multitvsolution.com:9001/automatorapi/v6/master/url_static_dollywood/token/"
//var Subscriptionbaseurl = "http://staging.multitvsolution.com:9002"
//let Apptoken = "59df69a99fa57"

////////////////////////////////PRODUCTION///////////////////////////////
var MaterBaseUrl = "http://api-aut.multitvsolution.com/automatorapi/v6/master/url_static_dollywood_prod/token/"
var Subscriptionbaseurl = "http://staging.multitvsolution.com:9002"
let Apptoken = "59df69a99fa57"






let Discriptioncolor = UIColor.init(colorLiteralRed: 110.0/255, green: 110.0/255, blue: 110.0/255, alpha: 1.0)
var timer:Timer!
let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();

class Common: NSObject {
    
 
   static func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    
    }
    static func setvideoplayeronview(testStr:UIView) {
        // println("validate calendar: \(testStr)")
      }
     static func Showloginalert(view:UIViewController,text:String) {
    
    let alert = UIAlertController(title: "Jingu Kid", message: text, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.destructive, handler: { action in
    self.gotologinpage(view: view)
    }))
    view.present(alert, animated: true, completion: nil)
    
    }
    static func gotologinpage(view:UIViewController)
   {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    view.navigationController?.pushViewController(loginViewController, animated: true)
    //view.navigationController?.popToViewController(loginViewController, animated: true)

    
    }
   
   static func callappanalytics()
    {
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "useranalytics"), object: nil)
    }
    
    static func gotomyprofile()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotomyprofilescene"), object: nil)
    }
   static func stopHeartbeat()
   {
    if timer != nil
    {
        timer.invalidate()
        timer  = nil
    }
    }
    
   static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
   static func isEmptyOrWhitespace(testStr:String) -> Bool {
    
    let str = testStr.trimmingCharacters(in: NSCharacterSet.whitespaces)
    
   // let str = testStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
   
         if(testStr.isEmpty || str.isEmpty) {
            return false
        }
    else
        {
            return true
    }
        
        //return (testStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
    }
    
    
   static func isNotNull(object:AnyObject?) -> Bool {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object: object) && isNotStringNull(object: object))
    }
   static func isNotNSNull(object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }
    
   static func isNotStringNull(object:AnyObject) -> Bool {
        if let object = object as? String, object.uppercased() == "NULL" {
            return false
        }
        return true
    }

    
    
    static func Isuserissubscribe(Userdetails:AnyObject) -> Bool {
        if(LoginCredentials.UserPakegeList.count>0) {
            print(LoginCredentials.UserPakegeList)
            for i in 0..<LoginCredentials.UserPakegeList.count {
                let issubcribed = ((LoginCredentials.UserPakegeList.object(at: i) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "is_subscriber") as! String
                if(issubcribed == "1") {
                    return true
                }
            }
            return false
        }
        else {
            return false
            
        }
        
    }

    static func PresentSubscription(Viewcontroller:UIViewController)  {
        //let vc = SubscriptionView()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionView") as! SubscriptionView
        Viewcontroller.present(vc, animated: true, completion: nil)
        return
    }
    
    
    static func gatedateheder(testStr:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        let date = dateFormatter.date(from: testStr)
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: date!)
        return result
        
    }
    
    static func startloderonsubscription(view:UIView) {
    
        MBProgressHUD.showAdded(to:view, animated: true)

    }
    static func stoploderonsubscription(view:UIView) {
        
        MBProgressHUD.hide(for: view, animated: true)

    }
    
    static func startloder(view:UIView)
    {
         activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
      }
    
    static func startwhiteloder(view:UIView)
    {
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
    }
    
    static func stopwhiteloder(view:UIView)
    {
        //MBProgressHUD.hide(for: view, animated: true)
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
        
    }
    
    
    
    static func stoploder(view:UIView)
    {
        //MBProgressHUD.hide(for: view, animated: true)
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
        
    }
    
    static func startloderonplayer(view:UIView)
    {
    
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        view.addSubview(activityIndicator);
         activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
    }
    
    
    
    static func stoploderonplayer(view:UIView)
    {
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
     }
    

    static func getModelname()->String
    {
        let divice = UIDevice()
        return divice.modelName
    }
    
    static func getnetworktype()->String
        
    {
        let reachability = Reachability()!
        print(reachability.description)
        
        
        if(!reachability.isReachable)
        {
            return ""
            
        }
        
        if(reachability.isReachableViaWiFi)
        {
            return "WiFi"
        }
            
            
        else
        {
            
            let networkInfo = CTTelephonyNetworkInfo()
            let carrierType = networkInfo.currentRadioAccessTechnology
            switch carrierType{
            case CTRadioAccessTechnologyGPRS?,CTRadioAccessTechnologyEdge?,CTRadioAccessTechnologyCDMA1x?:
                return "2G"
            case CTRadioAccessTechnologyWCDMA?,CTRadioAccessTechnologyHSDPA?,CTRadioAccessTechnologyHSUPA?,CTRadioAccessTechnologyCDMAEVDORev0?,CTRadioAccessTechnologyCDMAEVDORevA?,CTRadioAccessTechnologyCDMAEVDORevB?,CTRadioAccessTechnologyeHRPD?:
                return "3G"
            case CTRadioAccessTechnologyLTE?:
                return "4G"
            default: return ""
            }
            
        }
        return ""
    }
    

    
    static func trimstring(text:String) ->String
    {
      var trim = text
       trim = trim.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trim
    }
    

    static func makewhitplaceholderintextview(textview:UITextView,string:String)
    {
        textview.text = string
        textview.textColor = UIColor.lightGray
    }
    
    static func Endtextviewplaceholder(textview:UITextView)
    {
        textview.text = nil
        textview.textColor = UIColor.black
    }
    
   
   
    static func convertvideoduration(videotime:String)->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let time = dateFormatter.date(from: videotime)
        dateFormatter.dateFormat = "HH:mm:ss"
        var coverttime = dateFormatter.string(from: time!)
        print(coverttime)
        let fullNameArr = coverttime.components(separatedBy: ":")
        if((fullNameArr[0] as String) == "00")
        {
            if((fullNameArr[1] as String) == "00")
            {
                coverttime = "\(fullNameArr[1]):\(fullNameArr[2]) sec"
            }
            else
            {
                
                coverttime = "\(fullNameArr[1]):\(fullNameArr[2]) min"
            }
        }
        else
        {
            coverttime = "\(fullNameArr[0]):\(fullNameArr[1]) hr"
        }
        return coverttime
    }
    
    static func decodedresponsedata(msg:String)-> NSMutableDictionary
    {
        let keyString = "0123456789abcdef0123456789abcdef"
         let encode =  msg.aesDecrypt(key: keyString)
        
        let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
         return jsonObject.mutableCopy() as! NSMutableDictionary

    }
  
    static func decodedresponseheartbeat(msg:String)-> String
    {
        let keyString = "0123456789abcdef0123456789abcdef"
        let encode =  msg.aesDecrypt(key: keyString)
      //  let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! String
        return encode
        
    }

    
    static func getshadowofimageview(myimage:UIImageView)
    {
         myimage.layer.shadowColor = UIColor.init(colorLiteralRed: 22/255, green: 119/255, blue: 218/255, alpha: 1.0).cgColor
        myimage.layer.shadowOffset = CGSize.init(width: 0, height: 6)
        myimage.layer.shadowOpacity = 1.0;
        myimage.layer.shadowRadius = 5.0;
    }
    
    
    
    static func getshadowofview(myView:UIView)
    {

    myView.layer.shadowColor = UIColor.init(colorLiteralRed: 22/255, green: 119/255, blue: 218/255, alpha: 1.0).cgColor
    myView.layer.shadowOffset = CGSize.init(width: 0, height: 3)
    myView.layer.shadowOpacity = 0.5;
    myView.layer.shadowRadius = 1.0;
    }
    
    
    static func getshadowofviewcollection(myView:UIView)
    {
        
        myView.layer.shadowColor = UIColor.init(colorLiteralRed: 22/255, green: 119/255, blue: 218/255, alpha: 1.0).cgColor
        myView.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        myView.layer.shadowOpacity = 0.3;
        myView.layer.shadowRadius = 1.0;
    }
    
    
    
   static func makewhitplaceholder(textfiled:UITextField,string:String)
    {
        textfiled.attributedPlaceholder = NSAttributedString(string:string,
        attributes:[NSForegroundColorAttributeName: UIColor.white])
    }

    
    static func Isphonevalid(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    static func Islogin() -> Bool
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            return true
        }
        else
        {
          return false
        }
    }
    

    static func convertdictinyijasondata(data:NSDictionary) -> String
    {
         do {
        let jsonData = try JSONSerialization.data(withJSONObject: data as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        let otherDetailString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
        return otherDetailString
        }
         catch{
            
        }
        return ""
    }
    

    static func getRounduiview(view: UIView, radius:CGFloat) {
        view.layer.cornerRadius = radius;
        view.clipsToBounds=true
    }
    static func getRoundImage(imageView: UIImageView, radius:CGFloat) {
        imageView.layer.cornerRadius = radius;
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
     }
   
    static func getRounduibutton(button: UIButton, radius:CGFloat) {
        button.layer.cornerRadius = radius;
        button.clipsToBounds = true
         button.layer.masksToBounds = true
    }
    
    static func getRoundLabel(label: UILabel,borderwidth:CGFloat) {
        label.layer.cornerRadius = borderwidth
        label.clipsToBounds = true
        label.layer.masksToBounds = true
    }
   
    
    static func setuiviewdborderwidth(View: UIView, borderwidth:CGFloat) {
        View.layer.borderColor=UIColor.white.cgColor
        View.layer.borderWidth=borderwidth
        View.clipsToBounds=true
    }
    
   static func setuiviewdbordercolor(View: UIView, borderwidth:CGFloat,bordercolor:UIColor) {
        View.layer.borderColor=bordercolor.cgColor
        View.layer.borderWidth=borderwidth
        View.clipsToBounds=true
    }
    
    static func setuiimageviewdborderwidth(imageView: UIImageView, borderwidth:CGFloat) {
        imageView.layer.borderColor=UIColor.white.cgColor
        imageView.layer.borderWidth=borderwidth
        imageView.clipsToBounds=true
    }

    
    static func settextfieldborderwidth(textfield: UITextField, borderwidth:CGFloat) {
        textfield.layer.borderColor=UIColor.white.cgColor
        textfield.layer.borderWidth=borderwidth
        textfield.layer.cornerRadius = 1.0
        textfield.clipsToBounds=true
    }
   
    
    static func settextviewborderwidth(textview: UITextView, borderwidth:CGFloat) {
        textview.layer.borderColor=UIColor.gray.cgColor
        textview.layer.borderWidth=borderwidth
        textview.clipsToBounds=true
    }
  
    
    static func setbuttonborderwidth(button: UIButton, borderwidth:CGFloat) {
        button.layer.borderColor=UIColor.gray.cgColor
        button.layer.borderWidth=borderwidth
        button.clipsToBounds=true
    }
    
 
    
    static func setlebelborderwidth(label: UILabel, borderwidth:CGFloat) {
        label.layer.borderColor=UIColor.gray.cgColor
        label.layer.borderWidth=borderwidth
        label.clipsToBounds=true
    }

 
   static func updateAgeGoup(agegroup:String)
    {
        var newagegroup = agegroup
        if(newagegroup == "5+")
        {
            newagegroup = "5-15"
        }
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(dict)
        var parameters = [String : String]()
        parameters = ["age_group":newagegroup,
                      "device": "ios",
                      "id": (dict.value(forKey: "id") as! NSNumber).stringValue]
        var url = String(format: "%@%@", LoginCredentials.Editapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                //  Common.stoploder(view: self.view)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    EZAlertController.alert(title: "\(dict.value(forKey: "error") as! String)")
                    return
                }
                
                let data = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                print(data)
                dataBase.deletedataentity(entityname: "Sidemenudata")
                dataBase.deletedataentity(entityname: "Homedata")
                dataBase.deletedataentity(entityname: "Slidermenu")
                dataBase.deletedataentity(entityname: "Catlistdata")
                dataBase.deletedataentity(entityname: "Continuewatching")
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            // Common.stoploder(view: self.view)
            
        }
    }
    
}
