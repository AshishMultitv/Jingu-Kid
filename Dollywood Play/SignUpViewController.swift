//
//  SignUpViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 17/07/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import CoreTelephony
import FormToolbar
import AFNetworking
import FTPopOverMenu
import CoreLocation
import FBSDKLoginKit
import GoogleSignIn


class SignUpViewController: UIViewController,CLLocationManagerDelegate,CountriesViewControllerDelegate {
    
    @IBOutlet var Firstname_tx: UITextField!
    @IBOutlet var Lastname_tx: UITextField!
    @IBOutlet var email_tx: UITextField!
    @IBOutlet var Phone_tx: UITextField!
    @IBOutlet var Password_tx: UITextField!
    @IBOutlet var Confirmpassword_tx: UITextField!
    @IBOutlet var genderlabel: UILabel!
    @IBOutlet var agelabel: UILabel!
    @IBOutlet var locationbutton: UIButton!
    
    @IBOutlet var muscrollview: UIScrollView!
    
    @IBOutlet var countrycodelable: UILabel!
    
    var dictionaryOtherDetail = NSDictionary()
    var devicedetailss =  NSDictionary()
    var toolbar = FormToolbar()
    var logindatadict = NSMutableDictionary()
    
    
    var locationManager = CLLocationManager()
    
    private let loader = FacebookUserLoader()
    var socail_dict =  NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Taptoback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func Taptoskip(_ sender: UIButton) {
        
        gotohomeacreen()
        
    }
    
