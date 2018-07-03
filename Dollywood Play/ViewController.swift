//
//  ViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 25/05/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
 import MXSegmentedPager
import AFNetworking
import MBProgressHUD
import Kingfisher



class ViewController: UIViewController,MXSegmentedPagerDataSource,MXSegmentedPagerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,ImageCarouselViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var corasalhightcnstrant1: NSLayoutConstraint!
    @IBOutlet var corasalhightcnstrant: NSLayoutConstraint!
    @IBOutlet weak var srollviewviewhgtconstrant: NSLayoutConstraint!
    @IBOutlet weak var myscrollview: UIScrollView!
     @IBOutlet var imagecarouselview1: ImageCarouselView!
    @IBOutlet weak var imageCarouselView: ImageCarouselView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var scrollXpos: CGFloat = 0.0
    var scrollYpos: CGFloat = 0.0

    var images: [UIImage]!
    var cellView: UIView?
    var genreName: UILabel?
    var uploadtimelabel: UILabel?
    var videoviewlabel: UILabel?
     var subgenreName: UILabel?
    var dummyLabel: UILabel?
    var cellImage: UIImageView?
    var cellbannerimageview: UIImageView?
    var cellheaderimageview1: UIImageView?
    var button: UIButton?
    var morebutton: UIButton!
    var morebutton1: UIButton!
    var removemorebutton: UIButton!
    var homechannelheaderbutton: UIButton?
    var channelheaderheaderbutton: UIButton?
    var homebutton: UIButton?
    var dummyView: UIView?
    var Borderview: UIView?
    var timerview: UIView?
    var timelabel: UILabel?
    var playbutton: UIButton?
    var sectionValueBookIds = [Any]()
    var HomeData_dict:NSMutableDictionary = NSMutableDictionary()
    var sidemenudatadict:NSMutableDictionary = NSMutableDictionary()
    var Slidermenulist_dict:NSMutableDictionary = NSMutableDictionary()
    var Slidermenusegment_dict:NSMutableDictionary = NSMutableDictionary()
    var Catdata_dict:NSMutableDictionary = NSMutableDictionary()
    var mXSegmentedPager = MXSegmentedPager()
    var nextbutton = UIButton()
    var slidermenuarray = NSMutableArray()
    var slidermenu_ids = [String]()
    var collectionviewarray = NSMutableArray()
    var otherviewarray = NSArray()
    var Ishomedata = Bool()
    var Iscliptv = Bool()
    var Ismoviepromo = Bool()
    var featurebanner = NSArray()
    var Zonardataarray = NSArray()
    var dummybutton: UIButton?
    @IBOutlet var activityindicater: UIActivityIndicatorView!
    @IBOutlet var Channel_view: UIView!
    @IBOutlet var OtherView: UIView!
    @IBOutlet var Othertableview: UITableView!
     @IBOutlet var Homeview: UIView!
     var channelarray = NSArray()
    var channeldatadict = NSMutableDictionary()
    var Ischannel = Bool()
    var flag = String()
    var display_offset = String()
    var Isscroolenable = Bool()
    var Iswebseries = Bool()

    
    @IBOutlet var Channel_collectionview: UICollectionView!
    @IBOutlet var OtherCollectionview: UICollectionView!

    
    //MARK:- View did Load
    override func viewDidLoad()
    {
         self.Channel_collectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        // myCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        Isscroolenable = true
        Common.startloder(view: self.view)
        super.viewDidLoad()
        self.setupcollectionview()
        setupothercollectionview()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHome), name: NSNotification.Name(rawValue: "RefreshHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clickcoresal), name: NSNotification.Name(rawValue: "clickoncoresal"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setdataincontinuewatching), name: NSNotification.Name(rawValue: "CallHomeapi"), object: nil)
        activityindicater.hidesWhenStopped = true
        dataBase.deletedataentity(entityname: "Homedata")
        LoginCredentials.Display_offset_home = "0.0"
        LoginCredentials.Flag_Home = "0.0"
         flag = "0"
         display_offset = "0"
          Ishomedata = true
        self.getdatabaseresponse()

      }
    
    
    func refreshHome()
    {
        Ishomedata = true
        Homeview.isHidden = false
        Channel_view.isHidden = true
        collectionviewarray.removeAllObjects()
        Slidermenusegment_dict.removeAllObjects()
         mXSegmentedPager.segmentedControl.selectedSegmentIndex = 0
        self.myCollectionView.reloadData()
        self.getslidermenudata()
        self.callhomedatawebapi()
       // self.viewDidLoad()

 
    }
    
   
    
    func chekcUsersubscription()
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(dict.value(forKey: "id") as! NSNumber)
      //  var url = String(format: "%@/subscriptionapi/v6/spackage/subscription/token/%@/device/ios/uid/%@",Subscriptionbaseurl,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue)
        
        var url = String(format: "%@%@/device/ios/uid/%@",LoginCredentials.Subscriptionpakegelistapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue)
        
        
        url = url.trimmingCharacters(in: .whitespaces)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    
                    
                }
                else
                {
                    if let _ = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "package_list")
                    {
                       
                      let pakkagearray = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "package_list") as! NSArray
                       if(pakkagearray.count>0)
                       {
                        LoginCredentials.UserPakegeList = pakkagearray
                        }
                        else
                       {
                        
                        }
                        
                        
                    }
                }
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    
   
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll finished")
//        if(Ishomedata)
//        {
//            if(Isscroolenable)
//            {
//          activityindicater.startAnimating()
//           self.callhomedatawebapi()
//            Isscroolenable = false
//            }
//            else
//            {
//              activityindicater.stopAnimating()
//            }
//        }
        
    }
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation([.portrait])
          self.navigationController?.isNavigationBarHidden = true
        if(Common.Islogin()) {
            self.chekcUsersubscription()
        }
     }


        func getZonerlist()
        {
            Common.startloder(view: self.view)
            let parameters = [
                "device": "ios",
                ]
            var url = String(format: "%@%@/device/ios", LoginCredentials.Zonarapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)
            let manager = AFHTTPSessionManager()
            manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    self.Zonardataarray = dict.value(forKey: "result") as! NSArray
                    print(self.Zonardataarray)
                    
                    if(self.Zonardataarray.count > 0)
                    {
                        let dict = NSMutableDictionary()
                        let Zonarmutablearray  = NSMutableArray()
                        for i in 0..<self.Zonardataarray.count {
                             let dict = self.Zonardataarray.object(at: i) as! NSDictionary
                             Zonarmutablearray.add(dict)
                         }
                        dict.setValue(Zonarmutablearray, forKey: "cat_cntn")
                        dict.setValue("Characters", forKey: "cat_name")
                        if(self.collectionviewarray.count>0)
                        {
                        self.collectionviewarray.insert(dict, at: 1)
                        }
                        else
                        {
                            self.collectionviewarray.insert(dict, at: 0)

                        }
                        
                    }
 
                    self.myscrollview.setContentOffset(CGPoint.zero, animated: true)
                    
                  
                    
                    var collectionheight = 0
                    if(self.collectionviewarray.count<=3)
                    {
                        collectionheight = self.collectionviewarray.count*50
                    }
                    else if(self.collectionviewarray.count>3 || self.collectionviewarray.count>5)
                    {
                        collectionheight = self.collectionviewarray.count*85
                    }
                    else if(self.collectionviewarray.count>5 || self.collectionviewarray.count>7)
                    {
                        collectionheight = self.collectionviewarray.count*85
                    }
                    else
                    {
                        collectionheight = self.collectionviewarray.count*95
                    }
          
                   // let collectionheight = self.collectionviewarray.count*80
                    self.srollviewviewhgtconstrant.constant = CGFloat(collectionheight) + 20.0
                    self.setimageincarouseview()
                    Common.stoploder(view: self.view)
                    self.myCollectionView.reloadData()
                   Common.stoploder(view: self.view)
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
            }
            
        }
        
        

    
    
    func getdatabaseresponse()
    {
        
        self.Slidermenulist_dict = NSMutableDictionary()
        self.slidermenuarray = NSMutableArray()
        
        self.sidemenudatadict = dataBase.getDatabaseresponseinentity(entityname: "Sidemenudata", key: "sidemenudatadict")
        self.HomeData_dict = dataBase.getDatabaseresponseinentity(entityname: "Homedata", key: "homedatadict")
        
        self.Slidermenulist_dict = dataBase.getDatabaseresponseinentity(entityname: "Slidermenu", key: "slidemenudict")
        if(self.sidemenudatadict.count>0)
        {
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Sidemenunotification"), object: self.sidemenudatadict)
        }
        else
        {
           self.getSidemenu()
        }
        
      
        if(self.Slidermenulist_dict.count>0)
        {
            self.slidermenuarray.add("Home")
            for i in 0..<((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod")  as! NSArray).count {
                if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
                {
                    if((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "age_group") as! String  == LoginCredentials.Agegroup) {
                        self.slidermenuarray.add(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String))
                        self.slidermenu_ids.append(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "id") as! String))
                    }
                }
                else
                {
                    self.slidermenuarray.add(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String))
                    self.slidermenu_ids.append(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "id") as! String))
                }
            }
            
            
            
            
 
