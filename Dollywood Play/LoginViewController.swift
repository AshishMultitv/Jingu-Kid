//
//  LoginViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 09/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import CoreTelephony
import AFNetworking
import FormToolbar


class LoginViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextViewDelegate {
    
    
    
    @IBOutlet var headerview: UIView!
    @IBOutlet var contantview: UIView!
    @IBOutlet var orlabel: UILabel!
    @IBOutlet var textview: UITextView!
    @IBOutlet weak var email_txtfld: UITextField!
    @IBOutlet var mobilenotextfld: UITextField!
    @IBOutlet var signinbutton: UIButton!
    @IBOutlet var orlabel1: UILabel!
    
    private let loader = FacebookUserLoader()
    var dictionaryOtherDetail = NSDictionary()
    var devicedetailss =  NSDictionary()
    var socail_dict =  NSDictionary()
    var uniqsocial_id =  String()
    var phone =  String()
    
    var type =  String()
    var fboremail =  String()
    var logindatadict = NSMutableDictionary()
    var toolbar = FormToolbar()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait)
         setloginUi()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        self.toolbar = FormToolbar(inputs: [email_txtfld, mobilenotextfld])
        self.navigationController?.isNavigationBarHidden = true
        self.getloginpram()
    }
    
   
    
    func setloginUi()
    {
      
        
        textview.delegate = self
        textview.isUserInteractionEnabled = true
        textview.isEditable = false
        textview.isSelectable = true
        let linkAttributes = [
            NSLinkAttributeName: NSURL(string: LoginCredentials.Termsanduse)!,
            NSForegroundColorAttributeName: UIColor.blue,
            NSFontAttributeName: UIFont(name: "Baloo", size: 12.0)!
            ] as [String : Any]
        let linkAttributes1 = [
            NSLinkAttributeName: NSURL(string: LoginCredentials.Privacypolcy)!,
            NSForegroundColorAttributeName: UIColor.blue,
            NSFontAttributeName: UIFont(name: "Baloo", size: 12.0)!
            ] as [String : Any]
        
         let myAttribute = [ NSFontAttributeName: UIFont(name: "Baloo", size: 12.0)! ]
        let attributedString = NSMutableAttributedString(string: "By clicking sign in, you agree to our terms and conditions and that you have read our Privacy Policy", attributes: myAttribute )
        
        // Set the 'click here' substring to be the link
        attributedString.setAttributes(linkAttributes, range:NSRange(location:38,length:20))
        attributedString.setAttributes(linkAttributes1, range:NSRange(location:85,length:15))
        textview.attributedText = attributedString

         Common.getRoundLabel(label: orlabel, borderwidth: 20.0)
         Common.getRoundLabel(label: orlabel1, borderwidth: 20.0)
         Common.getRounduibutton(button: signinbutton, radius: 10.0)
         Common.setlebelborderwidth(label: orlabel, borderwidth: 1.0)
         Common.setlebelborderwidth(label: orlabel1, borderwidth: 1.0)
         Common.setbuttonborderwidth(button: signinbutton, borderwidth: 1.0)

        
        
        
        
        
    }
    
   
    @IBAction func Taptosignup(_ sender: UIButton) {
      
       gotoSignupview()
        
    }
    

    @IBAction func TaptoForgot(_ sender: UIButton) {
        
        gotoforgotview()
        //gotouserintersetview()
        
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        // User click on a link in a textview
        print(characterRange)
        
        // True => User can click on the URL Ling (otherwise return false)
        return true
    }
    
    @IBAction func Taptologin(_ sender: UIButton) {
        
       
        if(!(Common.isEmptyOrWhitespace(testStr: email_txtfld.text!))  && !(Common.isEmptyOrWhitespace(testStr: mobilenotextfld.text!)) ) {
            
           EZAlertController.alert(title: "Please enter either email id or phone number")
            return
            
        }
        
        
      
        
        
        if(Common.isEmptyOrWhitespace(testStr: email_txtfld.text!))
        {
            if(Common.isValidEmail(testStr: email_txtfld.text!))
            {
                phone = email_txtfld.text!
                type = "email"
                getloginapi()
                return
            }
            else
            {
                EZAlertController.alert(title: "Please enter Valid email id")
                
            }
        }
        else if((Common.isEmptyOrWhitespace(testStr: mobilenotextfld.text!)))
        {
            
            
            if(Common.Isphonevalid(phoneNumber: mobilenotextfld.text!))
            {
                
                if ((mobilenotextfld.text?.characters.count)! <= 9 || (mobilenotextfld.text?.characters.count)! > 15)
                {
                    EZAlertController.alert(title: "Please enter Valid phone no.")
                    
                }
                else
                {
                    phone = mobilenotextfld.text!
                    type = "phone"
                    getloginapi()
                    return
                }
                
            }
            else
            {
                EZAlertController.alert(title: "Please enter Valid phone no.")
                
            }
            
        }
                
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TAptoskip(_ sender: UIButton) {
      self.gotohomeacreen()   
       
    }
    @IBAction func Taptogoogle(_ sender: UIButton) {
        type = "social"
        fboremail = "google"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
       // Common.startloder(view: self.view)
        
    }
    
    
    func getloginapi()
    {
        
        Common.startloder(view: self.view)
        
        do {
            
            
            /// phone, email, social
            var parameters = [String : Any]()
            if(type == "social")
            {
                if(fboremail == "facebook")
                {
                    parameters = [   "type":type,
                                     "dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                                     "dd":Common.convertdictinyijasondata(data: devicedetailss),
                                     "social":Common.convertdictinyijasondata(data: socail_dict),
                                     "device": "ios",
                                     "provider":"facebook",
                    ]
                }
                else if(fboremail == "google")
                {
                    
                    parameters = [   "type":type,
                                     "dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                                     "dd":Common.convertdictinyijasondata(data: devicedetailss),
                                     "social":Common.convertdictinyijasondata(data: socail_dict),
                                     "device": "ios",
                                     "provider":"google",
                    ]
                }
            }
            else
            {
                
                parameters = [ "phone":phone,
                                "dd":Common.convertdictinyijasondata(data: devicedetailss),
                               "dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                                "device": "ios",
                                 "type":type

                  ]
                
             }
            
            
              var url = String()
            url = String(format: "%@%@", LoginCredentials.SocialAPI,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)
            print(url)
             let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    Common.stoploder(view: self.view)
                    
                   if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                   {
                    EZAlertController.alert(title: "Please Enter Valid detail")
                    return
                    }
                    else
                   {
                    if(self.type == "social")
                    {
                     self.logindatadict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print(self.logindatadict)
                 dataBase.deletedataentity(entityname: "Logindata")
                dataBase.deletedataentity(entityname: "Slidermenu")
                dataBase.Savedatainentity(entityname: "Logindata", key: "logindatadict", data: self.logindatadict)
                 
               //LoginCredentials.Agegroup = self.logindatadict.value(forKey: "age_group") as! String
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "usersession"), object: nil)

                self.gotohomeacreen()
                    }
                    else
                    {
                        
                         self.logindatadict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        print(self.logindatadict)
                        if(Common.isNotNull(object: self.logindatadict.value(forKey: "otp") as AnyObject?))
                        {
                            self.gotoOTPacreen(otp: "", userid: (self.logindatadict.value(forKey: "id") as! NSNumber).stringValue, type: self.type, value: self.phone, data:self.logindatadict, resendotp:"no")
                        }
                        else{
                            
                            self.gotoOTPacreen(otp: "", userid: (self.logindatadict.value(forKey: "id") as! NSNumber).stringValue, type: self.type, value: self.phone, data:self.logindatadict, resendotp:"yes")
                        }
                    }
                    //self.gotouserintersetview()
                      }
          
                }
                }
            ) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
            }
        }
        catch
        {}
    }
    
    
    
    @IBAction func TAptoFacebook(_ sender: UIButton) {
        
        
        type = "social"
        fboremail = "facebook"
        
        Common.startloder(view: self.view)
        loader.load(askEmail: true, onError: { [weak self] in
            Common.stoploder(view: (self?.view)!)
            let alt:UIAlertView=UIAlertView(title: "Jingu Kid", message: "Cannot login with Facebook, something is missing. Try another account for login.", delegate: nil, cancelButtonTitle: "OK")
            alt.show()
            },
                    onSuccess: { [weak self] user in
                        self?.onUserLoaded(user: user)
        })
        
        
        
    }
    private func onUserLoaded(user: TegFacebookUser) {
        
        Common.stoploder(view: self.view)
        print("emailAddress\(user.email) and Gender is \(user.gender) and userFBID is \(user.id) and userprofilepIc url is \(user.profilePic)")
        
        if user.email != nil
        {
            uniqsocial_id = user.id as String
            socail_dict = [
                "first_name": user.firstName! as String,
                "last_name": user.lastName! as String,
                "gender": user.gender! as String,
                "link": "",
                "locale": "",
                "name": user.name! as String,
                "email": user.email! as String,
                "location": "",
                "dob": "",
                "id":user.id as String]
            self.getloginapi()
            
        }
        else
        {
            let alt:UIAlertView=UIAlertView(title: "Jingu Kid", message: "Cannot login with Facebook, email id is missing. Try another account or go for login.", delegate: nil, cancelButtonTitle: "OK")
            alt.show()
        }
    }
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        //print("Sign in presented")
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        // print("Sign in dismissed")
    }
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if error == nil
        {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("Welcome: ,\(userId), \(idToken), \(fullName), \(givenName), \(familyName), \(email)")
            uniqsocial_id = userId!
            
            socail_dict = [
                "first_name": "",
                "last_name": "",
                "gender": "",
                "link": "",
                "locale": "",
                "name": user.profile.name,
                "email": user.profile.email,
                "location": "",
                "dob": "",
                "id":user.userID ]
             self.getloginapi()
            
        }
        
    }
    
    func getloginpram()
    {
        let netInfo:CTTelephonyNetworkInfo=CTTelephonyNetworkInfo()
        let carrier = netInfo.subscriberCellularProvider
         let strResolution=String(format: "%.f*%.f", self.view.frame.size.width, self.view.frame.size.height)
        let systemVersion=UIDevice.current.systemVersion
        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        var networkname =  String()
        
        if(!Common.isNotNull(object: carrier?.carrierName as AnyObject?))
        {
            networkname = ""
        }
        else
        {
            networkname =  (carrier?.carrierName)! as String
        }
        
         dictionaryOtherDetail = [
            "os_version" : systemVersion,
            "network_type" : Common.getnetworktype(),
            "network_provider" : networkname,
            "app_version" : appversion!
        ]
        devicedetailss = [
            "make_model" : Common.getModelname(),
            "os" : "ios",
            "screen_resolution" : strResolution,
            "device_type" : "app",
            "platform" : "IOS",
            "device_unique_id" : uuid as String,//token! as! String,
            "push_device_token" :  LoginCredentials.DiviceToken
        ]
        print(dictionaryOtherDetail)
        print(devicedetailss)
        
        
        
    }
    
    @IBAction func BackButton_action(_ sender: UIButton) {
  
    }
    
    
    func gotoOTPacreen(otp:String,userid:String,type:String,value:String,data:NSMutableDictionary,resendotp:String)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let oTPViewController = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
         oTPViewController.user_id = userid
        oTPViewController.value = value
        oTPViewController.type = type
        oTPViewController.data = data
        oTPViewController.resendotp = resendotp
        self.navigationController?.pushViewController(oTPViewController, animated: true)
       // self.slideMenuController()?.changeMainViewController(oTPViewController, close: true)
 
    }
    
   
    func gotoforgotview()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotPasswordViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
         self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    
    func gotoSignupview()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
         self.navigationController?.pushViewController(signUpViewController, animated: true)
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
      
        //self.slideMenuController()?.changeMainViewController(SignoutViewController, close: true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func Skipbutonaction(_ sender: UIButton) {
        UserDefaults.standard.setValue("skip", forKey: "skip")
        LoginCredentials.Isskip = true
        gotohomeacreen()
        
    }
     func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        self.toolbar.update()
        
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
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        
        AppUtility.lockOrientation(.portrait)
        self.perform(#selector(changeOrientation), with: nil, afterDelay: 5.0)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
      NotificationCenter.default.removeObserver(self)
        
    }
    func changeOrientation()
    {
        AppUtility.lockOrientation(.portrait)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
}