    func gotohomeacreen()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        // self.slideMenuController()?.changeMainViewController(viewController, close: true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        self.toolbar = FormToolbar(inputs: [Firstname_tx, email_tx, Phone_tx, Password_tx, Confirmpassword_tx])
        self.navigationController?.isNavigationBarHidden = true
        self.getloginpram()
    }
    
    
    func getloginpram()
    {
        let netInfo:CTTelephonyNetworkInfo=CTTelephonyNetworkInfo()
        let carrier = netInfo.subscriberCellularProvider
        let strResolution=String(format: "%.f*%.f", self.view.frame.size.width, self.view.frame.size.height)
        let systemVersion=UIDevice.current.systemVersion
        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        //  print(carrier,strDeviceName,strResolution,systemVersion,appversion)
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
    
    
    
    
    @IBAction func TAptopasswordvisibility(_ sender: UIButton) {
    }
    
    @IBAction func Taptoconfirmpasswordvisibilty(_ sender: UIButton) {
    }
    
    @IBAction func TaptoSubmit(_ sender: UIButton) {
        
        if !Common.isEmptyOrWhitespace(testStr: Firstname_tx.text!) {
            
            EZAlertController.alert(title: "Please enter First name")
            
        }
      
        else if(!Common.isValidEmail(testStr: email_tx.text!))
        {
            EZAlertController.alert(title: "Please enter Valid email")
            
        }
        else if(!Common.isEmptyOrWhitespace(testStr: Phone_tx.text!))
        {
            EZAlertController.alert(title: "Please enter Phone")
            
        }
        else if(!Common.isEmptyOrWhitespace(testStr: Password_tx.text!))
        {
            EZAlertController.alert(title: "Please enter Password")
            
        }
        else if(!Common.isEmptyOrWhitespace(testStr: Confirmpassword_tx.text!))
        {
            EZAlertController.alert(title: "Please enter Confirm Password")
            
        }
        else if(Password_tx.text != Confirmpassword_tx.text)
        {
            EZAlertController.alert(title: "Password and Confirm cant't match")
            
        }
        else if(locationbutton.titleLabel?.text == "Location")
        {
            EZAlertController.alert(title: "Please select your location. for select your location please tap on location.")
            
        }
        else{
            gotosignupapi()
        }
        
        
        
        
    }
    
    
    
    
    func gotosignupapi()
    {
        
        var age = agelabel.text
        if(age == "Below 18")
        {
          age = "0-17"
        }
        else if(age == "Above 45")
        {
          age = "45-70"
        }
        
        if(age == "Age")
        {
            age = ""
        }
        var gender = genderlabel.text
        if(gender == "Gender")
        {
            gender = ""
        }
        var lat = Double()
        var long = Double()
        if locationManager.location != nil
        {
            lat = (locationManager.location?.coordinate.latitude)!
            long = (locationManager.location?.coordinate.longitude)!
        }
        else
        {
            lat = 0.0
            long = 0.0
        }
        self.view.endEditing(true)
        Common.startloder(view: self.view)
        var parameters = [String : Any]()
        
        parameters = [ "first_name":Firstname_tx.text! as String,
                       "last_name":"",
                       "email":email_tx.text! as String,
                       "phone":Phone_tx.text! as String,
                       "password":Password_tx.text! as String,
                      "age_group":age! as String,
                       "lat":lat,
                       "long":long,
                       "gender":gender! as String,
                       "devicedetail":Common.convertdictinyijasondata(data: devicedetailss),
                       "device_other_detail":Common.convertdictinyijasondata(data: dictionaryOtherDetail)
        ]
        
        
        
        
        var url = String(format: "%@%@", LoginCredentials.AddAPi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                
                let dict = responseObject as! NSDictionary
                print(dict)
                Common.stoploder(view: self.view)
                if((dict.value(forKey: "code") as! NSNumber) == 0)
                {
                    EZAlertController.alert(title: dict.value(forKey: "error") as! String)
                }
                else
                {
                    
                    self.gotoOTPacreen(otp: "", userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
                    EZAlertController.alert(title: dict.value(forKey: "result") as! String)
                    
                    
                    
                    
                    
                }
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
    }
    
    @IBAction func TAptocountrycode(_ sender: UIButton) {
        
        let countriesViewController = CountriesViewController()
        countriesViewController.delegate = self
        countriesViewController.allowMultipleSelection = false
        CountriesViewController.Show(countriesViewController: countriesViewController, to: self)
        
    }
    
    
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountries countries: [Country]){
        
        countries.forEach { (co) in
            print(co.name);
        }
    }
    
    func countriesViewControllerDidCancel(_ countriesViewController: CountriesViewController) {
        
        print("user hass been tap cancel")
        
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country) {
        
        print(country.name+" selected")
          print(country.phoneExtension+" selected")
        countrycodelable.text = "\("+")\(country.phoneExtension)"
        
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didUnselectCountry country: Country) {
        
        print(country.name+" unselected")
        
    }
    
    
    
    @IBAction func Taptolocation(_ sender: UIButton) {
        
        
        // For use in foreground
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            self.setUsersClosestCity()
        }//if authorized
    }//locationManager func declaration
    
    
    
    @IBAction func Taptoage(_ sender: UIButton) {
        
        let agearry = ["Below 18", "18-24", "25-34","35-44","Above 45"]
        FTPopOverMenu.show(forSender: sender, withMenuArray: agearry, doneBlock: { (selectedIndex) in
            print(selectedIndex)
            self.agelabel.text = agearry[selectedIndex]
            
            
        }) {
            
        }
        
    }
    @IBAction func Taptogender(_ sender: UIButton) {
        let gederarray = ["Male", "Female"]
        FTPopOverMenu.show(forSender: sender, withMenuArray: ["Male", "Female"], doneBlock: { (selectedIndex) in
            print(selectedIndex)
            self.genderlabel.text = gederarray[selectedIndex]
        }) {
            
        }
        
    }
    
    
    
    func setUsersClosestCity()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            // addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
            }
            var addresh = String()
            // Access each element manually
            if let locationName = addressDict["Name"] as? String {
                print(locationName)
            }
            if let street = addressDict["Thoroughfare"] as? String {
                print(street)
            }
            if let city = addressDict["City"] as? String {
                print(city)
                addresh = city
            }
            if let zip = addressDict["ZIP"] as? String {
                print(zip)
            }
            if let country = addressDict["Country"] as? String {
                print(country)
                addresh =   "\(addresh) , \(country)"
                
            }
            
            self.locationbutton.setTitle(addresh, for: .normal)
            
        })
    }
    
    func gotoOTPacreen(otp:String,userid:String)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let oTPViewController = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        oTPViewController.user_id = userid
        oTPViewController.mobileno = Phone_tx.text!
        self.navigationController?.pushViewController(oTPViewController, animated: true)
        // self.slideMenuController()?.changeMainViewController(oTPViewController, close: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        muscrollview.contentInset = contentInsets
        muscrollview.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        muscrollview.contentInset = .zero
        muscrollview.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}