//            for i in 0..<((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod")  as! NSArray).count {
//                self.slidermenuarray.add(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String))
//                self.slidermenu_ids.append(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "id") as! String))
//            }
            print(self.slidermenuarray)
            self.setmenu()
        }
        else
        {
           self.getslidermenudata()
        }
        
        if(self.HomeData_dict.count>0)
        {
            Homeview.isHidden = false
            OtherView.isHidden = true
            Channel_view.isHidden = true

             Ischannel = false
            Ishomedata = true
            Iscliptv = false
            Ismoviepromo = false
            collectionviewarray = NSMutableArray()
            self.collectionviewarray =  ((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).mutableCopy() as! NSMutableArray
            
            
            if(self.collectionviewarray.count<=0) {
                let array = NSArray()
                self.collectionviewarray.add(array)
            }
            
           // self.flag = self.HomeData_dict.value(forKey: "flag") as! String
          //  self.display_offset =  (self.HomeData_dict.value(forKey: "display_offset") as! NSNumber).stringValue
            
            
            
            
           //set continue watching data
            if(Common.Islogin())
            {
                let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                
                let continuewatchingarray = dataBase.getcontinuewatchingfromdatabase(userid: (dict.value(forKey: "id") as! NSNumber).stringValue) as NSMutableArray
                if(continuewatchingarray.count > 0)
                {
                    let dict = NSMutableDictionary()
                    let continuewatchingmutablearray  = NSMutableArray()
                    for i in 0..<continuewatchingarray.count {
                        
                        let array = continuewatchingarray.object(at: i) as! NSDictionary
                        // array.setValue("Continue Watching", forKey: "cat_name")
                        continuewatchingmutablearray.add(array)
                        
                    }
                    dict.setValue(continuewatchingmutablearray, forKey: "cat_cntn")
                    dict.setValue("Continue Watching", forKey: "cat_name")
                    self.collectionviewarray.insert(dict, at: 0)
                    
                }
            }
            //end continue watching data
            
            
            

            self.featurebanner =  (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner") as! NSArray
             getZonerlist()
    

        }
        else
        {
            self.callhomedatawebapi()
            
        }
        
        
    }
    
    
    
    func setdataincontinuewatching() {
        
        //set continue watching data
        if(Common.Islogin())
        {
            if(Ishomedata)
            {
            collectionviewarray = NSMutableArray()
            self.collectionviewarray =  ((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).mutableCopy() as! NSMutableArray
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            
            let continuewatchingarray = dataBase.getcontinuewatchingfromdatabase(userid: (dict.value(forKey: "id") as! NSNumber).stringValue) as NSMutableArray
            if(continuewatchingarray.count > 0)
            {
                let dict = NSMutableDictionary()
                let continuewatchingmutablearray  = NSMutableArray()
                for i in 0..<continuewatchingarray.count {
                    
                    let array = continuewatchingarray.object(at: i) as! NSDictionary
                    // array.setValue("Continue Watching", forKey: "cat_name")
                    continuewatchingmutablearray.add(array)
                    
                }
                dict.setValue(continuewatchingmutablearray, forKey: "cat_cntn")
                dict.setValue("Continue Watching", forKey: "cat_name")
                self.collectionviewarray.insert(dict, at: 0)
                 getZonerlist()
                }
            }
        }
    }
    
    
    //MARK:- SetUp Collection view
    func setupcollectionview()
    {
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        myCollectionView.alwaysBounceVertical = true
        myCollectionView.backgroundColor = UIColor.init(colorLiteralRed: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 1.0)
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "background_white")?.draw(in: view.bounds)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
       // view.backgroundColor = UIColor(patternImage: image!)
        navigationController?.navigationBar.barTintColor = UIColor.purple
        
    }
    
   
    
    func setupothercollectionview()
    {
        OtherCollectionview.dataSource = self
        OtherCollectionview.delegate = self
        
        OtherCollectionview.alwaysBounceVertical = true
        OtherCollectionview.backgroundColor = UIColor.init(colorLiteralRed: 16.0/255, green: 16.0/255, blue: 16.0/255, alpha: 1.0)
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "background_white")?.draw(in: view.bounds)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //view.backgroundColor = UIColor(patternImage: image!)
        navigationController?.navigationBar.barTintColor = UIColor.purple
        
    }
    
    
    //MARK:- Call Slidermenuapi
    func getslidermenudata()
    {
        let parameters = [
            "device": "ios",]
        
        var url = String(format: "%@%@/device/ios", LoginCredentials.catlistapi,Apptoken)
        
        if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
        {
               url = String(format: "%@%@/device/ios/age_group/%@", LoginCredentials.catlistapi,Apptoken,LoginCredentials.Agegroup)
         //   url = String(format: "%@%@/device/ios/display_offset/0/display_limit/20/content_count/5/age_group/%@", LoginCredentials.Homeapi,Apptoken,LoginCredentials.Agegroup)
        }
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                self.Slidermenulist_dict = NSMutableDictionary()
                self.slidermenuarray = NSMutableArray()
                
                if(LoginCredentials.Isencriptcatlistapi)
                {
                    self.Slidermenulist_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    self.Slidermenulist_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                

                
                print(self.Slidermenulist_dict)
                dataBase.Savedatainentity(entityname: "Slidermenu", key: "slidemenudict", data: self.Slidermenulist_dict)
                
                self.slidermenuarray.add("Home")
                 for i in 0..<((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod")  as! NSArray).count {
                    if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
                    {
                      if((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "age_group") as! String  == LoginCredentials.Agegroup) {
                    self.slidermenuarray.add(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String))
                    self.slidermenu_ids.append(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "id") as! String))
                    }
                    }
                    else
                    {
                        self.slidermenuarray.add(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String))
                        self.slidermenu_ids.append(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "id") as! String))
                    }
                }
               
                 print(self.slidermenuarray)
                self.setmenu()
                
                // self.mXSegmentedPager.reloadData()
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
    }
    
    //MARK:- Call Home Data Api
    
    func callhomedatawebapi()
    {
        
        if(LoginCredentials.Display_offset_home == "")
        {
          LoginCredentials.Display_offset_home = "0"
             LoginCredentials.Flag_Home = "0"
        }
        let parameters = [
            "device": "ios",
            "content_count" : "5",
            "display_limit" : "3",
            "display_offset" : LoginCredentials.Display_offset_home,
         //   "flag" :  LoginCredentials.Flag_Home
         ]
        
   // var url = String(format: "%@%@/device/ios/content_count/5/display_limit/3/display_offset/%@", LoginCredentials.Homeapi,Apptoken,LoginCredentials.Display_offset_home)
        
        var url = String(format: "%@%@/device/ios/display_offset/0/display_limit/20/content_count/5", LoginCredentials.Homeapi,Apptoken)
        
        if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
        {
        url = String(format: "%@%@/device/ios/display_offset/0/display_limit/20/content_count/5/age_group/%@", LoginCredentials.Homeapi,Apptoken,LoginCredentials.Agegroup)
        }
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                self.HomeData_dict.removeAllObjects()
                if(LoginCredentials.IsencriptHomeapi)
                {
                    self.HomeData_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    self.HomeData_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                 print(self.HomeData_dict)
                
                if((self.display_offset == "0") && (self.flag == "0"))
                {
                 //  self.collectionviewarray.removeAllObjects()
                 //  dataBase.deletedataentity(entityname: "Homedata")
                    
                }
                
                let dictnew = dataBase.getDatabaseresponseinentity(entityname: "Homedata", key: "homedatadict")
                if(dictnew.count>0)
                {
                    
                }
                else
                {
                    dataBase.Savedatainentity(entityname: "Homedata", key: "homedatadict", data:self.HomeData_dict)
                }
                
             
                
                if let _ = (self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category")
                
             //   if(((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).count > 0)
                {
               
                    
                     for i in 0..<((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).count {
                        
                      
                        if(self.collectionviewarray.contains((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray))
                        {
                            
                        }
                        else
                        {
                        self.collectionviewarray.add(((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).object(at: i))
                        }
                        
                    }
                    
                    if(self.collectionviewarray.count<=0) {
                        let array = NSArray()
                         self.collectionviewarray.add(array)
                    }
                    
                    
              // self.collectionviewarray.add(((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).mutableCopy() as! NSMutableArray)
             
                    
                    
                if let _ = (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner")
                {
                    
                    if(Common.isNotNull(object:  (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner") as AnyObject))
                   {
                    self.featurebanner =  (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner") as! NSArray
                    self.setimageincarouseview()
                    }
                    }
                    
//                 if(self.featurebanner.count>0)
//                 {
//
//                    }
//                    else
//                 {
//                self.featurebanner =  (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner") as! NSArray
//                     self.setimageincarouseview()
//                    }
              //  LoginCredentials.Flag_Home = self.HomeData_dict.value(forKey: "flag") as! String
                LoginCredentials.Display_offset_home =  (self.HomeData_dict.value(forKey: "display_offset") as! NSNumber).stringValue
               var collectionheight = Int()
                print(self.collectionviewarray.count)
                collectionheight = (self.collectionviewarray.count*75) + 180
                    
//                    if(self.collectionviewarray.count<=3)
//                    {
//                       collectionheight = self.collectionviewarray.count*50
//                    }
//                     if(self.collectionviewarray.count>3)
//                    {
//                        collectionheight = self.collectionviewarray.count*60
//   
//                    }
//                     if(self.collectionviewarray.count>5)
//                    {
//                       collectionheight = self.collectionviewarray.count*70
//                    }
//                     if(self.collectionviewarray.count >= 6)
//                    {
//                        collectionheight = self.collectionviewarray.count*100
//
//                    }
//                  
                  self.srollviewviewhgtconstrant.constant = CGFloat(collectionheight)
                
                  
                Common.stoploder(view: self.view)
                
                
                
                //set continue watching data
                
                if(Common.Islogin())
                {
                    let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                    
                    let continuewatchingarray = dataBase.getcontinuewatchingfromdatabase(userid: (dict.value(forKey: "id") as! NSNumber).stringValue) as NSMutableArray
                    if(continuewatchingarray.count > 0)
                    {
                        let dict = NSMutableDictionary()
                        let continuewatchingmutablearray  = NSMutableArray()
                         for i in 0..<continuewatchingarray.count {
                             let array = continuewatchingarray.object(at: i) as! NSDictionary
                             continuewatchingmutablearray.add(array)
                         }
                         dict.setValue(continuewatchingmutablearray, forKey: "cat_cntn")
                        dict.setValue("Continue Watching", forKey: "cat_name")
                        self.collectionviewarray.insert(dict, at: 0)
                        
                    }
                }
                //end continue watching data
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                //self.myCollectionView.reloadData()
                self.getZonerlist()
                self.Isscroolenable = true
     
                }
                else
                {
                   // self.getZonerlist()
                   // self.Isscroolenable = true
                    self.activityindicater.isHidden = true
                    
                   //dataBase.Savedatainentity(entityname: "Homedata", key: "homedatadict", data:homedata_dictnew)
                 }
                
                
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
    }
    
    
    //MARK:- Get Side Menu
    func getSidemenu()
    {
        
        let parameters = [
            "device": "ios",
            ]
        var url = String(format: "%@%@/device/ios", LoginCredentials.MenuAPi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)

        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                if(LoginCredentials.IsencriptMenuAPi)
                {
                    self.sidemenudatadict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    self.sidemenudatadict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                 dataBase.Savedatainentity(entityname: "Sidemenudata", key: "sidemenudatadict", data: self.sidemenudatadict)
                 print(self.sidemenudatadict)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Sidemenunotification"), object: self.sidemenudatadict)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    
    //MARK:- Get catlistdata
    func Getcatlistdata(id:String,index:Int)
    {
        let parameters = [
            "device": "ios",
            "cat_id": id,
            "max_counter": "100"
            ] as [String : Any]
        
        
        var url = String(format: "%@%@/device/ios/current_offset/0/max_counter/100/cat_id/%@", LoginCredentials.Listapi,Apptoken,id)
        
        if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
        {
           
            url = String(format: "%@%@/device/ios/current_offset/0/max_counter/100/cat_id/%@/age_group/%@", LoginCredentials.Listapi,Apptoken,id,LoginCredentials.Agegroup)
        }
        
      // var url = String(format: "%@%@/device/ios/cat_id/%@/max_counter/100", LoginCredentials.Listapi,Apptoken,id)
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                
                let number = dict.value(forKey: "code") as! NSNumber
                self.collectionviewarray = NSMutableArray()
                self.featurebanner = NSArray()
                
                if(number != 0)
                {
                if(LoginCredentials.IsencriptListapi)
                {
                    self.Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    self.Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                    
                    dataBase.Savecatlist(entityname: "Catlistdata", id: id, key: "catlistdatadict", data:self.Catdata_dict)
                    print(self.Catdata_dict)
                    if(Common.isNotNull(object: self.Catdata_dict.value(forKey: "feature") as AnyObject))
                    {
                     self.featurebanner = (self.Catdata_dict.value(forKey: "feature") as! NSArray)
                    }
                    else
                    {
                       self.featurebanner = NSArray()
                    }
                    self.collectionviewarray = (self.Catdata_dict.value(forKey: "content") as! NSArray).mutableCopy() as! NSMutableArray
            }
                
                else
                {
                    EZAlertController.alert(title: "No result found.")
                    self.Slidermenusegment_dict.removeAllObjects()
                     self.Catdata_dict = NSMutableDictionary()
                     dataBase.Savecatlist(entityname: "Catlistdata", id: id, key: "catlistdatadict", data:self.Catdata_dict)
                }
                
                print(index)
                if(index == 4)
                {
                    self.setimageincarouseview1()
                     self.Homeview.isHidden = true
                     self.Channel_view.isHidden = false
                     self.OtherView.isHidden = true
                     self.Channel_collectionview.reloadData()
                    let collectionheight = (self.collectionviewarray.count/2)*75
                    self.srollviewviewhgtconstrant.constant = CGFloat(collectionheight)
                }
                else
                {
                    self.setimageincarouseview()
                    self.Homeview.isHidden = false
                    self.Channel_view.isHidden = true
                    self.myCollectionView.reloadData()
                    var countarry = NSArray()
                    if let _ = self.Slidermenusegment_dict.value(forKey: "children")
                    {
                        countarry = self.Slidermenusegment_dict.value(forKey: "children") as! NSArray
                     }
                    print(countarry.count)
 
                    var collectionheight = 0
                    if(countarry.count<=3)
                    {
                        collectionheight = countarry.count*50
                    }
                    else if(countarry.count>3 || countarry.count>5)
                    {
                        collectionheight = countarry.count*80
                    }
                    else if(countarry.count>5 || countarry.count>7)
                    {
                        collectionheight = countarry.count*90
                    }
                    else
                    {
                        collectionheight = countarry.count*100
                    }
                    
                    
                    self.srollviewviewhgtconstrant.constant = CGFloat(collectionheight)
                    
              
                }
                let point = CGPoint(x: 0, y: 0)
                self.myscrollview.contentOffset = point
               // self.myscrollview.setContentOffset(CGPoint.zero, animated: true)
                Common.stoploder(view: self.view)
                

                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
             Common.stoploder(view: self.view)
            self.collectionviewarray = NSMutableArray()
            self.featurebanner = NSArray()
            EZAlertController.alert(title: error.localizedDescription)
            self.Slidermenusegment_dict.removeAllObjects()
            self.Catdata_dict = NSMutableDictionary()
            dataBase.Savecatlist(entityname: "Catlistdata", id: id, key: "catlistdatadict", data:self.Catdata_dict)
            
            if(index == 4)
            {
                
                self.setimageincarouseview1()
                self.Homeview.isHidden = true
                self.Channel_view.isHidden = false
                self.OtherView.isHidden = true
                self.Channel_collectionview.reloadData()
                let collectionheight = (self.collectionviewarray.count/2)*75
                self.srollviewviewhgtconstrant.constant = CGFloat(collectionheight)
            }
            else
            {
                self.setimageincarouseview()
                self.Homeview.isHidden = false
                self.Channel_view.isHidden = true
                self.myCollectionView.reloadData()
                var countarry = NSArray()
                if let _ = self.Slidermenusegment_dict.value(forKey: "children")
                {
                    countarry = self.Slidermenusegment_dict.value(forKey: "children") as! NSArray
                }
                 var collectionheight = 0
                collectionheight = countarry.count*100
                self.srollviewviewhgtconstrant.constant = CGFloat(collectionheight)
            }
            
            
        }
        
    }
    
     //MARK:-   Zonerbutton action
    
    func taponzonar()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let zonerViewController = storyboard.instantiateViewController(withIdentifier: "ZonerViewController") as! ZonerViewController
        self.navigationController?.pushViewController(zonerViewController, animated: true)
    }
    
    
    @IBAction func TaptoZoner(_ sender: UIButton) {
        
        if(Common.Islogin()) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // let zonerViewController = storyboard.instantiateViewController(withIdentifier: "ZonerViewController") as! ZonerViewController
         let ageFilterViewController = storyboard.instantiateViewController(withIdentifier: "AgeFilterViewController") as! AgeFilterViewController
        // let userintersetViewController = storyboard.instantiateViewController(withIdentifier: "UserintersetViewController") as! UserintersetViewController
        self.navigationController?.pushViewController(ageFilterViewController, animated: true)
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please Login to Update Profile")
        }
      
        
    }
    
    
    
    
    //MARK:- UITableView delegate method
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.otherviewarray.count
        
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[0] as! Custometablecell
        cell.selectionStyle = .none
        Common.getRounduiview(view: cell.cellouterview, radius: 1.0)
        cell.cellouterview.layer.borderColor = UIColor.white.cgColor
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        Common.getRoundLabel(label:  cell.timelabel, borderwidth: 5.0)
        Common.setlebelborderwidth(label: cell.timelabel, borderwidth: 1.0)
        cell.timelabel.layer.borderColor = UIColor.white.cgColor
        
        cell.titlelabel.text = (self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        
        
//        if Common.isNotNull(object: ((self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as AnyObject)
//        {
//            cell.titletypwlabel.text = ((self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as? String
//        }
//        else
//        {
//            cell.titletypwlabel.text = ""
//        }
        
        var discriptiontext = (self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cell.desciptionlabel.text = discriptiontext
        let url = ((((self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
        if(url == "")
        {
          cell.imageview.image = UIImage.init(named: "Placehoder1")
        }
        else
        {
        cell.imageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder1"))
        }
        let videotime = (self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
        let time = dateFormatter.date(from: videotime!)
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
        
        cell.timelabel.text = coverttime
        
        
        
        return cell
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.Video_url = ""
        
        if(Common.isNotNull(object: (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
        playerViewController.descriptiontext = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        else
        {
         playerViewController.descriptiontext = ""
        }
        playerViewController.liketext = ""
        
        if(Common.isNotNull(object: (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as AnyObject? ))
        {
        playerViewController.tilttext = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        }
        
        playerViewController.fromdownload = "no"
         playerViewController.Download_dic = (otherviewarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
        if Common.isNotNull(object: (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
            
            playerViewController.downloadVideo_url = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as! String
          
        }
        else
        {
            playerViewController.downloadVideo_url = ""
        }
        
        
        var ids = String()
        for i in 0..<((otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
        {
            
            
            let str = ((otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
            ids = ids + str + ","
            
        }
        ids = ids.substring(to: ids.index(before: ids.endIndex))
        playerViewController.catid = ids
        playerViewController.cat_id = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        
        
        
        
        
        if(Common.Islogin())
        {
            
            
            
            self.navigationController?.pushViewController(playerViewController, animated: true)

            
//            if(Common.Isuserissubscribe(Userdetails: self as AnyObject))
//            {
//                self.navigationController?.pushViewController(playerViewController, animated: true)
//            }
//            else
//            {
//
//
//                let alert = UIAlertController(title: "", message: "Hi, User Current you are not subscribed user Please Subscribe and enjoy our greate video", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
//                    Common.PresentSubscription(Viewcontroller: self)
//                }))
//                self.present(alert, animated: true, completion: nil)
//
//
//
//            }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please Login to watch Video")
        }
        
        
     

         // self.navigationController?.pushViewController(playerViewController, animated: true)
        
    }
    
    
    //MARK:-   Collection view delegate method
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if(collectionView == Channel_collectionview)
        {
            return 1
        }
        if Ishomedata
        {
            return collectionviewarray.count
        }
        else
        {
            if  let _ = Slidermenusegment_dict.value(forKey: "children")
         {
            return (Slidermenusegment_dict.value(forKey: "children") as! NSArray).count
            }
            else
         {
            return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if(collectionView == Channel_collectionview)
        {
            return collectionviewarray.count
        }
        else
        {
         return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == myCollectionView
        {
            
         let cell: HomeCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell)
        for viewObject: UIView in (cell?.contentView.subviews)! {
            if (viewObject is UILabel) {
                viewObject.removeFromSuperview()
            }
        }
 
            if(Ishomedata)
            {
            dummyLabel = UILabel(frame: CGRect(x: CGFloat(0.15*CGFloat(view.frame.size.width)), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(30)))
            print(collectionviewarray.object(at: indexPath.section))
            dummyLabel?.text = ((collectionviewarray.object(at: indexPath.section)) as AnyObject).value(forKey: "cat_name") as? String
             dummyLabel?.textAlignment = .left
            dummyLabel?.textColor = UIColor.black
            dummyLabel?.numberOfLines = 0
            dummyLabel?.font = UIFont(name: "Baloo", size: CGFloat(16))
            dummyLabel?.adjustsFontSizeToFitWidth = true
            dummybutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
            homebutton = UIButton.init()
            homebutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
            morebutton1?.removeFromSuperview()
            morebutton = UIButton(frame: CGRect(x: CGFloat(view.frame.size.width-50), y: 5.0, width: 70.0, height: 20.0))
            homechannelheaderbutton = UIButton(frame: CGRect(x: 0, y: 8.0, width: self.view.frame.size.width/2, height: 40.0))
            morebutton?.setImage(UIImage.init(named: "Homemore"), for: .normal)
            morebutton?.titleLabel?.textAlignment = .center
            morebutton?.tag = indexPath.section
             morebutton?.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
            morebutton?.addTarget(self, action: #selector(taptomore), for: .touchUpInside)
            homechannelheaderbutton?.addTarget(self, action: #selector(taptochannelpage), for: .touchUpInside)
            homechannelheaderbutton?.tag = indexPath.section
            dummybutton?.tag = indexPath.section
            homebutton?.tag = indexPath.section
      
            cell?.contentView.addSubview(dummyLabel!)
                
                if(dummyLabel?.text != "Continue Watching") {
                    morebutton?.setImage(UIImage.init(named: "Homemore"), for: .normal)
                    morebutton1?.setImage(UIImage.init(named: ""), for: .normal)
           
                }
                else
                {
//                    if(morebutton.imageView != nil)
//                    {
//                      morebutton.removeFromSuperview()
//                     }
//                    if(morebutton1.imageView
//
//                        != nil)
//                    {
//                         morebutton1.removeFromSuperview()
//                    }
                 //  removemorebutton = UIButton(frame: CGRect(x: CGFloat(view.frame.size.width-50), y: 5.0, width: 70.0, height: 20.0))
                //  removemorebutton?.setImage(UIImage.init(named: "1"), for: .normal)
                    morebutton?.setImage(UIImage.init(named: ""), for: .normal)
                    morebutton1?.setImage(UIImage.init(named: ""), for: .normal)
                   // cell?.contentView.addSubview(removemorebutton!)

 
                 }
             
                
             cell?.contentView.addSubview(morebutton!)
            cell?.contentView.addSubview(dummybutton!)
            cell?.contentView.addSubview(homechannelheaderbutton!)
                
  
                if(indexPath.section == 1)
                {
                    cell?.collectionScroll.contentSize = CGSize(width: CGFloat(((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).count) * Int(self.view.frame.size.width/3)) + 100), height: CGFloat((cell?.frame.size.height)!))
                }
                else
                {
            cell?.collectionScroll.contentSize = CGSize(width: CGFloat(((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).count) * Int(self.view.frame.size.width/2)) + 100), height: CGFloat((cell?.frame.size.height)!))
                }
            for viewObject: UIView in (cell?.collectionScroll.subviews)! {
                viewObject.removeFromSuperview()
            }
            scrollXpos = 0.12*CGFloat(view.frame.size.width)
           var continuewatchingarray = NSMutableArray()
            if(Common.Islogin())
            {
            let logindictnew = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
           
            continuewatchingarray = dataBase.getcontinuewatchingfromdatabase(userid: (logindictnew.value(forKey: "id") as! NSNumber).stringValue) as NSMutableArray
            }
            else
            {
              
            }
           
 
            for i in 0..<((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).count
            {
                print(((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i))
                
                
                cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(0), width: CGFloat(self.view.frame.size.width/2-10), height: CGFloat(100)))
                 if(indexPath.section == 1)
                {
                 cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(0), width: CGFloat(self.view.frame.size.width/3), height: CGFloat(120)))
                  scrollXpos += self.view.frame.size.width/3
                }
                else
                {
                    scrollXpos += self.view.frame.size.width/2-10
                }
              
                 cell?.collectionScroll.addSubview(cellView!)
                
                /////get shadow/////
                Common.getshadowofview(myView: cellView!)
                //////////
                
                
                dummyView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(140)))
                dummyView?.layer.borderColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1)).cgColor
                button = UIButton(type: .custom)
                button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button?.tag = i
                button?.setTitle("", for: .normal)
                button?.frame = CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(100), height: CGFloat(140))
           
          
                cellImage = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(80)))
           
                Common.getRoundImage(imageView: cellImage!, radius: 15.0)
                Common.setuiimageviewdborderwidth(imageView: cellImage!, borderwidth: 2.0)

                
                if(indexPath.section == 1)
                {
                    cellImage = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(25), width: CGFloat(95), height: CGFloat(95)))
                    
                    Common.getRoundImage(imageView: cellImage!, radius: (cellImage?.frame.size.width)!/2)
                    Common.setuiimageviewdborderwidth(imageView: cellImage!, borderwidth: 2.0)
                }
                
                
                if(indexPath.section == 1)
                {
                    
     
                    let str =  (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumb") as? String
                    cellImage?.setImageWith(URL(string: str!)!, placeholderImage: UIImage.init(named: "Placehoder1"))
                
                }
                else
                {
                   
                    if((((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbs") as? NSArray)?.count) == 0)
                    {
                        cellImage?.image = UIImage.init(named: "Placeholder1")
                    }
                    else
                    {
                        
                        var str = String()
                          if(Common.isNotNull(object: (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbs") as AnyObject)) {
                        
                        
                        let arra = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbs") as! NSArray
                        for i in 0..<arra.count
                        {
                            let dict = arra.object(at: i) as! NSDictionary
                            let name  = dict.value(forKey: "name") as! String
                            if(name == "rectangle")
                            {
                                
                                str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                                
                            }
                            else
                            {
                                
                            }
                        }
                        }
                        if(str == "")
                        {
                            cellImage?.image = #imageLiteral(resourceName: "Placehoder1")
                        }
                        else
                        {
                            cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder1"))
                        }
                        
                        
                       // let str  = (((((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbs") as? NSArray)?.object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String)
                       // cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder1"))
                        
                        
                    }
                }
                playbutton = UIButton(frame: CGRect(x: 5, y: (cellImage?.frame.maxY)!+10, width: 20, height: 20))
                playbutton?.setImage(UIImage.init(named: "play"), for: .normal)
                cellbannerimageview = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat((cellImage?.frame.maxY)!-30), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(30)))
                Common.getRoundImage(imageView: cellbannerimageview!, radius: 13.0)
                cellbannerimageview?.image = UIImage.init(named: "cellbottom")
               genreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! - 20), width: CGFloat((cellImage?.frame.size.width)! - 60), height: CGFloat(20)))
                
                if(indexPath.section == 1)
                {
                genreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)!), width: CGFloat((cellImage?.frame.size.width)!), height: CGFloat(20)))
                genreName?.textAlignment = .center
                }
                else
                {
                    genreName?.textAlignment = .left
                }
                subgenreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! + (genreName?.frame.size.height)! + 5), width: CGFloat((cellImage?.frame.size.width)! - 30), height: CGFloat(10)))
              if(indexPath.section == 1)
              {
                      genreName?.text = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "genre_name") as? String
                }
                else
              {
               genreName?.text = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "title") as? String
                }
             
                let subgenreNametext = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "des") as? String
                
                if(Common.isNotNull(object: subgenreNametext as AnyObject?))
                {
                subgenreName?.text = Common.trimstring(text: subgenreNametext!)
                }
                else
                {
                  subgenreName?.text = ""
                }
                
                genreName?.textColor = UIColor.white
                if(indexPath.section == 1)
                {
                  genreName?.textColor = UIColor.black
                }
                genreName?.numberOfLines = 1
                genreName?.font = UIFont(name: "Baloo", size: CGFloat(10))
                
                if(indexPath.section == 1)
                {
                    genreName?.font = UIFont(name: "Baloo", size: CGFloat(13))

                }
                
                subgenreName?.textColor = Discriptioncolor
                subgenreName?.numberOfLines = 1
                subgenreName?.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
                videoviewlabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((subgenreName?.frame.origin.y)! + (subgenreName?.frame.size.height)! + 2), width: CGFloat((cellImage?.frame.size.width)! - 30), height: CGFloat(10)))
                uploadtimelabel = UILabel(frame: CGRect(x: CGFloat((cellImage?.frame.size.width)! - 50), y:  CGFloat((cellImage?.frame.maxY)! - 20), width: CGFloat(50), height: CGFloat(20)))
                uploadtimelabel?.font = UIFont(name: "Baloo", size: CGFloat(10))
                videoviewlabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(8))
                uploadtimelabel?.textColor = UIColor.white
                videoviewlabel?.textColor = Discriptioncolor
                uploadtimelabel?.textAlignment = .left
                
      
                if(indexPath.section == 1)
                {
                  uploadtimelabel?.text = ""
                     videoviewlabel?.text = ""
                }
                else
                {
                    
                    let videotime = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "duration") as! String
                    uploadtimelabel?.text = Common.convertvideoduration(videotime: videotime)
                    videoviewlabel?.text =  "\((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "watch") as! String)\(" view")"
                }
                
              
               
                Borderview = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat((cellImage?.frame.maxY)!)+10))
                Common.setuiviewdborderwidth(View: Borderview!, borderwidth: 0.5)
                
               
                cellView?.addSubview(cellImage!)
                if(indexPath.section == 1)
                {
                    
                }
                else
                {
                    cellView?.addSubview(cellbannerimageview!)
  
                }
                cellView?.addSubview(genreName!)
                cellView?.addSubview(subgenreName!)
                cellView?.addSubview(dummyView!)
                cellView?.addSubview(uploadtimelabel!)
                cellView?.addSubview(videoviewlabel!)
                //cellView?.addSubview(Borderview!)
                cellView?.addSubview(button!)
                
                //cellView?.addSubview(playbutton!)
                cell?.contentView.addSubview(homebutton!)
               

            }
            }
            else
            {
                dummyLabel = UILabel(frame: CGRect(x: CGFloat(0.15*CGFloat(view.frame.size.width)), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(30)))
              //  print(collectionviewarray.object(at: indexPath.section))
                dummyLabel?.text = ((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "name") as? String
                dummyLabel?.textAlignment = .left
                dummyLabel?.textColor = UIColor.black
                dummyLabel?.numberOfLines = 0
                dummyLabel?.font = UIFont(name: "Baloo", size: CGFloat(16))
                dummyLabel?.adjustsFontSizeToFitWidth = true
                dummybutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
                homebutton = UIButton.init()
                homebutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
                morebutton?.removeFromSuperview()
                morebutton1 = UIButton(frame: CGRect(x: CGFloat(view.frame.size.width-50), y: 5.0, width: 70.0, height: 20.0))
                homechannelheaderbutton = UIButton(frame: CGRect(x: 0, y: 8.0, width: self.view.frame.size.width/2, height: 40.0))
                morebutton1?.setImage(UIImage.init(named: "Homemore"), for: .normal)
                morebutton1?.titleLabel?.textAlignment = .center
                morebutton1?.tag = indexPath.section
                 morebutton1?.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
                morebutton1?.addTarget(self, action: #selector(taptomore), for: .touchUpInside)
                homechannelheaderbutton?.addTarget(self, action: #selector(taptochannelpage), for: .touchUpInside)
                homechannelheaderbutton?.tag = indexPath.section
                dummybutton?.tag = indexPath.section
                homebutton?.tag = indexPath.section
                
                
                
                
                cell?.contentView.addSubview(dummyLabel!)
                cell?.contentView.addSubview(morebutton1!)
                cell?.contentView.addSubview(dummybutton!)
                cell?.contentView.addSubview(homechannelheaderbutton!)
              
                for viewObject: UIView in (cell?.collectionScroll.subviews)! {
                    viewObject.removeFromSuperview()
                }
                scrollXpos = 0.12*CGFloat(view.frame.size.width)
       
                let stt = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "id") as! String)
                let dataarray = NSMutableArray()
                for i in 0..<collectionviewarray.count
                {
                    let stt1 = ((((collectionviewarray.object(at: i) as! NSDictionary).value(forKey: "category_ids")) as! NSArray).object(at: 0) as! String)
                    
                    if(stt ==  stt1)
                    {
                        
                        dataarray.add(collectionviewarray.object(at: i))
                        
                    }
                }
       //cell?.collectionScroll.contentSize = CGSize(width: CGFloat((dataarray.count * 100) + 170), height: CGFloat((cell?.frame.size.height)!))
         cell?.collectionScroll.contentSize = CGSize(width: CGFloat((( dataarray.count) * Int(self.view.frame.size.width/2)) + 100), height: CGFloat((cell?.frame.size.height)!))
                
                 for i in 0..<dataarray.count
                {
                 
                    
                   cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(0), width: CGFloat(self.view.frame.size.width/2-10), height: CGFloat(100)))
                    scrollXpos += self.view.frame.size.width/2-10
                 
                    Common.getshadowofview(myView: cellView!)

                    cell?.collectionScroll.addSubview(cellView!)
                    dummyView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(140)))
                    dummyView?.layer.borderColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1)).cgColor
                    button = UIButton(type: .custom)
                    button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                    button?.tag = i
                    button?.setTitle("", for: .normal)
                    button?.frame = CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(100), height: CGFloat(140))
                    
                    
                    cellImage = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(80)))
                    
                    Common.getRoundImage(imageView: cellImage!, radius: 15.0)
                     Common.setuiimageviewdborderwidth(imageView: cellImage!, borderwidth: 2.0)
            
                       var str = String()
                    if(Common.isNotNull(object: (dataarray.object(at: i) as! NSDictionary).value(forKey: "thumbs") as AnyObject)) {
                    let arra = ((dataarray.object(at: i) as! NSDictionary).value(forKey: "thumbs")) as! NSArray
                 
                    for i in 0..<arra.count
                    {
                        let dict = arra.object(at: i) as! NSDictionary
                        let name  = dict.value(forKey: "name") as! String
                        if(name == "rectangle")
                        {
                            
                            str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                         
                        }
                        else
                        {
                            
                        }
                    }
                    }
                    if(str == "")
                    {
                      cellImage?.image = #imageLiteral(resourceName: "Placehoder1")
                    }
                    else
                    {
                     cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder1"))
                    }
                    
                    
    
                    playbutton = UIButton(frame: CGRect(x: 5, y: (cellImage?.frame.maxY)!+10, width: 20, height: 20))
                    playbutton?.setImage(UIImage.init(named: "play"), for: .normal)
                    cellbannerimageview = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat((cellImage?.frame.maxY)!-30), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(30)))
                    Common.getRoundImage(imageView: cellbannerimageview!, radius: 13.0)
                    cellbannerimageview?.image = UIImage.init(named: "cellbottom")
                    genreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! - 20), width: CGFloat((cellImage?.frame.size.width)! - 60), height: CGFloat(20)))
                    
                    genreName?.textAlignment = .left
                     subgenreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! + (genreName?.frame.size.height)! + 5), width: CGFloat((cellImage?.frame.size.width)! - 30), height: CGFloat(10)))
                     genreName?.text = ((dataarray.object(at: i)  as! NSDictionary).value(forKey: "title") as? String)
               
                    
                
                    
                    genreName?.textColor = UIColor.white
                     genreName?.numberOfLines = 1
                    genreName?.font = UIFont(name: "Baloo", size: CGFloat(10))
                    subgenreName?.textColor = Discriptioncolor
                    subgenreName?.numberOfLines = 1
                    subgenreName?.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
                    
                    
                    videoviewlabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((subgenreName?.frame.origin.y)! + (subgenreName?.frame.size.height)! + 2), width: CGFloat((cellImage?.frame.size.width)! - 30), height: CGFloat(10)))
                    uploadtimelabel = UILabel(frame: CGRect(x: CGFloat((cellImage?.frame.size.width)! - 50), y:  CGFloat((cellImage?.frame.maxY)! - 20), width: CGFloat(50), height: CGFloat(20)))
                    uploadtimelabel?.font = UIFont(name: "Baloo", size: CGFloat(10))
                    videoviewlabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(8))
                    uploadtimelabel?.textColor = UIColor.white
                    videoviewlabel?.textColor = Discriptioncolor
                    uploadtimelabel?.textAlignment = .left
                    
                    
                 let videotime = ((dataarray.object(at: i)  as! NSDictionary).value(forKey: "duration") as? String)
                    uploadtimelabel?.text = Common.convertvideoduration(videotime: videotime!)
                    
                    Borderview = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat((cellImage?.frame.maxY)!)+10))
                    Common.setuiviewdborderwidth(View: Borderview!, borderwidth: 0.5)
                    
                    
                    cellView?.addSubview(cellImage!)
                     cellView?.addSubview(cellbannerimageview!)
                     cellView?.addSubview(genreName!)
                    cellView?.addSubview(subgenreName!)
                    cellView?.addSubview(dummyView!)
                    cellView?.addSubview(uploadtimelabel!)
                    cellView?.addSubview(videoviewlabel!)
                    //cellView?.addSubview(Borderview!)
                    cellView?.addSubview(button!)
                    
                    //cellView?.addSubview(playbutton!)
                    cell?.contentView.addSubview(homebutton!)
                    
                    
                }
            }
        
         return cell!
        
        }
            
        else if(collectionView == Channel_collectionview)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
            Common.getRoundImage(imageView: cell.bannerimaheview, radius: 15.0)
            Common.getRounduiview(view: cell.cellview, radius: 15.0)
            Common.getRoundImage(imageView: cell.cellbottomimageview, radius: 15.0)
            Common.setuiimageviewdborderwidth(imageView: cell.bannerimaheview!, borderwidth: 2.0)
            Common.getshadowofview(myView: cell.cellview!)


            if(Common.isNotNull(object: (self.collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
            {
            let url = (self.collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
            if(url.count>0)
            {
                
                
                var str = String()
                for i in 0..<url.count
                {
                    let dict = url.object(at: i) as! NSDictionary
                    let name  = dict.value(forKey: "name") as! String
                    if(name == "rectangle")
                    {
                        
                        str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                        
                    }
                    else
                    {
                        
                    }
                }
                
                if(str == "")
                {
                    cellImage?.image = #imageLiteral(resourceName: "Placehoder1")
                }
                else
                {
                    cell.bannerimaheview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder1"))
                }
                
              }
            else
            {
                cell.bannerimaheview.image = #imageLiteral(resourceName: "Placehoder")
            }
            }
            else
            {
             cell.bannerimaheview.image = #imageLiteral(resourceName: "Placehoder")
            }
            cell.titilelabel.text = (self.collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            let videotime = (self.collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
            
            
            
            cell.uploaddatelabel.text = Common.convertvideoduration(videotime: videotime!)
            return cell

        }
        
        else
        {
            
            let cellchnl: ChannelCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "cellchnl", for: indexPath) as? ChannelCollectionViewCell)
            cellchnl?.layer.borderWidth = 0.5
            
            
            cellchnl?.layer.borderColor = UIColor.white.cgColor
            cellchnl?.clipsToBounds = true
             cellchnl?.chaneelname.text =  "\((channelarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "first_name") as! String)\(" ")\((channelarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "last_name") as! String)"
             let str = "\(channeldatadict.value(forKey: "banner_page") as! String)\((channelarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "channel_pic") as! String)"
             cellchnl?.chenelimageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
            
            return cellchnl!
            
        }
            
        
        
        
        
    }
    
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if Ischannel {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ChanneldetailViewController") as! ChanneldetailViewController
            channeldetailViewController.chanldict = channelarray.object(at: indexPath.row) as! NSDictionary
            self.navigationController?.pushViewController(channeldetailViewController, animated: true)
            
        }
        else if(collectionView == Channel_collectionview)
        {
            print(collectionviewarray.object(at: indexPath.section))
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            if(Common.isNotNull(object: (collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
            {
            playerViewController.descriptiontext =  (collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            }
            if(Common.isNotNull(object: (collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as AnyObject?))
            {
            playerViewController.tilttext =   (collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            }
            playerViewController.fromdownload = "no"
            
            
            let catdataarray = (collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
            if(catdataarray.count == 0)
            {
                playerViewController.catid = (collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
            }
            else
            {
                
                var ids = String()
                for i in 0..<catdataarray.count
                {
                    
                    let str = ((collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                    ids = ids + str + ","
                    
                }
                ids = ids.substring(to: ids.index(before: ids.endIndex))
                playerViewController.catid = ids
            }
            
            
            playerViewController.cat_id = (collectionviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
             if(Common.Islogin())
            {
            
                
                self.navigationController?.pushViewController(playerViewController, animated: true)

                
//            if(Common.Isuserissubscribe(Userdetails: self as AnyObject))
//            {
//                self.navigationController?.pushViewController(playerViewController, animated: true)
//            }
//            else
//            {
//
//
//                let alert = UIAlertController(title: "", message: "Hi, User Current you are not subscribed user Please Subscribe and enjoy our greate video", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
//                     Common.PresentSubscription(Viewcontroller: self)
//                  }))
//                self.present(alert, animated: true, completion: nil)
//
//            }
                
            }
            else
            {
                Common.Showloginalert(view: self, text: "Please Login to watch Video")
            }
            
            
            
           // self.navigationController?.pushViewController(playerViewController, animated: true)
        }
        
        
            }

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        if(collectionView == Channel_collectionview)
        {
            return CGSize(width: view.frame.width/2-10, height: 100)
        }
     
            if(Ishomedata)
            {
                
               
                
                
                if indexPath.section == 1 {
                    let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(140))
                    return retval
                }
                else
                    
                {
                    
                    if((collectionviewarray.object(at: indexPath.section) as AnyObject).count == 0)
                    {
                        let retval = CGSize(width: CGFloat(0), height: CGFloat(3))
                        return retval
                    }
                    else
                    {
                    
                let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(130))
                return retval
                    }
                }
            }
        else
            {
                
                
                
                let stt = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "id") as! String)
                let dataarray = NSMutableArray()
                for i in 0..<collectionviewarray.count
                {
                    
                    if let _ = (collectionviewarray.object(at: i) as! NSDictionary).value(forKey: "category_ids")
                    {
                    let stt1 = ((((collectionviewarray.object(at: i) as! NSDictionary).value(forKey: "category_ids")) as! NSArray).object(at: 0) as! String)
                    
                    if(stt ==  stt1)
                    {
                        
                        dataarray.add(collectionviewarray.object(at: i))
                        
                    }
                    }
                }
                
                
                print(dataarray)
                
                
                if(dataarray.count == 0)
                {
                    let retval = CGSize(width: CGFloat(0), height: CGFloat(3))
                    return retval
                }
                else
                {
                
                let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(130))
                return retval
                }
        }
        
    }
    
    
    
 
    
    
    @IBAction func Taptosearch(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
         self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    
    func taptochannelheaderanother(sender: UIButton!)
    {
        print(Slidermenusegment_dict)
        print((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: (sender?.tag)!) as! NSDictionary)
        let dict = ["id":((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "partner_id") as! String] as NSDictionary
        print(dict)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ChanneldetailViewController") as! ChanneldetailViewController
        channeldetailViewController.chanldict = dict
        self.navigationController?.pushViewController(channeldetailViewController, animated: true)
        
    }
    
    
    func taptochannelpage(sender: UIButton!)
    {
        
        
        
    }
    
    
    
    
    func taptomore(sender: UIButton!)
    {
        
        if(Ishomedata)
        {
      
            
         if(((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_name") as! String) == "Characters")
         {
            let button = UIButton()
            self.taponzonar()
          //  self.TaptoZoner(button)
         }
            else if((((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_name") as! String) == "Continue Watching"))
         {
            return
         }
            else
         {
            
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        print(collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary)
        moreViewController.id = ((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_id") as! String)
        moreViewController.moreorzoner = "more"
        moreViewController.Isfromhome = true
        moreViewController.headertext = ((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_name") as! String)
            if(Common.isNotNull(object: (collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "thumb") as AnyObject?))
            {
        moreViewController.headerimageurl = ((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "thumb") as! String)
            }
        self.navigationController?.pushViewController(moreViewController, animated: true)
            }
        }
        else
        {
            print((sender?.tag)! as Int)
            print((morebutton?.tag)! as Int)
            print ((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            print((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary).value(forKey: "id") as! String))
            moreViewController.id = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary).value(forKey: "id") as! String)
            moreViewController.moreorzoner = "more"
            moreViewController.Isfromhome = true
            moreViewController.headertext = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary).value(forKey: "name") as! String)
            self.navigationController?.pushViewController(moreViewController, animated: true)
            
        }
        
 
        
    }
    
    
    func buttonAction(sender: UIButton!) {
      
        if(Ishomedata)
        {
         let point : CGPoint = sender.convert(CGPoint.zero, to:myCollectionView)
         var indexPath = myCollectionView!.indexPathForItem(at: point)
            print((indexPath?.section)! as Int)

                
                
          print((homebutton?.tag)! as Int)
          print((morebutton?.tag)! as Int)
          let ds = (indexPath?.section)! as Int
          print(ds)
            print(collectionviewarray.object(at:ds) as! NSDictionary)

          if(((collectionviewarray.object(at:ds) as! NSDictionary).value(forKey: "cat_name") as! String) == "Characters")
          {
            
            let dic = ((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at:ds) as AnyObject).object(at: sender.tag) as! NSDictionary
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
             moreViewController.id = (dic.value(forKey: "id") as! NSNumber).stringValue
            moreViewController.Isfromhome = false
            moreViewController.moreorzoner = "zoner"
            moreViewController.headertext =  dic.value(forKey: "genre_name") as! String
            self.navigationController?.pushViewController(moreViewController, animated: true)
            
            
          }
            else
          {
            
            
            print(((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at:ds) as AnyObject).object(at: sender.tag))
             let dic = ((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at:ds) as AnyObject).object(at: sender.tag) as! NSDictionary
                
           if((collectionviewarray.object(at: ds) as! NSDictionary).value(forKey: "cat_name") as! String == "Channel")
           {
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ChanneldetailViewController") as! ChanneldetailViewController
            channeldetailViewController.chanldict = dic
            self.navigationController?.pushViewController(channeldetailViewController, animated: true)
            
                }
                
                else
           {
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            playerViewController.Video_url = ""
            if(Common.isNotNull(object: dic.value(forKey: "des") as AnyObject?))
            {
                
                playerViewController.descriptiontext = dic.value(forKey: "des") as! String

            }
            else
            {
                playerViewController.descriptiontext = ""
  
            }
            playerViewController.liketext = ""
        
            playerViewController.fromdownload = "no"
            playerViewController.Download_dic = dic.mutableCopy() as! NSMutableDictionary
            playerViewController.downloadVideo_url = ""
            if(Common.isNotNull(object: dic.value(forKey: "title") as AnyObject?))
            {
            playerViewController.tilttext = dic.value(forKey: "title") as! String
            }
            if(Common.isNotNull(object: dic.value(forKey: "category_id") as AnyObject?))
            {
                playerViewController.catid = dic.value(forKey: "category_id") as! String
   
            }
            else
            {
                let catdataarray = dic.value(forKey: "category_ids") as! NSArray
                
          
              
                    
                    var ids = String()
                    for i in 0..<catdataarray.count
                    {
                        
                        let str = (dic.value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                        ids = ids + str + ","
                        
                    }
                    ids = ids.substring(to: ids.index(before: ids.endIndex))
               
                playerViewController.catid = ids

  
            }
            
              playerViewController.cat_id = dic.value(forKey: "id") as! String
            
            
            
            
            if(Common.Islogin())
            {
                
                
                self.navigationController?.pushViewController(playerViewController, animated: true)

                
//                if(Common.Isuserissubscribe(Userdetails: self as AnyObject))
//                {
//                    self.navigationController?.pushViewController(playerViewController, animated: true)
//                }
//                else
//                {
//
//
//                    let alert = UIAlertController(title: "", message: "Hi, User Current you are not subscribed user Please Subscribe and enjoy our greate video", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
//                        Common.PresentSubscription(Viewcontroller: self)
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//
//                  }
                
            }
            else
            {
                Common.Showloginalert(view: self, text: "Please Login to watch Video")
            }
            

            
            
           //   self.navigationController?.pushViewController(playerViewController, animated: true)
     
            }
            }
        }
        else
        {
            let headerView: UIView = sender.superview!
            print(headerView.subviews)
            let label = headerView.subviews[2] as! UILabel
            let str = label.text
            
            for i in 0..<(collectionviewarray.count)
            {
                
                let dictnew  = collectionviewarray.object(at: i) as! NSDictionary
                let titlenew  = dictnew.value(forKey: "title") as! String
                if(str == titlenew)
                {
                 
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
                    
                    if(Common.isNotNull(object: dictnew.value(forKey: "des") as AnyObject?))
                    {
                     playerViewController.descriptiontext = dictnew.value(forKey: "des") as! String
                    }
                    else
                    {
                        playerViewController.descriptiontext = ""
                    }
                    if(Common.isNotNull(object: dictnew.value(forKey: "title") as AnyObject?))
                    {
                     playerViewController.tilttext = dictnew.value(forKey: "title") as! String
                    }
                    playerViewController.cat_id = dictnew.value(forKey: "id") as! String
                     playerViewController.fromdownload = "no"
                   playerViewController.downloadVideo_url = ""
                    var ids = String()
                    for i in 0..<(dictnew.value(forKey: "category_ids") as! NSArray).count
                    {
                        
                        
                        let str = (dictnew.value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                        ids = ids + str + ","
                        
                    }
                    ids = ids.substring(to: ids.index(before: ids.endIndex))
                    playerViewController.catid = ids
                    
                    
                    
                    if(Common.Islogin())
                    {
                        
                        self.navigationController?.pushViewController(playerViewController, animated: true)
                        return

                        
                        
//                        if(Common.Isuserissubscribe(Userdetails: self as AnyObject))
//                        {
//                            self.navigationController?.pushViewController(playerViewController, animated: true)
//                        }
//                        else
//                        {
//
//
//                            let alert = UIAlertController(title: "", message: "Hi, User Current you are not subscribed user Please Subscribe and enjoy our greate video", preferredStyle: UIAlertControllerStyle.alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
//                                Common.PresentSubscription(Viewcontroller: self)
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//
//                        }
//
                        
                        
                    }
                    else
                    {
                        Common.Showloginalert(view: self, text: "Please Login to watch Video")
                    }
                    
                    
                  //  self.navigationController?.pushViewController(playerViewController, animated: true)
                    
                    
                }
        }
        
        
    }
    
    }
    
    //MARK:- Init Slider menu
    func setmenu()
    {
        mXSegmentedPager = MXSegmentedPager.init(frame: CGRect.init(x: 0, y: 65, width: self.view.frame.size.width, height: 41))
        mXSegmentedPager.segmentedControl.selectionIndicatorLocation = .down
        
         // nextbutton.addTarget(self, action: , for: .touchUpInside)
        // mXSegmentedPager.segmentedControl.backgroundColor = UIColor.init(colorLiteralRed: 61.0/255, green: 61.0/255, blue: 61.0/255, alpha: 1.0)
        mXSegmentedPager.segmentedControl.backgroundColor = UIColor.init(colorLiteralRed: 247.0/255, green: 230.0/255, blue: 70.0/255, alpha: 1.0)
        mXSegmentedPager.segmentedControl.selectionIndicatorColor = UIColor.init(colorLiteralRed: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)
        
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(colorLiteralRed: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)]
        mXSegmentedPager.segmentedControl.segmentWidthStyle = .fixed
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0), NSFontAttributeName: UIFont.init(name: "Baloo", size: 14.0) as Any]
        // mXSegmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(colorLiteralRed: 227.0/255, green: 92.0/255, blue: 10.0/255, alpha: 1.0)]
        
        mXSegmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(colorLiteralRed: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0)]
        //mXSegmentedPager.segmentedControlPosition = .bottom
        mXSegmentedPager.dataSource = self
        mXSegmentedPager.delegate = self
        self.view.addSubview(mXSegmentedPager)
       
        
    }
    
    
    func taptosetnextsegment(sender:UIButton)
    {
        
        
        
        if(sender.imageView?.image == #imageLiteral(resourceName: "segmentforwaord"))
        {
            mXSegmentedPager.pager.showPage(at: mXSegmentedPager.segmentedControl.selectedSegmentIndex+1, animated: true)
        }
        else
        {
            mXSegmentedPager.pager.showPage(at: mXSegmentedPager.segmentedControl.selectedSegmentIndex-1, animated: true)
        }
        
        if(mXSegmentedPager.segmentedControl.selectedSegmentIndex==0)
        {
            sender.setImage(#imageLiteral(resourceName: "segmentforwaord"), for: .normal)
        }
            
        else if(mXSegmentedPager.segmentedControl.selectedSegmentIndex == slidermenuarray.count-1)
        {
            sender.setImage(#imageLiteral(resourceName: "segmentbackwaord"), for: .normal)
        }
        
        
        
        
        
        
    }
    
  
    
    //MARK:-   Slidermenu delegate method
    
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return slidermenuarray.count
    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        
        return slidermenuarray.object(at: index) as! String
        
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        let label = UILabel()
        //label.text! = "Page #\(index)"
        // label.textAlignment = .Center
        //label.text = "Ashish"
        return label
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, willDisplayPage page: UIView, at index: Int) {
          print("ENd")
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("ENd")

    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didEndDisplayingPage page: UIView, at index: Int) {
       print("ENd")
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didEndDraggingWith parallaxHeader: MXParallaxHeader) {
        print("ENd")

    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int) {
  
         if(index == 0)
        {
            Homeview.isHidden = false
            Channel_view.isHidden = true
            morebutton?.removeFromSuperview()
            morebutton1?.removeFromSuperview()
             Ishomedata = true
            if(self.HomeData_dict.count>0)
            {
                
                
                self.getdatabaseresponse()

            }
            else
            {
                
                Common.startloder(view: self.view)
                self.callhomedatawebapi()
            }

            
            
         }
            
  
        else
        {
 
            
            let catname = slidermenuarray.object(at: index) as! String
            var newindex = Int()
            for i in 0..<(((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).count)
            {
                let catarrayname = (((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "name") as! String
                if(catname == catarrayname)
                {
                    newindex = i
                }
                
                
            }
              let index = newindex+1
       
            
            Ishomedata = false
            print(((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary)
            var ids = String()
            if((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "name") as! String == "RHYMES")
            {
                ids = (((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "id") as! String
            }
            else
            {
                
            if((((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "children") as! NSArray).count) > 0)
            {
            for i in 0..<(((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "children") as! NSArray).count)
            {
                let dict = ((((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).value(forKey: "children") as! NSArray).object(at: i) as! NSDictionary
                let str = dict.value(forKey: "id") as! String
                ids = ids + str + ","
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            }
                else
            {
                
                
            let dict = ((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary
            let str = dict.value(forKey: "id") as! String
            ids =  str
                }
            }
            print(ids)
            Slidermenusegment_dict = (((self.Slidermenulist_dict.value(forKey: "cat") as! NSDictionary).value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            print(Slidermenusegment_dict)
            print(self.Catdata_dict)
            print(dataBase.getcatlistdatabase(entityname: "Catlistdata", id: ids, key: "catlistdatadict"))
            self.Catdata_dict = dataBase.getcatlistdatabase(entityname: "Catlistdata", id: ids, key: "catlistdatadict")
            if(self.Catdata_dict.count>0)
            {
                print(self.Catdata_dict)
                self.collectionviewarray = NSMutableArray()
                self.featurebanner = NSArray()
                if(Common.isNotNull(object: self.Catdata_dict.value(forKey: "feature") as AnyObject))
                {
                self.featurebanner = (self.Catdata_dict.value(forKey: "feature") as! NSArray)
                }
                else
                {
                   self.featurebanner = NSArray()
                }
                self.collectionviewarray = (self.Catdata_dict.value(forKey: "content") as! NSArray).mutableCopy() as! NSMutableArray
                print(self.collectionviewarray)
               
                if(Slidermenusegment_dict.value(forKey: "name") as! String == "RHYMES")
                {
                  //  myscrollview.setContentOffset(CGPoint.zero, animated: true)
                    self.setimageincarouseview1()
                     self.Homeview.isHidden = true
                    self.Channel_view.isHidden = false
                    self.OtherView.isHidden = true
                    self.Channel_collectionview.reloadData()


                }
                else
                {
                    
                 //   myscrollview.setContentOffset(CGPoint.zero, animated: true)
                     self.setimageincarouseview()
                     Homeview.isHidden = false
                    Channel_view.isHidden = true
                    morebutton?.removeFromSuperview()
                    morebutton1?.removeFromSuperview()
                     self.myCollectionView.reloadData()
                  }
                
 
                
                
                
                if(Slidermenusegment_dict.value(forKey: "name") as! String == "RHYMES") {
                    
                    self.Channel_view.frame.origin.y = 0.0
                    self.Homeview.frame.origin.y = 0.0
                    self.OtherView.frame.origin.y = 0.0
                    let collectionheight = (self.collectionviewarray.count/2)*75
                    srollviewviewhgtconstrant.constant = CGFloat(collectionheight)
                    //myscrollview.setContentOffset(CGPoint.zero, animated: true)
                    let point = CGPoint(x: 0, y: 0)
                    myscrollview.contentOffset = point
 


                }
                else
                {
                    self.Channel_view.frame.origin.y = 0.0
                    self.Homeview.frame.origin.y = 0.0
                    self.OtherView.frame.origin.y = 0.0
                    let countarry = Slidermenusegment_dict.value(forKey: "children") as! NSArray
                    print(countarry.count)
                    var collectionheight = 0
                    if(countarry.count<=3)
                    {
                        collectionheight = countarry.count*50
                    }
                    else if(countarry.count>3 || countarry.count>5)
                    {
                        collectionheight = countarry.count*80
                     }
                    else if(countarry.count>5 || countarry.count>7)
                    {
                        collectionheight = countarry.count*90
                     }
                    else
                    {
                        collectionheight = countarry.count*100
                     }
                    
                    
        
                    
                    srollviewviewhgtconstrant.constant = CGFloat(collectionheight)
                   // myscrollview.setContentOffset(CGPoint.zero, animated: true)
                    let point = CGPoint(x: 0, y: 0)
                    myscrollview.contentOffset = point
 

                }
               
                
                
                
            }
            else
            {
                
                if(Slidermenusegment_dict.value(forKey: "name") as! String == "RHYMES")
                {
                    self.Getcatlistdata(id: ids, index: 4)
                }
                else
                {
                    self.Getcatlistdata(id: ids, index: 1)
                }
                Common.startloder(view: self.view)
            }

          
 
           
            
        }
  
        
        
     
      //  srollviewviewhgtconstrant.constant = myCollectionView.collectionViewLayout.collectionViewContentSize.height-250
      //  myscrollview.setContentOffset(CGPoint.zero, animated: true)
       // myscrollview.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: myscrollview.frame.size.width, height: myscrollview.frame.size.height), animated: true)
    
    
    }
    
    
    
   //MARK:- Get channel
    
    func Getchannel()
    {
        
         var parameters = [String : Any]()
        
        parameters = [ "user_id":"",
                       "device":"ios",
        ]
        
        
        var url = String(format: "%@%@/device/ios", LoginCredentials.Channellistapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
 
                let dict = responseObject as! NSDictionary
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                }
                else
                {
                    var chaneeldata_dict = NSMutableDictionary()
                    if(LoginCredentials.IsencriptListapi)
                    {
                        chaneeldata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
                    else
                    {
                        chaneeldata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                        
                    }
                dataBase.SaveChanneldata(data: chaneeldata_dict)
                }
             //   self.channeldatadict = NSMutableDictionary()
              //     self.channeldatadict = chaneeldata_dict
             //    self.channelarray = chaneeldata_dict.value(forKey: "channels") as! NSArray
                
                
                
            
            
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
        
        
    }

    
    
    
    //MARK:- SetUp CarouselView
    
    
    func setimageincarouseview()
    {
        let arry = NSMutableArray()
        let arry1 = NSMutableArray()
        let arry2 = NSMutableArray()
        let arry3 = NSMutableArray()
        print(featurebanner)
        if(featurebanner.count == 0)
        {
            corasalhightcnstrant.constant = 0.0
        }
        else
        {
          corasalhightcnstrant.constant = 180.0
        }
        for i in 0..<featurebanner.count
        {
            
            var url = URL(string: "")
            //let url = URL(string: (((((featurebanner.object(at: i) as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium")) as! String)
          
            let array = (featurebanner.object(at: i) as! NSDictionary).value(forKey: "thumbs") as! NSArray
            if(array.count > 0)
            {
                
            }
            else
            {
               url =  URL(string: "")
            }
            for i in 0..<array.count
            {
                let dict = array.object(at: i) as! NSDictionary
                if(dict.value(forKey: "name") as! String == "rectangle")
                {
                    if((dict.value(forKey: "thumb") as! NSDictionary).count > 0)
                    {
                        let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                         url =  URL(string: str)
                    }
                }
                
            }
            
            
            
            var text1 = String()
            var text2 = String()
            var text3 = String()
            
            if(Common.isNotNull(object: (featurebanner.object(at: i) as! NSDictionary).value(forKey: "type")  as AnyObject?))
            {
              let type = (featurebanner.object(at: i) as! NSDictionary).value(forKey: "type") as! String
              if(type == "series")
              {
                
                
                if(Common.isNotNull(object: ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "series_type")  as AnyObject?)))
                {
                    text1 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "series_type")   as! String)
                }
                
                if(Common.isNotNull(object: ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "category")  as AnyObject?)))
                {
                    text2 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "category")   as! String)
                }
                
                if(Common.isNotNull(object: ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "episode_number")  as AnyObject?)))
                {
                    text3 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "episode_number")   as! String)
                }
                else
                {
                    text3 = "0"
                }
             
                
              }
                else
              {
                
                 text1 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
                 text2 = ""
                }
                
                
            }
            else
            {
                
                text1 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
                text2 = ""
            }
            
            
           // let text = "\(text1)\("\n")\(text2)"
            
            //let text = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
            arry.add(url)
            arry1.add(text1)
            arry2.add(text2)
            arry3.add(text3)
            
            
            
        }
        //imageCarouselView.textarray = NSMutableArray()
        // imageCarouselView.imageurlarry = NSMutableArray()
        imageCarouselView.imageurlarry.removeAllObjects()
        imageCarouselView.textarray.removeAllObjects()
        imageCarouselView.imageurlarry = arry
        imageCarouselView.textarray = arry1
        imageCarouselView.textarraydes = arry2
        imageCarouselView.episodearray = arry3
       
        
    }
    
    
    func setimageincarouseview1()
    {
        let arry = NSMutableArray()
        let arry1 = NSMutableArray()
        let arry2 = NSMutableArray()
        let arry3 = NSMutableArray()
        print(featurebanner)
        if(featurebanner.count == 0)
        {
            corasalhightcnstrant1.constant = 0.0
        }
        else
        {
            corasalhightcnstrant1.constant = 180.0
        }
        for i in 0..<featurebanner.count
        {
            
            var url = URL(string: "")
            //let url = URL(string: (((((featurebanner.object(at: i) as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium")) as! String)
            
            let array = (featurebanner.object(at: i) as! NSDictionary).value(forKey: "thumbs") as! NSArray
            if(array.count > 0)
            {
                
            }
            else
            {
                url =  URL(string: "")
            }
            for i in 0..<array.count
            {
                let dict = array.object(at: i) as! NSDictionary
                if(dict.value(forKey: "name") as! String == "rectangle")
                {
                    if((dict.value(forKey: "thumb") as! NSDictionary).count > 0)
                    {
                        let str = (dict.value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                        url =  URL(string: str)
                    }
                }
                
            }
            
            
            
            var text1 = String()
            var text2 = String()
            var text3 = String()
            
            if(Common.isNotNull(object: (featurebanner.object(at: i) as! NSDictionary).value(forKey: "type")  as AnyObject?))
            {
                let type = (featurebanner.object(at: i) as! NSDictionary).value(forKey: "type") as! String
                if(type == "series")
                {
                    
                    
                    if(Common.isNotNull(object: ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "series_type")  as AnyObject?)))
                    {
                        text1 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "series_type")   as! String)
                    }
                    
                    if(Common.isNotNull(object: ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "category")  as AnyObject?)))
                    {
                        text2 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "category")   as! String)
                    }
                    
                    if(Common.isNotNull(object: ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "episode_number")  as AnyObject?)))
                    {
                        text3 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "episode_number")   as! String)
                    }
                    else
                    {
                        text3 = "0"
                    }
                    
                    
                }
                else
                {
                    
                    text1 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
                    text2 = ""
                }
                
                
            }
            else
            {
                
                text1 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
                text2 = ""
            }
            
            
            // let text = "\(text1)\("\n")\(text2)"
            
            //let text = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
            arry.add(url)
            arry1.add(text1)
            arry2.add(text2)
            arry3.add(text3)
        }
        //imageCarouselView.textarray = NSMutableArray()
        // imageCarouselView.imageurlarry = NSMutableArray()
        imagecarouselview1.imageurlarry.removeAllObjects()
        imagecarouselview1.textarray.removeAllObjects()
        imagecarouselview1.imageurlarry = arry
        imagecarouselview1.textarray = arry1
        imagecarouselview1.textarraydes = arry2
        imagecarouselview1.episodearray = arry3
        imagecarouselview1.showPageControl = true
        
        
    }
    
    
    
    
    //MARK:- coresal view delegate
    func scrolledToPage(_ page: Int)
    {
        
    }
    
    func clickonpage(_ page: Int)
    {
      print(page)
    }
    func clickcoresal(notification:NSNotification)
    {
        print(featurebanner)
       let index = notification.object as! Int
        
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.Video_url = ""
        if(Common.isNotNull(object: (featurebanner.object(at: index) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
        playerViewController.descriptiontext = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "des") as! String
        }
     
        playerViewController.liketext =  ""
       if(Common.isNotNull(object: (featurebanner.object(at: index) as! NSDictionary).value(forKey: "title") as AnyObject?))
       {
        playerViewController.tilttext = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "title") as! String
        }
        playerViewController.Download_dic = (featurebanner.object(at: index) as! NSDictionary).mutableCopy() as! NSMutableDictionary
           playerViewController.fromdownload = "no"
          playerViewController.downloadVideo_url = ""
            
            
        var ids = String()
        for i in 0..<((featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
        {
              let str = ((featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
            ids = ids + str + ","
            
        }
        ids = ids.substring(to: ids.index(before: ids.endIndex))
        playerViewController.catid = ids
        playerViewController.cat_id = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "id") as! String
        
        
        
        if(Common.Islogin())
        {
        
            
            self.navigationController?.pushViewController(playerViewController, animated: true)

            
            
//            if(Common.Isuserissubscribe(Userdetails: self as AnyObject))
//            {
//                self.navigationController?.pushViewController(playerViewController, animated: true)
//            }
//            else
//            {
//                
//                
//                let alert = UIAlertController(title: "", message: "Hi, User Current you are not subscribed user Please Subscribe and enjoy our greate video", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
//                    Common.PresentSubscription(Viewcontroller: self)
//                }))
//                self.present(alert, animated: true, completion: nil)
//                
//                
//                
//            }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please Login to watch Video")
        }
        

       //   self.navigationController?.pushViewController(playerViewController, animated: true)
        
       
        
    }
    
    
    
    
    
    //MARK:- Covert datetime
    func compatedate(date:String) ->String {
        print(date)
        
        var uploadtime = String()
        let dateFormatter = DateFormatter()
        let userCalendar = NSCalendar.current
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTime = NSDate()
        let endTime = dateFormatter.date(from: date)
        
        let timeDifference = userCalendar.dateComponents(dayHourMinuteSecond, from: endTime!, to: startTime as Date)
        
        print("\(timeDifference.month) Months \(timeDifference.day) Days \(timeDifference.hour) Hours \(timeDifference.minute) Minutes ago")
        
        if(Common.isNotNull(object: timeDifference.month as AnyObject?))
        {
            uploadtime =  "\(timeDifference.month!.toString())\(" Month ago")"
            return uploadtime
        }
            
        else
        {
            
            
            if(timeDifference.day != 0)
            {
                
                uploadtime =  "\(timeDifference.day!.toString())\(" Days ago")"
                return uploadtime
                
            }
                
            else if(timeDifference.hour != 0)
            {
                
                uploadtime =  "\(timeDifference.hour!.toString())\(" Hours ago")"
                return uploadtime
            }
            else if(timeDifference.minute != 0)
            {
                
                uploadtime =  "\(timeDifference.minute!.toString())\(" Minut ago")"
                return uploadtime
            }
            
            
            
        }
        
        return uploadtime
        // dateLabelOutlet.text = "\(timeDifference.month) Months \(timeDifference.day) Days \(timeDifference.minute) Minutes \(timeDifference.second) Seconds"
    }
    
    
      //MARK:- Menu button Action
    @IBAction func Taptomenu(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    //MARK:- didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
       
         AppUtility.lockOrientation(.portrait)
        self.perform(#selector(changeOrientation), with: nil, afterDelay: 5.0)
    }
    func changeOrientation()
    {
        AppUtility.lockOrientation(.portrait)
    }
}
//MARK:- SlideMenuControllerDelegate Action delegate
extension ViewController : SlideMenuControllerDelegate {
    
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
