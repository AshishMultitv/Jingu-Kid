//
//  MyProfileViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 15/07/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import FTPopOverMenu
import FormToolbar
import AFNetworking
import JCTagListView
import GooglePlacesSearchController
import SDWebImage



class MyProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var myprofileimageview: UIImageView!
    @IBOutlet var Firstname: UITextField!
    @IBOutlet var lastname: UITextField!
     @IBOutlet var genderlabel: UILabel!
    @IBOutlet var dob_tx: UITextField!
     @IBOutlet var email_tx: UITextField!
    @IBOutlet var contact_numbertx: UITextField!
      var toolbar = FormToolbar()
    @IBOutlet var myscroolview: UIScrollView!
    @IBOutlet var Zonarbutton: UIButton!

    var datePickerView = UIDatePicker()
    var isprofileimagechange = Bool()
    var isprofilemakeupdate = Bool()
    var imagePicker = UIImagePickerController()
    var imagebase64str = String()

    @IBOutlet var UserIntresetedlabel: JCTagListView!
     let GoogleMapsAPIServerKey = "AIzaSyAG4YEhCbm63GjZyU_94vHsq8DBP4SWU_M"
    
    override func viewDidLoad() {
        super.viewDidLoad()
         Firstname.maxLength = 20
         lastname.maxLength = 20
         isprofilemakeupdate = false
        self.setbordercolor()
        Common.getRoundImage(imageView: myprofileimageview, radius: myprofileimageview.frame.size.height/2)
        isprofileimagechange = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        self.toolbar = FormToolbar(inputs: [Firstname, lastname,contact_numbertx])
       
       
 
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
  
   
        
        self.navigationController?.isNavigationBarHidden = true
        if(!isprofilemakeupdate)
        {
            if(Common.Islogin())
            {
                
                self.setprofiledata()
            }
        }
        
    }
    
    func setbordercolor()
    {
       // Common.settextfieldborderwidth(textfield: name_txfield, borderwidth: 1.0)
        //Common.settextfieldborderwidth(textfield: email_txfiled, borderwidth: 1.0)
 

    }
    
    @IBAction func Taptoagegroup(_ sender: UIButton)
    {
     let agearry = ["Below 18", "18-24", "25-34","35-44","Above 45"]
        FTPopOverMenu.show(forSender: sender, withMenuArray: agearry, doneBlock: { (selectedIndex) in
            print(selectedIndex)
            self.dob_tx.text = agearry[selectedIndex]
            
            
            
        }) {
            
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if(textField == dob_tx)
        {
            createdatepicker(sender: textField)
        }
        else
        {
            self.toolbar.update()
        }

        
        
    }
  
    
    func cleeAllfield()
    {
       Firstname.text = ""
        lastname.text = ""
        dob_tx.text = ""
         dob_tx.text = ""
        contact_numbertx.text = ""
        genderlabel.text = ""
        email_tx.text = ""
    }
    

    func setprofiledata()
    {
        
          cleeAllfield()
         let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
         print(dict)
 
        //set name
        
         if(Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?))
        {
            Firstname.text = dict.value(forKey: "first_name") as? String
         }
        if(Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?))
        {
            lastname.text = dict.value(forKey: "last_name") as? String
          }
       
        if(Common.isNotNull(object: dict.value(forKey: "dob") as AnyObject?))
        {
            dob_tx.text = dict.value(forKey: "dob") as? String
         }
        if(Common.isNotNull(object: dict.value(forKey: "contact_no") as AnyObject?))
        {
            contact_numbertx.text = dict.value(forKey: "contact_no") as? String
            
        }
        if(Common.isNotNull(object: dict.value(forKey: "gender") as AnyObject?))
        {
            genderlabel.text = dict.value(forKey: "gender") as? String
            
        }
        if(Common.isNotNull(object: dict.value(forKey: "email") as AnyObject?))
        {
            email_tx.text = dict.value(forKey: "email") as? String
            
        }
      
        
      
        if Common.isNotNull(object: dict.value(forKey: "image") as AnyObject?)
        {
      
            let url =  dict.value(forKey: "image") as! String
            if(url != "")
            {
          //  myprofileimageview.setImageWith(URL(string: url)!)
                
                let urlImg = URL(string:url)
                myprofileimageview.sd_setImage(with: urlImg, placeholderImage: nil, options: .highPriority, completed: nil)
                
            }
            else
            {
                myprofileimageview.image = UIImage.init(named: "userprofile")
 
            }
        }
        else
        {
         myprofileimageview.image = UIImage.init(named: "userprofile")
        }


    }
    
      @IBAction func TAptolocation(_ sender: UIButton)
      {
      
        
        let controller = GooglePlacesSearchController(
            apiKey: GoogleMapsAPIServerKey,
            placeType: PlaceType.address
        )
         controller.didSelectGooglePlace { (place) -> Void in
            print(place.description)
            
            //Dismiss Search
            controller.isActive = false
        }
        
        present(controller, animated: true, completion: nil)
        
        
     }
    @IBAction func TAptoimage(_ sender: UIButton) {
        
        imagePicker.delegate = self
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Camera", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.openCamera()
                
        })
        
        let deleteAction = UIAlertAction(title: "Gallery", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.openGallary()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    func openCamera()
    {
        
        
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func TaptosaveProfile(_ sender: UIButton) {
        self.updateprofiledata()
    }
    
    @IBAction func Taptomenu(_ sender: UIButton) {
          slideMenuController()?.openLeft()
    }

    @IBAction func Taptogender(_ sender: UIButton) {
        
        let genderarray = ["Male", "Female"]
        FTPopOverMenu.show(forSender: sender, withMenuArray: genderarray, doneBlock: { (selectedIndex) in
         print(selectedIndex)
           self.genderlabel.text = genderarray[selectedIndex] as String
        }) {
            
        }
        
        
        
    }
    
    func createdatepicker(sender: UITextField)
    {
        
        let inputView = UIView(frame: CGRect.init(x:0, y:0, width:self.view.frame.width, height:240))
        datePickerView  = UIDatePicker(frame: CGRect.init(x:0, y:40, width:0, height:0))
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        datePickerView.maximumDate = NSDate() as Date
        inputView.addSubview(datePickerView) // add date picker to UIView
         let doneButton = UIButton(frame: CGRect.init(x:(self.view.frame.size.width/2) - (100/2), y:0, width:100, height:50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: #selector(doneButton(sender:)), for: UIControlEvents.touchUpInside) // set button click event
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        handleDatePicker(sender: datePickerView)
        
    }
    func doneButton(sender:UIButton)
    {
        dob_tx.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dob_tx.text = dateFormatter.string(from: sender.date)
    }
    
    func updateprofiledata()
    {
        
        
        var age = dob_tx.text
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
       
        if(Common.Islogin())
        {
            Common.startwhiteloder(view: self.view)
       //  Common.startloder(view: self.view)
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let uiimageview = UIImageView.init(image: UIImage(named: "userprofile"))
        
        var parameters = [String : String]()
        if(!isprofileimagechange)
        {
            parameters = [
                "device": "ios",
                "id": (dict.value(forKey: "id") as! NSNumber).stringValue,
                "first_name": Firstname.text!,
                "last_name": lastname.text!,
                "gender": genderlabel.text!,
                "contact_no": contact_numbertx.text!,
                "dob": dob_tx.text!,
                 "ext": "",
                 "pic":""
            ]
        }
        else
        {
            parameters = [
                "device": "ios",
                "id": (dict.value(forKey: "id") as! NSNumber).stringValue,
                "first_name": Firstname.text!,
                "last_name": lastname.text!,
                "gender": genderlabel.text!,
                "contact_no": contact_numbertx.text!,
                "dob": dob_tx.text!,
                 "ext": "jpg",
                "pic":imagebase64str
            ]
        }
        
           print(parameters)
            var url = String(format: "%@%@", LoginCredentials.Editapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
              //  Common.stoploder(view: self.view)
                Common.stopwhiteloder(view: self.view)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    EZAlertController.alert(title: "\(dict.value(forKey: "error") as! String)")
                    return
                }
                
                let data = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                print(data)
                self.isprofileimagechange = false
                dataBase.deletedataentity(entityname: "Logindata")
                dataBase.Savedatainentity(entityname: "Logindata", key: "logindatadict", data: data)
                self.setprofiledata()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)
                self.dob_tx.resignFirstResponder()
                self.datePickerView.resignFirstResponder()
                EZAlertController.alert(title: "Profile Update Successfully.")
            
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
           // Common.stoploder(view: self.view)
            Common.stopwhiteloder(view: self.view)

        }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login first to update profile")

         }
        
    }

    func converimagetobase64(image:UIImage)
    {
         let tmpData: NSData? = image.jpeg(.lowest) as NSData?
        imagebase64str = (tmpData?.base64EncodedString(options: .lineLength64Characters))!
        
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Common.getRoundImage(imageView: profileimage_view, radius: profileimage_view.frame.size.height/2)
            //profileimage_view.contentMode = .scaleAspectFit
            myprofileimageview.image = pickedImage
             isprofileimagechange = true
            myprofileimageview.image =  myprofileimageview.image?.fixOrientation()
            converimagetobase64(image: myprofileimageview.image!)
            isprofilemakeupdate = true

        }
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
        isprofileimagechange = false
        
    }
    

    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        myscroolview.contentInset = contentInsets
        myscroolview.scrollIndicatorInsets = contentInsets

    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        myscroolview.contentInset = .zero
        myscroolview.scrollIndicatorInsets = .zero

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
//MARK:- SlideMenuControllerDelegate Action delegate
extension MyProfileViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}



 
