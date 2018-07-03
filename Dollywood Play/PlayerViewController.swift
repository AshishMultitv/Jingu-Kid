//
//  PlayerViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 23/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import MXSegmentedPager
import AFNetworking
import AVKit
import AVFoundation
import M3U8Kit2
import Photos
import PhotosUI
import SwiftMessages
import Fuzi
import SAVASTParser
import SAJsonParser
import SAVideoPlayer
import SANetworking
import SAUtils
import SAModelSpace
import CoreTelephony
import AARatingBar
import FormToolbar
import Pantomime
import Kingfisher

class PlayerViewController: UIViewController,MXSegmentedPagerDataSource,MXSegmentedPagerDelegate,UIActionSheetDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITextViewDelegate {
    
    @IBOutlet var scrollviewheighltcontrant: NSLayoutConstraint!
    @IBOutlet weak var myscroll: UIScrollView!
    @IBOutlet weak var myscroolview: UIView!
    @IBOutlet weak var titlenamelabel: UILabel!
    @IBOutlet weak var likelabel: UILabel!
    @IBOutlet var dislikelabel: UILabel!
    
    @IBOutlet var favrioutlabel: UILabel!
    @IBOutlet var expenddownarroe: UIButton!
    @IBOutlet weak var contantdiscriptionlabel: UILabel!
    @IBOutlet weak var expandbutton: UIButton!
    @IBOutlet weak var downloadbutton: UIButton!
    @IBOutlet var favroutbutton: UIButton!
    
    @IBOutlet weak var likebutton: UIButton!
    @IBOutlet var dislikebutton: UIButton!
    @IBOutlet weak var sharebutton: UIButton!
    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var Resolutionbutton: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var soundbutton: UIButton!
    @IBOutlet weak var forwardbutton: UIButton!
    @IBOutlet weak var backwordbutton: UIButton!
    @IBOutlet weak var backwordbuttonuppercnstraint: NSLayoutConstraint!
    @IBOutlet weak var discriptionlabeheightcontraint: NSLayoutConstraint!
    @IBOutlet var downloadprogressimghgtcnsrnt: NSLayoutConstraint!
    @IBOutlet var dwnldprgswdthconstrant: NSLayoutConstraint!
    @IBOutlet weak var Bottomviewuppercnstraint: NSLayoutConstraint!
    @IBOutlet var totalviewlabel: UILabel!
    @IBOutlet var notificationbutton: UIButton!
    @IBOutlet var Mycollectionview: UICollectionView!
    
    
    
    var Video_url = String()
    var tilttext = String()
    var liketext = String()
    var descriptiontext = String()
    var cat_id = String()
    var isfav = Bool()
    var catid = String()
    var cat_idarray = NSArray()
    var likeornot = String()
    var favornot = String()
    var mXSegmentedPager = MXSegmentedPager()
    var downloadVideo_url = String()
    var shareurlnew = String()
    var fromdownload = String()
    var Download_dic:NSMutableDictionary=NSMutableDictionary()
    var Channeldict:NSDictionary=NSDictionary()


    var singletap = UITapGestureRecognizer()
    var videoPlayer:AVPlayer!
    var lblEnd:UILabel = UILabel()
    var avLayer:AVPlayerLayer!
    var timer:Timer!
    var bEnlarge:Bool = Bool()
    var playbackSlider:UISlider!
    var soundbackSlider:UISlider!
    var lblLeft:UILabel = UILabel()
    var tempView:UIView!
    var soundcontrolbutton:UIButton = UIButton()
    var expandBtn:UIButton = UIButton()
    var Skipbutton:UIButton = UIButton()
    var bFirstTime:Bool = Bool()
    var enlargeBtn:UIButton = UIButton()
    var enlargeBtnLayer:UIButton = UIButton()
    var activityIndicator:UIActivityIndicatorView=UIActivityIndicatorView()
    var bPlay:Bool = Bool()
    var bHideControl:Bool = Bool()
    var bSlideBar:Bool = Bool()
    var isshowmore:Bool = Bool()
    var IsplayMaster:Bool = Bool()
    var Islangaugechange:Bool = Bool()
     var moredataarray = NSArray()
    var recomdentdedataarray = NSArray()
    var ismore:Bool = Bool()
    var islike:Bool = Bool()
    var isdislike:Bool = Bool()
    var videoresoulationtypearray:NSMutableArray=NSMutableArray()
    var videoresoulationurlarray:NSMutableArray=NSMutableArray()
    var soundactionSheet = UIActionSheet()
    var soundaarray = [String]()
    var selectsoundindex = Int()
    
    var vertitualselectsoundindex:Int = 0
    var vertitualselectresolutionindex:Int = 0

    
    
    var midrolequepointarray = NSArray()
     var midroleurl = String()
    var toolbar = FormToolbar()

    
    
    @IBOutlet var channelview: UIView!
     @IBOutlet var progressdownloadimageview: UIImageView!
     @IBOutlet var ratingview: UIView!
    @IBOutlet var inratingview: UIView!
    @IBOutlet var cancelratingbutton: UIButton!
    @IBOutlet var submitratingbutton: UIButton!
    @IBOutlet var showratingbar: AARatingBar!
    @IBOutlet var submitratingbar: AARatingBar!
    
 
    
    
    
    
    ////Download Video File////////
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
  ////sav parser
    
    var Event_dict:NSDictionary=NSDictionary()
    var isplayadd:Bool = Bool()
    var skiptimer = Timer()
    var skiptime:Int = 0
    var vastarray = NSArray()
    var ismidrolepresent:Bool = Bool()
    var isprerole:Bool = Bool()
    var midroletime = Float()
    var totalvideoDurationtime = Float()
    var likecount = Int()
     var favcount = Int()
    var dislikecount = Int()

    var channeldetaildict = NSMutableDictionary()
    var ischnlsucribe:Bool = Bool()
    var ischnlnotificationsubcribed:Bool = Bool()

    var chnl_id = String()
    var isviewwillappear:Bool = Bool()
    
    var Playeraddtime:Timer!
    var toast = JYToast()
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
         
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(stopdownloadprogress), name: NSNotification.Name(rawValue: "CancelDownloading"), object: nil)
         let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioRouteChangeListener), name: .AVAudioSessionRouteChange, object: nil)
        self.setmenu()
        self.getplayerurl()
         LoginCredentials.ischaneelviewappear = true
        LoginCredentials.Videoid = cat_id
        myscroll.delegate = self
        self.Mycollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        ///new comment secttion
         // Do any additional setup after loading the view.
    }
    
  
    func willResignActive(_ notification: Notification) {
 
            if(self.videoPlayer == nil)
            {
                
            }
            else
            {
                self.expandBtn.isHidden = true
                self.isplayorpause()
            }
        
        // code to execute
    }
    
    
    
    func audioRouteChangeListener(notification: Notification) {
        
       
            
            guard let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as? Int else { return }
            
            switch audioRouteChangeReason {
                
            case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.hashValue:
                //plugged out
                
                if(self.videoPlayer == nil)
                {
                    
                }
                else
                {
                   self.expandBtn.isHidden = true
                    self.isplayorpause()
                   // self.videoPlayer.play()
                    
                }
                break
                
            default:
                break
                
            }
         
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        if(LoginCredentials.ischaneelviewappear)
        {
        isshowmore = false
        AppUtility.lockOrientation([.portrait,.landscapeRight,.landscapeLeft])
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
     
        ismore = true
          if(!Common.isInternetAvailable())
          {
           
            self.setvideodata(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
            self.setvideodescription(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
            
        }
        else
          {
           self.setvideodescription(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
        }
        }
        else
        {
            
            LoginCredentials.ischaneelviewappear = true
        }
        
        
    }
    
  

    
    
    

    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        print(newFrame.height)
    

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write Comment" {
            textView.text = ""
         
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Comment"
            
        }
    }
    
    
    
    @IBAction func Taptohiddenratingview(_ sender: UIButton) {
        self.view.endEditing(true)
          ratingview.isHidden = true
    }
  
    @IBAction func TaptoRaingbutton(_ sender: UIButton) {
        
      self.intialalertview()
    }
    
    @IBAction func TaptoChannelview(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ChanneldetailViewController") as! ChanneldetailViewController
         LoginCredentials.ischaneelviewappear = false
        channeldetailViewController.chanldict =  Channeldict
        self.navigationController?.pushViewController(channeldetailViewController, animated: true)
        
    }
    @IBAction func Taptosubmitratingview(_ sender: UIButton) {
        
         ratingview.isHidden = true
         self.Submitrating()
        
    }
    @IBAction func Taptocancelratingview(_ sender: UIButton) {
        
        
        ratingview.isHidden = true
        
        
    }
    
    
    func Submitrating()
    {
         if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            
            var parameters = [String : Any]()
            parameters = [ "content_id":cat_id,
                           "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                           "device":"ios",
                           "rating": self.submitratingbar.value,
                           "type": "video"
            ]
            
            var url = String(format: "%@%@", LoginCredentials.Ratingapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)

            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    
                    
                     if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                    {
                        EZAlertController.alert(title: "Error!")
                    }
                    else
                    {
                    self.showratingbar.setvalue = CGFloat((dict.value(forKey: "result") as! NSString).floatValue)
                          EZAlertController.alert(title: "Thanks for rating")
                        
                        
                     }
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please Login to add a comment")

         }
    }
    

    
    

   
    
    @IBAction func Taptoenablenotification(_ sender: UIButton) {
 
        if(Common.Islogin())
        {
            Common.startloderonplayer(view: self.view)
            UIApplication.shared.endIgnoringInteractionEvents();
            var parameters = [String : Any]()
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
    
            var url = String()
            if(ischnlnotificationsubcribed)
            {
                parameters = [ "customer_id":dict.value(forKey: "id") as! String,
                               "channel_id":chnl_id,
                               "donot_notify":"0"
                ]
                url = String(format: "%@/channel/subscribe/token/%@", LoginCredentials.Userbehaviorapi,Apptoken)
                
            }
            else
            {
                parameters = [ "customer_id":dict.value(forKey: "id") as! String,
                               "channel_id":chnl_id,
                               "donot_notify":"1"
                ]
                url = String(format: "%@/channel/unsubscribe/token/%@", LoginCredentials.Userbehaviorapi,Apptoken)
                
            }
            url = url.trimmingCharacters(in: .whitespaces)

            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    
                    Common.stoploderonplayer(view: self.view)
                    if(self.ischnlnotificationsubcribed)
                    {
                        self.ischnlnotificationsubcribed = false
                        self.notificationbutton.setImage(UIImage.init(named: "notificationenable"), for: .normal)
                        
                    }
                    else
                    {
                        self.ischnlnotificationsubcribed = true
                        self.notificationbutton.setImage(UIImage.init(named: "notificationdisable"), for: .normal)
                        
                        
                    }
                    
                    
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
            
            
        }
        else
        {
           
            Common.Showloginalert(view: self, text: "Please login to acess this sction")

           
        }
        

        
        
        
    }
    
    
    @IBAction func Taptoplayermenu(_ sender: UIButton) {
        
        if(Common.Islogin())
        {
        let optionMenuController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        // Create UIAlertAction for UIAlertController
        
        let addAction = UIAlertAction(title: "Add Rating", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File has been Add")
            self.intialalertview()
        })
        let saveAction = UIAlertAction(title: "Report", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            EZAlertController.alert(title: "Content Reporting")
        })
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // Add UIAlertAction in UIAlertController
        
        optionMenuController.addAction(addAction)
      //  optionMenuController.addAction(saveAction)
        optionMenuController.addAction(cancelAction)
        
        // Present UIAlertController with Action Sheet
        
        self.present(optionMenuController, animated: true, completion: nil)
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to acess this sction")

         }
    }
    
    
    
    func intialalertview()
    {
 
    if(Common.Islogin())
    {
        Common.setuiviewdborderwidth(View: inratingview, borderwidth: 1.0)
        Common.getRounduiview(view: inratingview, radius: 1.0)
        ratingview.isHidden = false
        self.view.bringSubview(toFront: self.ratingview)
        }
        else
    {
         Common.Showloginalert(view: self, text: "Please login to acess this sction")
        }

        

    }
    
    
   func getplayerurl()
   {
    
 
    if((self.descriptiontext == "") || !(Common.isNotNull(object: self.descriptiontext as AnyObject?)))
    {
        self.discriptionlabeheightcontraint.constant = 0.0
         expenddownarroe.isHidden = true
        
    }
    else
    {
        expenddownarroe.isHidden = false
        
    }
    
    
    
    
    IsplayMaster = true
    Islangaugechange = false
    
    Common.startloderonplayer(view: self.view)
    UIApplication.shared.endIgnoringInteractionEvents();
    LoginCredentials.Addtime = 0
    LoginCredentials.VideoPlayingtime = 0
    var parameters = [String : Any]()
    let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
    
    var url = String()


    if(Common.Islogin())
    {
     parameters = [ "content_id":cat_id,
                   "device":"ios",
                   "owner_info":"1",
                   "user_id": (dict.value(forKey: "id") as! NSNumber).stringValue
                  ]
        
       // url = String(format: "%@%@/content_id/%@/device/ios/owner_info/1/user_id/%@", LoginCredentials.Detailapi,Apptoken,cat_id,(dict.value(forKey: "id") as! NSNumber).stringValue)
         url = String(format: "%@%@/device/ios/content_id/%@/user_id/%@", LoginCredentials.Detailapi,Apptoken,cat_id,(dict.value(forKey: "id") as! NSNumber).stringValue)
    }
    else
    {
        parameters = [ "content_id":cat_id,
                       "device":"ios",
                       "owner_info":"1",
                       "user_id": ""]
        
          //  url = String(format: "%@%@/content_id/%@/device/ios/owner_info/1/user_id", LoginCredentials.Detailapi,Apptoken,cat_id)
        
        
          url = String(format: "%@%@/device/ios/content_id/%@", LoginCredentials.Detailapi,Apptoken,cat_id)
        
        
    }
    url = url.trimmingCharacters(in: .whitespaces)

    print(parameters)
     let manager = AFHTTPSessionManager()
    manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
        if (responseObject as? [String: AnyObject]) != nil {
            
            Common.stoploderonplayer(view: self.view)
             let dict = responseObject as! NSDictionary
            if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
            {
                self.showbackerroalert()
                return
            }
  
            // self.CallplayerUsersesion()
          //  self.getcntantuserbehavior()
            let detaildict = dict.value(forKey: "result") as! NSDictionary
            print(detaildict)
            
            
            self.checkcontantbehaviour(dict: detaildict)
           self.Download_dic = (detaildict.value(forKey: "content") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            self.likelabel.text = "\((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "likes_count") as! String)"
            self.favrioutlabel.text = "\((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "favorite_count") as! String)"
            
            self.totalviewlabel.text = "\((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "watch") as! String)\(" views")"
           self.likecount = Int((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "likes_count") as! String)!
            self.favcount = Int((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "favorite_count") as! String)!
            self.dislikecount = Int((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "dislike_count") as! String)!
            
            
            if let _ = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "des")
            {
                if(Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "des") as AnyObject?))
                {
                self.descriptiontext =  (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "des") as! String
                }
            }
            
            
             if let _ = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "share_url")
             {
            self.shareurlnew = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "share_url") as! String
            }
            
            
            if let _ = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "total_watch")
            {
                LoginCredentials.Userfreeminut =  (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "total_watch") as! Int/60
            }
            
            if let _ = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "free_time")
            {
                LoginCredentials.Totalfreeminut =  (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "free_time") as! Int/60
            }
            
            
            
            
            self.showratingbar.setvalue =  CGFloat(((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "rating") as! NSString).floatValue)
            // self.showratingbar.value  = 3
       //    self.showratingbar.value = CGFloat(((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "rating") as! NSString).floatValue)
            
 
           
            self.dislikelabel.text = "\((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "dislike_count") as! String)"
          
            if(Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "url") as AnyObject?))
            {
             self.Video_url = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "url") as! String
                
            }
            else
            {
                  self.showbackerroalert()
                return
            }
        //  self.Video_url = "https://d26y9t4ie6v5ra.cloudfront.net/storage/dishtv/chunks/621_5ac1db365c982hls/621_5ac1db365c982_master.m3u8"
            //  self.setvideoinwatchlist()
      
            
            if Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
                
                self.downloadVideo_url = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_path") as! String
                
            }
            else
            {
                self.downloadVideo_url = ""
            }
            
            
            if let _ = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_expiry") {
                if((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_expiry") as! String == "0")
                {
                      self.downloadVideo_url = ""
                }
                
            }
        
            if(Common.Islogin())
            {
            
            if(self.fromdownload == "yes" || self.downloadVideo_url == "")
            {
                self.downloadbutton.setImage(UIImage.init(named: "downloaddisable"), for: .normal)
                self.downloadbutton.isUserInteractionEnabled = true
          
            }
            else
            {
                self.downloadbutton.setImage(UIImage.init(named: "download"), for: .normal)
                self.downloadbutton.isUserInteractionEnabled = true
                
                
            }
            }
            
            if(Common.Islogin())
            {
          self.Chekvideoisdownloading()
            }
        
            Common.startloderonplayer(view: self.view)
            UIApplication.shared.endIgnoringInteractionEvents();
                DispatchQueue.global().async {
                    self.GetVasthurl()
                }
            
 
        }
    }
        )
    { (task: URLSessionDataTask?, error: Error) in
        print("POST fails with error \(error)")
        Common.stoploderonplayer(view: self.view)

          if(self.fromdownload == "yes")
          {
            
        }
        else
          {
            self.showbackerroalert()

        }
    }
    
    

    
    }
    
    
    
   
    
    func showbackerroalert() {
        let alert = UIAlertController(title: "", message: "Something went wrong please try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
             self.navigationController?.popViewController(animated: true)
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func ChekUserwatchfreetime()
    {
        
        
    }
    
    
    
    func checkcontantbehaviour(dict:NSDictionary)
    {
        
        
        print("User Contant behaviour ======== \(dict)")
        if(Common.Islogin())
        {
        
        if((dict.value(forKey: "content") as! NSDictionary).value(forKey: "is_disliked") as! String == "0")
        {
            
            self.dislikebutton.setImage(UIImage.init(named: "dislikedisable"), for: .normal)
            self.isdislike = false
            
        }
        else
        {
            self.dislikebutton.setImage(UIImage.init(named: "dislike"), for: .normal)
            self.isdislike = true
            
            
        }
        if((dict.value(forKey: "content") as! NSDictionary).value(forKey: "likes") as! String == "0")
        {
            
            self.likebutton.setImage(UIImage.init(named: "likedisable"), for: .normal)
            self.islike = false
            
        }
        else
        {
            self.likebutton.setImage(UIImage.init(named: "like"), for: .normal)
            self.islike = true
            
            
        }
        
        
        
        
        
        if((dict.value(forKey: "content") as! NSDictionary).value(forKey: "favorite") as! String == "0")
        {
            
            self.favroutbutton.setImage(UIImage.init(named: "favriout"), for: .normal)
            self.isfav = false
            
        }
        else
        {
            self.favroutbutton.setImage(UIImage.init(named: "favriout1"), for: .normal)
            self.isfav = true
            
            
        }
        }
 
    }
    
    
    func getcntantuserbehavior()
    {
        
        if(Common.Islogin())
        {
            var parameters = [String : Any]()
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            parameters = [ "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                           "content_id":cat_id,
                           "device":"ios"
            ]
            
            
            
           var url = String(format: "%@%@/device/ios/user_id/%@/content_id/%@", LoginCredentials.Userbehaviorapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue,cat_id)
            
            Common.startloderonplayer(view: self.view)
            UIApplication.shared.endIgnoringInteractionEvents();
          //  var url = String(format: "%@%@", LoginCredentials.Userbehaviorapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)

            let manager = AFHTTPSessionManager()
            manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    
                    Common.stoploderonplayer(view: self.view)
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    let number = dict.value(forKey: "code") as! NSNumber
                    
                    if(number == 0)
                    {
                    }
                    else
                    {
                        let dict =  dict.value(forKey: "result") as! NSDictionary
                        print(dict)
                        
                        
                        
                        if(Common.Islogin())
                        {
                            
                            
                            if((dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "is_disliked") as! String == "0")
                            {
                                
                                self.dislikebutton.setImage(UIImage.init(named: "dislikedisable"), for: .normal)
                                self.isdislike = false
                                
                            }
                            else
                            {
                                self.dislikebutton.setImage(UIImage.init(named: "dislike"), for: .normal)
                                self.isdislike = true
                                
                                
                            }
                            if((dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "likes") as! String == "0")
                            {
                                
                                self.likebutton.setImage(UIImage.init(named: "likedisable"), for: .normal)
                                self.islike = false
                                
                            }
                            else
                            {
                                self.likebutton.setImage(UIImage.init(named: "like"), for: .normal)
                                self.islike = true
                                
                                
                            }
                            
                            if((dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "favorite") as! String == "0")
                            {
                                
                                self.favroutbutton.setImage(UIImage.init(named: "favriout"), for: .normal)
                                self.isfav = false
                                
                            }
                            else
                            {
                                self.favroutbutton.setImage(UIImage.init(named: "favriout1"), for: .normal)
                                self.isfav = true
                                
                                
                            }
                            
                        }
                        
                        
 
                        
                    }
                    
                    
                    
                    
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func TaptoSubcribechannel(_ sender: UIButton) {
        
 if(Common.Islogin())
 {
    print(Channeldict)
    
     if(ischnlsucribe)
     {
        
        
    let alert = UIAlertController(title: "Jingu Kid", message: "Unsubscribe from \(Channeldict.value(forKey: "first_name") as! String)\(" ")\(Channeldict.value(forKey: "last_name") as! String) ?", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
        self.subscribechnl()
    }))
    self.present(alert, animated: true, completion: nil)
    }
    else
     {
       self.subscribechnl()
    }

        }
        else
 {
    Common.Showloginalert(view: self, text: "Please login to acess this sction")

         }
    
    }
    
    
    
    func subscribechnl()
    {
        Common.startloderonplayer(view: self.view)
        UIApplication.shared.endIgnoringInteractionEvents();
        var parameters = [String : Any]()
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        parameters = [ "customer_id":dict.value(forKey: "id") as! String,
                       "channel_id":chnl_id,
        ]
        
        var url = String()
        if(!ischnlsucribe)
            
        {
            url = String(format: "%@/channel/subscribe/token/%@", LoginCredentials.Userbehaviorapi,Apptoken)
            
        }
        else
        {
            url = String(format: "%@/channel/unsubscribe/token/%@", LoginCredentials.Userbehaviorapi,Apptoken)
            
        }
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                Common.stoploderonplayer(view: self.view)
                if(self.ischnlsucribe)
                {
                    self.ischnlsucribe = false
                    self.notificationbutton.isHidden = true
                  }
                else
                {
                     self.ischnlsucribe = true
                     self.ischnlnotificationsubcribed = true
                     self.notificationbutton.isHidden = false
                    
                    
                }
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonplayer(view: self.view)
        }
        
    }
    
    
    func Getchanneldeltail(name:String,issubcribe:String,chanellurl:String,notification:String)
    {
     }

    
    func Chekvideoisdownloading()
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
        print(array)
        if(array.contains(cat_id))
        {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let destinationURLForFile = URL(fileURLWithPath: path.appendingFormat("/\((dict.value(forKey: "id") as! NSNumber).stringValue)\(self.cat_id).mp4"))
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationURLForFile.path) {
                
                self.downloadbutton.setImage(UIImage.init(named: "downloaddisable"), for: .normal)
                self.downloadbutton.isUserInteractionEnabled = true
            }
            else
            {
                animatedownloadbutton()

            }
            
            
        }
        else
        {
        stopanimatedownliadbutton()
        }
        
        
        
        
        
        
        
        
    }
   
    
  
    
    
    func animatedownloadbutton()
    {
        
        
        let image1:UIImage = UIImage(named: "1")!
        let image2:UIImage = UIImage(named: "2")!
        let image3:UIImage = UIImage(named: "3")!
        let image4:UIImage = UIImage(named: "4")!
        let image5:UIImage = UIImage(named: "5")!
        let image6:UIImage = UIImage(named: "6")!
        let image7:UIImage = UIImage(named: "7")!
        let image8:UIImage = UIImage(named: "8")!
        let image9:UIImage = UIImage(named: "9")!
        let image10:UIImage = UIImage(named: "10")!
        let image11:UIImage = UIImage(named: "11")!
        let image12:UIImage = UIImage(named: "12")!
        let image13:UIImage = UIImage(named: "13")!
        let image14:UIImage = UIImage(named: "14")!
        let image15:UIImage = UIImage(named: "15")!
        downloadbutton.imageView?.animationImages = [image1,image2,image3,image4,image5,image6,image7,image8,image9,image10,image11,image12,image13,image14,image15]
        downloadbutton.imageView?.animationDuration = 1.0
        downloadbutton.imageView!.startAnimating()
        
        
   
    }
    func stopanimatedownliadbutton()
    {
        downloadbutton.imageView!.stopAnimating()
        downloadbutton.imageView?.cancelImageDownloadTask()
        downloadbutton.imageView?.stopAnimating()
        
        if(self.fromdownload == "yes" || self.downloadVideo_url == "")
        {
            self.downloadbutton.setImage(UIImage.init(named: "downloaddisable"), for: .normal)
            self.downloadbutton.isUserInteractionEnabled = true
            
        }
        else
        {
            downloadbutton.setImage(UIImage.init(named: "download"), for: .normal)
            self.downloadbutton.isUserInteractionEnabled = true

        }
        
    
    }
    
    
  //MARK:- Get parse data with url
    
    func GetVasthurl()
    {
  
        vertitualselectsoundindex = 0
        vertitualselectresolutionindex = 0
      self.setvideodescription(titile: tilttext, like: liketext, des: descriptiontext, url: Video_url)
    
           // var url = String(format: "%@%@/device/ios/cid/%@/secure/1", LoginCredentials.Addetailapi,Apptoken,cat_id)
          var url = String(format: "%@%@/device/ios/secure/1/cid/%@", LoginCredentials.Addetailapi,Apptoken,cat_id)
        
           print(url)
        url = url.trimmingCharacters(in: .whitespaces)

          let manager = AFHTTPSessionManager()
              manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                 if(Common.isNotNull(object: dict.value(forKey: "result") as AnyObject?))
               {
                
                var decodedata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptAddetailapi)
                {
                    decodedata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    
                    decodedata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    
                }
                
            
                print(decodedata_dict)
                 self.setvideodata(titile: self.tilttext, like: self.liketext, des: self.descriptiontext, url:self.Video_url)
                self.setvideodescription(titile: self.tilttext, like: self.liketext, des: self.descriptiontext, url:self.Video_url)
                return
    
                if(Common.isNotNull(object: decodedata_dict.value(forKey: "url") as AnyObject?))
                {
               // self.Video_url = (decodedata_dict.value(forKey: "url") as! NSDictionary).value(forKey: "abr") as! String
                  }
                 print(self.Video_url)
                     if(Common.isNotNull(object: decodedata_dict.value(forKey: "ad") as AnyObject?))
                    {
                        
                   
                      self.vastarray = decodedata_dict.value(forKey: "ad") as! NSArray
                    for i in 0..<self.vastarray.count {
                        
                       
                    
                     let prerole = ((self.vastarray.object(at: i) as! NSDictionary).value(forKey: "campain_info") as! NSDictionary).value(forKey: "campaign_type") as! String
                        
                       if(self.vastarray.count == 1)
                       {
                        if(prerole == "Mid")
                        {
                        self.playvideo(url: self.Video_url)
                        }
                        }
                        
                        if(prerole == "Pre")
                        {
                             self.isprerole = true
                            let vasturl = (((self.vastarray.object(at: i) as! NSDictionary).value(forKey: "campain_info") as! NSDictionary).value(forKey: "tag_url") as! NSArray).object(at: 0) as! String
                            self.parsedatawithvasturl(vasturl: vasturl)
                            
                            
                        }
                        
                        
                        else if(prerole == "Mid")
                        {
                          
                           self.midrolequepointarray = ((self.vastarray.object(at: i) as! NSDictionary).value(forKey: "campain_info") as! NSDictionary).value(forKey: "que_points") as! NSArray
                            self.midroleurl = (((self.vastarray.object(at: i) as! NSDictionary).value(forKey: "campain_info") as! NSDictionary).value(forKey: "tag_url") as! NSArray).object(at: 0) as! String
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
               
                }
                    else
                    {
                        self.setvideodata(titile: self.tilttext, like: self.liketext, des: self.descriptiontext, url:self.Video_url)
                        self.setvideodescription(titile: self.tilttext, like: self.liketext, des: self.descriptiontext, url:self.Video_url)
                        
                    }
                
                }
              }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonplayer(view: self.view)
        }
        
   
    }
    
 
    
    
    
    //MARK:- //Create Player Session Api
    
    func CallplayerUsersesion()
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
        
      let  dictionaryOtherDetail = [
            "os_version" : systemVersion,
            "network_type" : Common.getnetworktype(),
            "network_provider" : networkname,
            "app_version" : appversion!
        ]
      let  devicedetailss = [
            "make_model" : Common.getModelname(),
            "os" : "ios",
            "screen_resolution" : strResolution,
            "device_type" : "app",
            "platform" : "IOS",
            "device_unique_id" : uuid as String,//token! as! String,
            "push_device_token" :  LoginCredentials.DiviceToken
        ]

        
        var json = [String:String]()
        if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")

          json=["od":Common.convertdictinyijasondata(data: dictionaryOtherDetail as NSDictionary),"dd":Common.convertdictinyijasondata(data: devicedetailss as NSDictionary),"id": cat_id,"type":"2","device":"ios","lat":"","long":"","user_id":dict.value(forKey: "id") as! String]
        
        }
        else
        
        {
           json=["od":Common.convertdictinyijasondata(data: dictionaryOtherDetail as NSDictionary),"dd":Common.convertdictinyijasondata(data: devicedetailss as NSDictionary),"id": cat_id,"type":"2","device":"ios","lat":"","long":""]
        }
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        
       // let parameters = ["device":"ios","customer_device":UserDefaults.standard.value(forKey: "UUID") as! String,"lat":"0" as String,"long":"0" as String,"ip":"0" as String,"token":Apptoken as String,"customer_id":dict.value(forKey: "id") as! String] as [String : Any]
        
        var url = String(format: "%@/analytics/event/token/%@", LoginCredentials.Analyticsappapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
          print(url)
        print(json)
        manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
               print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    
                }
                else
                {
                 LoginCredentials.Video_sid = ((dict.value(forKey: "result") as! NSDictionary).value(forKey: "app_session_id") as! NSNumber).stringValue
                    LoginCredentials.isvideostartorendtime = "1"
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "heartBeatapi"), object: nil)
                }
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
        
    }
    
    

    
    
    
    
    //MARK:- Call event api on playing ad
    
    func calladdeventurl(url:String)
    {
        
     
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
    }
    
    
    
    
        //MARK:- Parse Vast Url
    func parsedatawithvasturl(vasturl:String)
    {
       
     let parser = SAVASTParser.init()
        
         parser.parseVAST(vasturl) { (ad) in
          
            print(ad?.jsonPreetyStringRepresentation() ?? String())
            self.Event_dict = self.convertToDictionary(text: (ad?.jsonPreetyStringRepresentation())!)
            print(self.Event_dict)
            if(Common.isNotNull(object: self.Event_dict.value(forKey: "url") as AnyObject?))
            {
            let adurl = self.Event_dict.value(forKey: "url") as! String
            self.isplayadd = true
            self.playvideo(url: adurl)
            }
            
        
            
            
       
        }
 
        
     }
    
    
    func convertToDictionary(text: String) -> NSDictionary {
        let asd = NSDictionary()
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return asd
    }
    

    
    //MARK:- Start Download Method
    
    
   func stopdownloadprogress()
   {
    
    if downloadTask != nil{
        downloadTask.cancel()
    }
     }
    
    
    func downloadwithurl(urlstr:String)
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
         let url = URL(string: urlstr)!
        downloadTask = backgroundSession.downloadTask(with: url)
        downloadTask.resume()
        dataBase.savedownloadvideoid(id: cat_id, userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
   
    }
    
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        
         if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
        else
        {
            
            //  urlData.write(toFile: filePath, atomically: true)
  
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        
       let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
      let fileManager = FileManager.default
      let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
       let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
        print(array)
        let videoid = array.object(at: 0) as! String
           let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/\((dict.value(forKey: "id") as! NSNumber).stringValue)\(videoid).mp4"))
        do
        {
       try fileManager.moveItem(at: location, to: destinationURLForFile)
        self.Showpopupmsg(msg: "video downloading completed")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Downloadingvideo"), object: nil, userInfo: nil)
           print(videoid)
        self.stopanimatedownliadbutton()
       let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
        print(array)
        dataBase.deletedownloadvideoid(videoid: videoid,user_id:(dict.value(forKey: "id") as! NSNumber).stringValue)
        let array1 = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
        print(array1)
       
         }
        catch
        {
           print("Getting issue in downloading")
        }
        

     }
    
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
     
          print(downloadTask.taskIdentifier)
          print(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        
      //  progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    //MARK: URLSessionTaskDelegate
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        downloadTask = nil
         if (error != nil) {
            print(error!.localizedDescription)
        }else{
            print("The task finished transferring data successfully")
        }
    }
    
    //MARK: UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }

    
    //MARK:- End Download Method
    func chekUserislogin()
    {
        
        if !Common.Islogin()
        {
            downloadbutton.isUserInteractionEnabled = true
            likebutton.isUserInteractionEnabled = true
         }
        else
        {
            
            downloadbutton.isUserInteractionEnabled = true
            likebutton.isUserInteractionEnabled = true
         }
        
        
        
    }
   
    
    //MARK:- TAptoExpenddiscriptiontext

    @IBAction func TAptoExpenddiscriptiontext(_ sender: UIButton)
    {
   
        if !isshowmore
        {
            isshowmore = true
            let height =  self.calculateContentHeight(str: descriptiontext)
            print(height)
            //self.discriptionlabeheightcontraint.constant = height - 50
            self.discriptionlabeheightcontraint.constant = height
             scrollviewheighltcontrant.constant =  scrollviewheighltcontrant.constant + height
            self.perform(#selector(changeUI), with: self, afterDelay: 0.01)
            scrollviewheighltcontrant.constant =  480
         }
        else
        {
            self.discriptionlabeheightcontraint.constant = 20.0
            scrollviewheighltcontrant.constant =  480
            isshowmore = false
            self.perform(#selector(changeUI), with: self, afterDelay: 0.01)
         }
   
    }
    
    
    
    func changeUI() {
        
        mXSegmentedPager.frame.origin.y = channelview.frame.origin.y+channelview.frame.size.height
 
    }
    
    func calculateContentHeight(str:String) -> CGFloat{
        let maxLabelSize: CGSize = CGSize.init(width: self.view.frame.size.width - 26, height: 9999)
        let contentNSString = str as NSString
        let expectedLabelSize = contentNSString.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "baloo", size: CGFloat(14))! as UIFont], context: nil)
        print("\(expectedLabelSize)")
        return expectedLabelSize.size.height
        
    }
    
    
    
 
    //MARK:- Set Video data description data

    
    func setvideodescription(titile:String,like:String,des:String,url:String)
    {
     
        
        if(fromdownload == "yes")
        {
            Resolutionbutton.isHidden = true
        }
        else
        {
            Resolutionbutton.isHidden = false
            
        }
        
    
        
        self.titlenamelabel.text = titile
        
        
        
        var discriptiontext = des
        print(des)
        if(des == " " || des == "")
        {
            expenddownarroe.isHidden = true
            self.discriptionlabeheightcontraint.constant = 0.0
            scrollviewheighltcontrant.constant =  460
            isshowmore = false
            self.perform(#selector(changeUI), with: self, afterDelay: 0.01)
        }
        else
        {
            expenddownarroe.isHidden = false
             self.discriptionlabeheightcontraint.constant = 20.0
            scrollviewheighltcontrant.constant =  480
            isshowmore = false
            self.perform(#selector(changeUI), with: self, afterDelay: 0.01)
        }
        
        discriptiontext = discriptiontext.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
       // discriptiontext.remove(at: (discriptiontext.startIndex))
         self.contantdiscriptionlabel.text = discriptiontext
        
    }
    
    
    func setvideodata(titile:String,like:String,des:String,url:String)
    {
 
        print("User Have Total Free Minut \(LoginCredentials.Totalfreeminut)")
        print("User Have remaning Free Minut \(LoginCredentials.Userfreeminut)")
        
        if(LoginCredentials.Userfreeminut > LoginCredentials.Totalfreeminut)
        {
            if(!Common.Isuserissubscribe(Userdetails: self as AnyObject)) {
       
                 let alert = UIAlertController(title: "", message: " Please Subscribe to Watch Content.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Subscribe", style: UIAlertActionStyle.default, handler: { (action) in
                Common.PresentSubscription(Viewcontroller: self)
                self.navigationController?.popViewController(animated: true)
                 }))
               self.present(alert, animated: true, completion: nil)
                
                return
            }
            
        }
        
        
        if(Common.isInternetAvailable())
        {
          getallresolutionview(url: url)
        }
  
        if(self.fromdownload == "yes")
        {
            self.playvideo(url: url)
        }
        else
        {
            if(Common.isInternetAvailable())
            {
                self.playvideo(url: url)
            }
        }
      
    }
    
    //MARK:- view will Disappear

    override func viewWillDisappear(_ animated: Bool) {
        
        if(Common.Islogin())
        {
          
            
         if(downloadbutton.imageView?.isAnimating)!
         {
            downloadbutton.imageView?.stopAnimating()
         }
     
      
        }
        if(LoginCredentials.ischaneelviewappear)
        {
        AppUtility.lockOrientation(.portrait)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
        else
        {
            self.videoPlayer.pause()
        }
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }

        
    }
    
    
    //MARK:- Parse All Resolution
    func getallresolutionview(url:String)
    {
        DispatchQueue.global(qos: .background).async {
            
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
             if(self.fromdownload == "yes")
             {
                
             }
                else
             {
                self.parseallsteme(url: url)
                }
            }
        }
        
        
    }

    
    
    
    
      //MARK:- Play video with url
    func playvideo(url:String)
    {
        
        
         var videoURL = URL(string:url)
        DispatchQueue.main.async { () -> Void in
            let rect = CGRect(origin: CGPoint(x: 0,y :-10), size: CGSize(width: self.view.frame.size.width, height: 200))
            
            if(self.fromdownload == "yes")
            {
             let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let url = NSURL(fileURLWithPath: path)
                let videoDataPath = url.appendingPathComponent("\((dict.value(forKey: "id") as! NSNumber).stringValue)\(self.cat_id).mp4")?.path
                 videoURL = URL(fileURLWithPath: videoDataPath!)
                 Common.stoploderonplayer(view: self.view)
             
            }
            
            
            

            
            let playerItem:AVPlayerItem = AVPlayerItem(url: videoURL!)
            
            
            if self.avLayer != nil
            {
                self.avLayer.removeFromSuperlayer()
                self.avLayer = nil
            }
            if self.videoPlayer != nil && (self.videoPlayer.currentItem != nil)
            {
                self.videoPlayer = nil
            }
            self.videoPlayer = AVPlayer(playerItem: playerItem)
           
             //            if #available(iOS 10.0, *) {
            //                self.videoPlayer.automaticallyWaitsToMinimizeStalling = false
            //            } else {
            //                // Fallback on earlier versions
            //            }
            self.avLayer = AVPlayerLayer(player:self.videoPlayer)
            self.avLayer.frame = rect
            self.avLayer.videoGravity = AVLayerVideoGravityResizeAspect
            
       
            do
            {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
                // report for an error
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(self.startplayingnotification), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: self.videoPlayer.currentItem)
            
            self.view.layer.addSublayer(self.avLayer)
            self.videoPlayer.play()
            self.videoPlayer.isClosedCaptionDisplayEnabled = true
            
            if (self.tempView != nil)
            {
                self.tempView.removeFromSuperview()
                self.tempView = nil
            }
            self.tempView = UIView(frame:CGRect(x:0, y:-10, width:self.view.frame.size.width+10, height:200))
            self.tempView.backgroundColor=UIColor.clear
            self.view.addSubview(self.tempView)
             if(self.fromdownload == "yes")
             {
                
            }
            else
             {
                self.startloader()
            }
            
            if self.playbackSlider != nil
            {
                self.playbackSlider.removeFromSuperview()
            }
            
            
            //////soundslide////////////
            self.soundbackSlider = UISlider(frame:CGRect(x:10, y:145, width:self.view.frame.size.width-20, height:25))
            self.soundbackSlider.minimumValue = 0
            self.soundbackSlider.maximumValue = 1
            self.soundbackSlider.isContinuous = true
            self.soundbackSlider.tintColor = UIColor.blue
             self.soundbackSlider.addTarget(self, action: #selector(self.soundSliderValueChanged(_:)), for: .valueChanged)
            self.tempView.addSubview(self.soundbackSlider)
            self.soundbackSlider.isHidden = true
            
            self.playbackSlider = UISlider(frame:CGRect(x:10, y:145, width:self.view.frame.size.width-20, height:25))
            let leftTrackImage = UIImage(named: "sliderThumb")
            let minImage = UIImage(named: "lineRed")
            let maxImage = UIImage(named: "lineGray")
            self.playbackSlider.setThumbImage(leftTrackImage, for: .normal)
            self.playbackSlider.minimumValue = 0
            // playbackSlider.maximumValue = 100
            self.playbackSlider.setValue(0, animated: true)
            self.playbackSlider.setMaximumTrackImage(maxImage, for: .normal)
            self.playbackSlider.setMinimumTrackImage(minImage, for: .normal)
            let duration : CMTime = playerItem.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            //playerViewController.player = player
            let endInterval = NSDate(timeIntervalSince1970:seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.ReferenceType.local
            dateFormatter.dateFormat = "HH:mm:ss"
            let dateTimeFromPublishedString = dateFormatter.string(from: endInterval as Date)
            if seconds != seconds
            {
                self.playbackSlider.maximumValue = Float(0.0)
            }
            else
            {
                self.playbackSlider.maximumValue = Float(seconds)
            }
            self.totalvideoDurationtime = Float(seconds)
            self.playbackSlider.isContinuous = true
            self.playbackSlider.tintColor = UIColor.green
            
            if (self.timer != nil)
            {
                self.timer.invalidate()
                self.timer = nil
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
            //Swift 2.2 selector syntax
            self.playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
            self.view.addSubview(self.playbackSlider)
            
            self.view.bringSubview(toFront: self.tempView)
            self.view.bringSubview(toFront: self.playbackSlider)
            let rectsound = CGRect(origin: CGPoint(x: 5,y :180), size: CGSize(width: 20, height: 20))
            self.soundcontrolbutton.frame = rectsound
            self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "Unmute"), for: .normal)
            self.soundcontrolbutton.addTarget(self, action: #selector(self.controlsound(button:)), for: .touchUpInside)
            self.tempView.addSubview(self.soundcontrolbutton)
            //duration
            let rectLeft = CGRect(origin: CGPoint(x: 30,y :184), size: CGSize(width: 30, height: 10))
            if self.lblLeft != nil
            {
                self.lblLeft.removeFromSuperview()
            }
            self.lblLeft.backgroundColor = UIColor.clear
            self.lblLeft.font = UIFont.systemFont(ofSize: 8)
            self.lblLeft.textColor = UIColor.white
            self.lblLeft.text = "00:00"
            self.lblLeft.frame = rectLeft
            self.tempView.addSubview(self.lblLeft)
            let timeDuration = Float(seconds)
            //singleTapped
            
            
            self.singletap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapped))
            self.singletap.numberOfTapsRequired = 1
             if !self.isplayadd
            {
            self.tempView.addGestureRecognizer(self.singletap)
            }
            
            let (hr,  minf) = modf (timeDuration / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            let hoursString = String(hr)
            let minutesString = String(min)
            let secondString = String(second)
            let timeEnd = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            
            let rectRight = CGRect(origin: CGPoint(x: self.lblLeft.frame.origin.x+self.lblLeft.frame.size.width,y :184), size: CGSize(width: 40, height: 10))
            if self.lblEnd != nil
            {
                self.lblEnd.removeFromSuperview()
            }
            self.lblEnd.backgroundColor = UIColor.clear
            self.lblEnd.font = UIFont.systemFont(ofSize: 8)
            
            self.lblEnd.text = "\("/")\(" ")\(timeEnd as String)"
            self.lblEnd.frame = rectRight
            self.lblEnd.textColor = UIColor.white
            self.tempView.addSubview(self.lblEnd)
            
            if self.expandBtn != nil
            {
                self.expandBtn.removeFromSuperview()
            }
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :97), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore
            self.expandBtn.addTarget(self, action: #selector(self.expandBtnAction), for: .touchUpInside)
            let image = UIImage(named:"pause")
            self.expandBtn.setImage(image, for: .normal)
            self.expandBtn.isHidden = true
            if self.enlargeBtn != nil
            {
                self.enlargeBtn.removeFromSuperview()
            }
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-20,y :184), size: CGSize(width: 15, height: 15))
            //expandPlayer
            let expandImage = UIImage(named: "expandPlayer")
            self.enlargeBtn.setImage(expandImage, for: .normal)
            self.enlargeBtn.frame = rectEnlarge
            self.enlargeBtn.addTarget(self, action: #selector(self.enlargeBtnAction), for: .touchUpInside)
            
            
            ///Skipbutton
            let skipEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-105,y :160), size: CGSize(width: 95, height: 30))
            self.Skipbutton.setTitle("SKIP", for: .normal)
            self.Skipbutton.setTitleColor(UIColor.white, for: .normal)
            self.Skipbutton.frame = skipEnlarge
            self.Skipbutton.backgroundColor = UIColor.black
            self.Skipbutton.addTarget(self, action: #selector(self.taptoskip), for: .touchUpInside)
            self.Skipbutton.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(16))
            Common.setbuttonborderwidth(button: self.Skipbutton, borderwidth: 1.0)
             self.tempView.addSubview(self.Skipbutton)
              self.Skipbutton.isHidden = true
               self.tempView.addSubview(self.expandBtn)
            self.tempView.bringSubview(toFront: self.expandBtn)
            
            self.tempView.addSubview(self.enlargeBtn)
            self.tempView.bringSubview(toFront: self.enlargeBtn)
            
            if self.enlargeBtnLayer != nil
            {
                self.enlargeBtnLayer.removeFromSuperview()
            }
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-70,y :120), size: CGSize(width: 120, height: 90))
            //expandPlayer
            let expandLayerImage = UIImage(named: "")
            self.enlargeBtnLayer.setImage(expandLayerImage, for: .normal)
            self.enlargeBtnLayer.frame = rectEnlargeLayer
            self.enlargeBtnLayer.addTarget(self, action: #selector(self.enlargeBtnAction), for: .touchUpInside)
            
            self.tempView.addSubview(self.enlargeBtnLayer)
            self.tempView.bringSubview(toFront: self.enlargeBtnLayer)
            self.backwordbutton.isHidden = true
            self.forwardbutton.isHidden = true
            self.soundbutton.isHidden = true
            self.backwordbuttonuppercnstraint.constant = 70.0
             self.Resolutionbutton.isHidden = true
            self.view.bringSubview(toFront: self.forwardbutton)
            self.view.bringSubview(toFront: self.backwordbutton)
            self.view.bringSubview(toFront: self.soundbutton)
            self.view.bringSubview(toFront: self.backbutton)
            self.view.bringSubview(toFront: self.Resolutionbutton)
            self.view.bringSubview(toFront: self.Skipbutton)
            self.view.bringSubview(toFront: self.soundbackSlider)
            self.view.bringSubview(toFront: self.soundcontrolbutton)
         
            self.rotateddd()
            
       
            
            if !self.isplayadd
            {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                  self.bHideControl = false
                    self.singleTapped()
                })
            }
            else{
                
                self.bHideControl = false
                self.singleTapped()
                
            }
        }
        
 
    }
  
    

    
    //MARK:- Make skip button enalbel
   
   func makeskipbuttonenalbel()
   {

     skiptime = skiptime + 1
    if(skiptime<6)
    {
        Skipbutton.isUserInteractionEnabled = false
    self.Skipbutton.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
    Skipbutton.setTitle("Skip After \(skiptime) Sec", for: .normal)
    }
    else
    {
      Skipbutton.isUserInteractionEnabled = true
     self.Skipbutton.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(16))
       Skipbutton.setTitle("SKIP", for: .normal)
    }
    
    
    
    }
    
    //MARK:- Make stop timer
    func stopTimer() {
        skiptimer.invalidate()
        //timerDispatchSourceTimer?.suspend() // if you want to suspend timer
     }
    
   
    
    //MARK:- Skip button action
  
  func taptoskip()
  {
    Skipbutton.isHidden = true
    isplayadd = false
    self.avLayer.removeFromSuperlayer()
    self.avLayer = nil
    self.videoPlayer = nil
    
    
    if(isprerole)
    {
        self.setvideodata(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
        isprerole = false
  
    }
    else
    {
      
        
    }
    

    }
    
    
    
    //MARK:- Video player playing Updata Method
   
    func update()
    {
        if self.videoPlayer != nil && (self.videoPlayer.currentItem != nil)
        {
            let currentItem:AVPlayerItem = videoPlayer.currentItem!
            let duration:CMTime = currentItem.duration
            let videoDUration:Float = Float(CMTimeGetSeconds(duration))
            let currentTime:Float = Float(CMTimeGetSeconds(videoPlayer.currentTime()))
            
            if self.bSlideBar == true
            {
                let time = Int(currentTime)
                let timePlay = Int(self.playbackSlider.value)
                print("currentTime ",time)
                print("self.playbackSlider.value >>",timePlay)
                if time == timePlay {
                    self.bSlideBar = false
                }
            }
            else
            {
                self.playbackSlider.value = currentTime
            }
            
            
            
            
            
           
     
            
            if(Common.isInternetAvailable())
            {
            
            if(!isplayadd)
            {
              
             
               let currentplayertimeint = Int(self.playbackSlider.value)
                let currentplayertime = String(currentplayertimeint)

                print("/////////////////////////////")
                
                print("video current playing time -> \(currentplayertime)")
                
                LoginCredentials.VideoPlayingtime = currentplayertimeint
                LoginCredentials.Contantplaytime = currentplayertimeint
                
            if(midrolequepointarray.contains(currentplayertime))
            {
              
                 print("Find Midrole playing time -> \(midrolequepointarray)")
                isprerole = false
                isplayadd = true
                ismidrolepresent = true
                midroletime = self.playbackSlider.value
                self.parsedatawithvasturl(vasturl: midroleurl)
                
             }
            
                
        
                
                
                
           
                
                
            }
                else
            {
                
                let currentplayertimeint12 = Int(self.playbackSlider.value)
                 print("LoginCredentials.Addtime -> \(LoginCredentials.Addtime)")
                print("add time current playing -> \(currentplayertimeint12)")
                LoginCredentials.Addtime =  currentplayertimeint12
                
                
                
                
                }
            }
            let (hr,  minf) = modf (currentTime / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            
            let time = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            self.lblLeft.text = time
            
            // playerTime = Int(currentTime)
        }
    }
    
    
    
 
    
    //MARK:- Player Delegate
    
     func removeLoaderAfter()
    {
        self.stoploader()
    }
    func stoploader()
    {
        activityIndicator.removeFromSuperview()
    }
    
    
    func addPlayeraddtime()
    {
        if(isplayadd)
        {
         let currentplayertimeint = Int(self.playbackSlider.value)
        // LoginCredentials.Addtime =  currentplayertimeint
       // print("\("Add Time   >")\(LoginCredentials.Addtime)")
        }
    }
    
    func startplayingnotification(note: NSNotification)
    {
        print("note >>>",note.object)
        Common.stoploderonplayer(view: self.view)
        DispatchQueue.global().async {
            self.getmorevideo()
            self.getuserrelatedvideo()
        }
        
        
        if(isplayadd)
        {
           
            
          Playeraddtime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addPlayeraddtime), userInfo: nil, repeats: true);
            
            
            
            if(ismidrolepresent)
            {
              Skipbutton.isHidden = true
            }
            else
            {
            Skipbutton.isHidden = false
            }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.makeskipbuttonenalbel), userInfo: nil, repeats: true)
             removeLoaderAfter()
            let eventarray =  Event_dict.value(forKey: "events") as! NSArray
           for i in 0..<eventarray.count
           {
            if(((eventarray.object(at: i) as! NSDictionary).value(forKey: "event") as! String) == "vast_impression")
            {
                
             let url = (eventarray.object(at: i) as! NSDictionary).value(forKey: "URL") as! String
                self.calladdeventurl(url: url)
             }
            }
            
            
        }
        else
        {
            self.perform(#selector(removeLoaderAfter), with: nil, afterDelay: 1.0)
            Skipbutton.isHidden = true
            
            if Playeraddtime != nil
            {
                Playeraddtime.invalidate()
                Playeraddtime  = nil
            }

            
            
            

            
        }
        
    }
    
    
    
    
    func playerDidFinishPlaying(note: NSNotification)
    {
        
        
      
        if Playeraddtime != nil
        {
            Playeraddtime.invalidate()
            Playeraddtime  = nil
        }
        
        
      if(isplayadd)
      {
        isplayadd = false
        Skipbutton.isHidden = true
         if(ismidrolepresent)
        {
            playseektime(seektime: midroletime)
            ismidrolepresent = false
        }
        else
         {
            isprerole = false
            self.setvideodata(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
            
            
        }


        }
        else
      {
        LoginCredentials.isvideostartorendtime = "2"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "heartBeatapi"), object: nil)
        
        //Common.callappanalytics()
        self.PlayNextvideoinmoresection()
        
        if(Common.Islogin())
        {
            LoginCredentials.isvideostartorendtime = ""
            LoginCredentials.Video_sid = ""
            
            
        }
        else
        {
            Common.stopHeartbeat()
            
        }

        }
        
    }
    
    
    
    
    //MARK:- Rotation add

    
    func rotateddd()
    {
        
        
//          if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
//          {
//
//        }
//
//        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
//        {
//        }
        
 
        if(DeviceInfo.Orientation.isLandscape)
        {
          print("Device is in Landscape mode")
        }
        else if(DeviceInfo.Orientation.isPortrait)
        {
            print("Device is in Portrait mode")

        }
        if(self.avLayer != nil)
        {
        if DeviceInfo.Orientation.isLandscape
        {
            bEnlarge = true
            Bottomviewuppercnstraint.constant = 600.0
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            self.avLayer.frame = rect
            backbutton.isHidden = true
            backwordbuttonuppercnstraint.constant = rect.size.height/2-20
            let rectPlay = CGRect(x:10, y:self.view.frame.size.height-45, width:self.view.frame.size.width-20, height:25)
            self.playbackSlider.frame = rectPlay
            self.soundbackSlider.frame = rectPlay
            let rectsound = CGRect(origin: CGPoint(x: 5,y :self.view.frame.size.height-19), size: CGSize(width: 20, height: 20))
            self.soundcontrolbutton.frame = rectsound
            let rectLeft = CGRect(origin: CGPoint(x: 30,y :self.view.frame.size.height-15), size: CGSize(width: 30, height: 10))
            lblLeft.frame = rectLeft
            let rectRight = CGRect(origin: CGPoint(x: lblLeft.frame.origin.x+lblLeft.frame.size.width,y :self.view.frame.size.height-15), size: CGSize(width: 40, height: 10))
            lblEnd.frame = rectRight
            expandBtn.isHidden = true
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :self.view.frame.size.height/2 - 35.0), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-40,y :self.view.frame.size.height-25), size: CGSize(width: 20, height: 20))
            enlargeBtn.frame = rectEnlarge
            enlargeBtn.setImage(#imageLiteral(resourceName: "expandPlayerrotation"), for: .normal)
            
            
             let skipEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-105,y :self.view.frame.size.height-35), size: CGSize(width: 95, height: 30))
            Skipbutton.frame = skipEnlarge
            
            
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-60,y :self.view.frame.size.height-64), size: CGSize(width: 90, height: 90))
            enlargeBtnLayer.frame = rectEnlargeLayer
            
            self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
            activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
            backwordbutton.isHidden = true
            forwardbutton.isHidden = true
            soundbutton.isHidden = true
            Resolutionbutton.isHidden = true
            self.view.bringSubview(toFront: enlargeBtn)
            self.view.bringSubview(toFront: enlargeBtnLayer)
            self.view.bringSubview(toFront: forwardbutton)
            self.view.bringSubview(toFront: backwordbutton)
            self.view.bringSubview(toFront: soundbutton)
            self.view.bringSubview(toFront: Resolutionbutton)
            self.view.bringSubview(toFront: soundcontrolbutton)
            
            bHideControl = true
            self.playbackSlider.isHidden = true
            self.lblLeft.isHidden = true
            self.lblEnd.isHidden = true
            self.soundcontrolbutton.isHidden = true
            self.enlargeBtn.isHidden = true
            self.enlargeBtnLayer.isHidden = true
            
            
            
            self.expandBtn.isHidden = true
        }
        
        if DeviceInfo.Orientation.isPortrait
        {
            bEnlarge = false
            Bottomviewuppercnstraint.constant = 180.0
            
            print("Portrait")
            self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 200))
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 200))
            self.avLayer.frame = rect
            backbutton.isHidden = false
            let rectPlay = CGRect(x:10, y:150, width:self.view.frame.size.width-20, height:25)
            self.playbackSlider.frame = rectPlay
            self.soundbackSlider.frame = rectPlay
            expandBtn.isHidden = false
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :75), size: CGSize(width: 40, height: 40))
            self.expandBtn.frame = rectMore
            backwordbuttonuppercnstraint.constant = 60.0
            
            
            let soundLeft = CGRect(origin: CGPoint(x: 5,y :175), size: CGSize(width: 20, height: 20))
            soundcontrolbutton.frame = soundLeft
            
            let rectLeft = CGRect(origin: CGPoint(x: 30,y :180), size: CGSize(width: 30, height: 10))
            lblLeft.frame = rectLeft
            let rectRight = CGRect(origin: CGPoint(x: lblLeft.frame.origin.x+lblLeft.frame.size.width,y :180), size: CGSize(width: 40, height: 10))
            lblEnd.frame = rectRight
            
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-30,y :180), size: CGSize(width: 15, height: 15))
            enlargeBtn.frame = rectEnlarge
            enlargeBtn.setImage(#imageLiteral(resourceName: "expandPlayer"), for: .normal)

            let skipEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-105,y :160), size: CGSize(width: 95, height: 30))
             Skipbutton.frame = skipEnlarge
            
            
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-70,y :120), size: CGSize(width: 120, height: 90))
            enlargeBtnLayer.frame = rectEnlargeLayer
            activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
              self.Mycollectionview.reloadData()
        }
        }
    }
    
  
    //MARK:- Control sound action
    
    func controlsound(button:UIButton)
    {
        let volume = AVAudioSession.sharedInstance().outputVolume
        print(volume)
        
        self.soundbackSlider.value = volume
        playbackSlider.isHidden = true
        soundbackSlider.isHidden = false
      
       
//         DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
//            self.bHideControl = false
//            self.singleTapped()
//            
//        })
        
    }
    
    
    
    //MARK:- Sound Slider Change notifation method
    
    func soundSliderValueChanged(_ playbackSlider:UISlider)
    {
        print("\("Sound volueme is ")\(playbackSlider.value)")
        self.videoPlayer.volume = playbackSlider.value
        let vol = String(format: "%.1f", playbackSlider.value)
        print(vol)
        switch vol {
        case "0.0":
            self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "sound_mute"), for: .normal)
            break
        case "0.3":
            self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "sound_33"), for: .normal)
            break
        case "0.6":
            self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "sound_66"), for: .normal)
            break
        case "1.0":
            self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "sound_100"), for: .normal)
            break
        default:
            break
        }
        
        
    }
    
    //MARK:- UISlider Change notifation method
 
    func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        self.bSlideBar = true
         isplayorpause()
//        if self.videoPlayer!.rate == 0
//        {
//            self.videoPlayer?.play()
//        }
    }
    
  
    
    func isplayorpause()
    {
        if(bPlay)
        {
            if(self.videoPlayer != nil)
            {
                self.videoPlayer.pause()
            }
        }
        else
        {
            if(self.videoPlayer != nil)
            {
            self.videoPlayer.play()
            }
            
        }
    }
    
    
    //MARK:- Chage Player seek time
  
    func playseektime(seektime:Float)
    {
         self.playvideo(url: Video_url)
        self.perform(#selector(playeseektime), with: nil, afterDelay: 3.0)
        
        
        
            }
    
  func playeseektime()
  {
   
    let seconds : Int64 = Int64(midroletime+10)
    let targetTime:CMTime = CMTimeMake(seconds, 1)
    self.videoPlayer!.seek(to: targetTime)
    self.playbackSlider.value = Float(CGFloat(seconds))
    self.bSlideBar = true
    isplayorpause()
//    if self.videoPlayer!.rate == 0
//    {
//        self.videoPlayer?.play()
//    }

    }
    
    
    //MARK:- On Player Single Tap action
   
    func singleTapped() {
   
 
       
        self.tempView.removeGestureRecognizer(singletap)
        self.singletap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapped))
        self.singletap.numberOfTapsRequired = 1
        if !self.isplayadd
        {
            self.tempView.addGestureRecognizer(self.singletap)
        }
        
        
        
        
        if bHideControl == true
        {
            
            // self.perform(#selector(self.removecontroleronvideofter3sec), with: self, afterDelay: 4)
            //            let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
            //            DispatchQueue.main.asyncAfter(deadline: when) {
            //
            //                self.removecontroleronvideofter3sec()
            //            }
            bHideControl = false
            self.playbackSlider.isHidden = false
            self.lblLeft.isHidden = false
            self.lblEnd.isHidden = false
            self.enlargeBtn.isHidden = false
            self.enlargeBtnLayer.isHidden = false
            backwordbutton.isHidden = false
            forwardbutton.isHidden = false
            soundbutton.isHidden = true
            Resolutionbutton.isHidden = false
            self.expandBtn.isHidden = false
            self.soundcontrolbutton.isHidden = false
            self.backbutton.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.singleTapped()
                
            })
            
            
        }
        else
        {
            //  NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.removecontroleronvideofter3sec), object: nil)
            bHideControl = true
            self.playbackSlider.isHidden = true
            self.lblLeft.isHidden = true
            self.lblEnd.isHidden = true
            self.enlargeBtn.isHidden = true
            self.enlargeBtnLayer.isHidden = true
            backwordbutton.isHidden = true
            forwardbutton.isHidden = true
            soundbutton.isHidden = true
            Resolutionbutton.isHidden = true
            self.expandBtn.isHidden = true
            self.soundcontrolbutton.isHidden = true
            soundbackSlider.isHidden = true
            self.backbutton.isHidden = true


        }
        
    }
    
    
    
    
    
    
    //MARK:- Tap to oritation
 
    
    func enlargeBtnAction()
    {
        if bEnlarge == true {
            bEnlarge = false
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        else
        {
            bEnlarge = true
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
    }
    
    //MARK:- Tap to Play Or Paush video player

    
    func expandBtnAction()
    {
        
        if(self.videoPlayer != nil)
        {
        if bPlay == true
        {
            self.videoPlayer.play()
            bPlay = false
            let image = UIImage(named:"pause")
            self.expandBtn.setImage(image, for: .normal)
            
        }
        else
        {
            self.videoPlayer.pause()
            bPlay = true
            let image = UIImage(named:"play")
            self.expandBtn.setImage(image, for: .normal)
            
        }
        }
    }
    
    
    //MARK:- startloader on player view
  
    func startloader()
    {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        //activityIndicator.color = UIColor.red
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
        activityIndicator.startAnimating()
        self.tempView.addSubview(activityIndicator)
    }
    
    
    
    
    
 //MARK:- Getmorevideo
    
    func getmorevideo()
    {
        let parameters = [
            "device": "ios",
            "cat_id": catid,
            "content_id":cat_id
            ] as [String : Any]
          var url = String(format: "%@%@/device/ios/current_offset/0/max_counter/100/cat_id/%@", LoginCredentials.Listapi,Apptoken,catid)
        
        if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
        {
             url = String(format: "%@%@/device/ios/current_offset/0/max_counter/100/cat_id/%@/age_group/%@", LoginCredentials.Listapi,Apptoken,catid,LoginCredentials.Agegroup)
        }
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptListapi)
                {
                    Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    
                }
                print(Catdata_dict)
                self.moredataarray = Catdata_dict.value(forKey: "content") as! NSArray
                //self.scrollviewheighltcontrant.constant = (CGFloat(self.moredataarray.count/2) * 141.0)
                 self.Mycollectionview.reloadData()
               // self.mytableview.reloadData()
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
         }
        
    }
    
    //MARK:- Getuserrelatedvideo

    func getuserrelatedvideo()
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        var parameters = [String:String]()
        var url = String(format: "%@%@/device/ios", LoginCredentials.Recomendedapi,Apptoken)

        if (dict.count>0)
        {
            
            parameters = [
                "device": "ios",
                "user_id": (dict.value(forKey: "id") as! NSNumber).stringValue
            ]
            
              url = String(format: "%@%@/device/ios/current_offset/0/max_counter/50/user_id/%@", LoginCredentials.Recomendedapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue)
            
            
            if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
            {
                   url = String(format: "%@%@/device/ios/current_offset/0/max_counter/50/user_id/%@/age_group/%@", LoginCredentials.Recomendedapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue,LoginCredentials.Agegroup)
            }

            
            
        }   
        else
        {
            parameters = [
                "device": "ios",
                "user_id": ""
            ]
            
              url = String(format: "%@%@/device/ios/current_offset/0/max_counter/50/user_id", LoginCredentials.Recomendedapi,Apptoken)
            
            if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
            {
                
               url = String(format: "%@%@/device/ios/current_offset/0/max_counter/50/user_id/age_group/%@", LoginCredentials.Recomendedapi,Apptoken,LoginCredentials.Agegroup)
            }

            
        }
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        
        
        manager.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptRecomendedapi)
                {
                    Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                print(Catdata_dict)
                self.recomdentdedataarray = Catdata_dict.value(forKey: "content") as! NSArray
               // self.Mycollectionview.reloadData()

                // self.mytableview.reloadData()
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
         }
        
    }
     @IBAction func Taptofavrout(_ sender: UIButton)
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            
        
            
            var parameters = [String:String]()
            if(isfav)
            {
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "favorite":"0",
                    "content_type":"video",
                ]
            }
            else
            {
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "favorite":"1",
                    "content_type":"video",
                ]
                
            }
            if(self.isfav)
            {
                self.isfav = false
                self.favroutbutton.setImage(UIImage.init(named: "favriout"), for: .normal)
                self.favcount = self.favcount - 1
                toast.isShow("Remove from favorite videos")
            }
            else
            {
                //  dataBase.savefavrioutvideoid(id: self.cat_id, userid: logindict.value(forKey: "id") as! String)
                self.isfav = true
                self.favroutbutton.setImage(UIImage.init(named: "favriout1"), for: .normal)
                self.favcount = self.favcount + 1
                toast.isShow("Added to favorite videos")
            }
            
            
            
            if(self.favcount<0)
            {
                favcount = 0
            }
            self.favrioutlabel.text = "\(self.favcount)"
            var url = String(format: "%@%@", LoginCredentials.Favrioutapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)

              print(parameters)
            print(url)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    
                    let dict = responseObject as! NSDictionary
              
                     print(dict)
                
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
            }
    }
    else
        {
            Common.Showloginalert(view: self, text: "Please Login to download video")
  
        }
    }
    
    //MARK:- Taptodownload Acrion
    @IBAction func Taptodownload(_ sender: UIButton)
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            if(downloadVideo_url == "")
            {
                EZAlertController.alert(title: "Can't Download This Video")
                return
                
            }
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let destinationURLForFile = URL(fileURLWithPath: path.appendingFormat("/\((dict.value(forKey: "id") as! NSNumber).stringValue)\(self.cat_id).mp4"))
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationURLForFile.path) {
                print("FILE AVAILABLE")
                EZAlertController.alert(title: "This Video already exists in your download section")
                return

            } else
            {
                
                
                 let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
                 if(array.contains(cat_id))
                {
                 print("id is match")
                Showpopupmsg(msg: "\(tilttext) video already in downloading")
                }
                else
                {
                    self.saveDownloaddataincoredata()
                    Showpopupmsg(msg: "\(tilttext) video start downloading")
                    self.downloadwithurl(urlstr: self.downloadVideo_url)
                    self.animatedownloadbutton()
                }
   
        }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please Login to download video")

            
        }
    }
    
    
    //MARK:- Show notification pop up message

    func Showpopupmsg(msg:String)
    {
        let view = MessageView.viewFromNib(layout:.MessageView)
        view.configureTheme(.info)
        view.configureDropShadow()
        view.configureContent(title: "Jingu Kid", body: msg, iconText:"")
        SwiftMessages.show(view: view)
    }
    
    
    //MARK:- SaveDownloaddataincoredata
  
    func saveDownloaddataincoredata()
    {
         DispatchQueue.global().async {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(self.Download_dic)
            if(Common.isNotNull(object: (self.Download_dic.value(forKey: "thumbs") as AnyObject)))
            {
            
          let url = (((self.Download_dic.value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
        let videoimage = NSData.init(contentsOf: URL(string: url)!)
        dataBase.SaveDownloadvideo(Userid: (dict.value(forKey: "id") as! NSNumber).stringValue, Videoid: self.cat_id, data: self.Download_dic, image:videoimage!)
            }
            else
            {
               
                let videoimage = UIImagePNGRepresentation(#imageLiteral(resourceName: "Placehoder")) as NSData?
                dataBase.SaveDownloadvideo(Userid: (dict.value(forKey: "id") as! NSNumber).stringValue, Videoid: self.cat_id, data: self.Download_dic, image:videoimage!)
            }
            
            
            
        }
        
    }
    //MARK:- Taptoshare
 
    @IBAction func Taptoshare(_ sender: UIButton) {
        
        if(Common.Islogin())
        {
        let text = "I am watching this awesome video \(shareurlnew) on Jingu Kid. \n Visit Jingu Kid app on App Store"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.mail,UIActivityType.message,UIActivityType.copyToPasteboard,UIActivityType.assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
        }
        else
        {
             Common.Showloginalert(view: self, text: "Please Login to share video")
        }
        
     }
    
    
    
    
    
    //MARK:- Taptofav
 
    
    @IBAction func Taptodislike(_ sender: UIButton) {
        
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            var parameters = [String:String]()
            if(!isdislike)
            {
                
                dislikecount =  dislikecount + 1
                 parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "dislike":"1",
                    "content_type":"video",
                ]
            }
            else
            {
                  dislikecount =  dislikecount - 1
                  parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "dislike":"0",
                    "content_type":"video",
                ]
                
            }
            
            
            if(self.isdislike)
            {
                self.isdislike = false
                self.dislikebutton.setImage(UIImage.init(named: "dislikedisable"), for: .normal)
                 //toast.isShow("Removed from dislike videos")
                
            }
            else
                
            {
                self.isdislike = true
                self.dislikebutton.setImage(UIImage.init(named: "dislike"), for: .normal)
                   // toast.isShow("Added to dislike videos")
                
            }
            
            
            
            if(islike)
            {
               likecount =  likecount - 1
               self.likebutton.setImage(UIImage.init(named: "likedisable"), for: .normal)
                islike = false
            }
            
            
             if(self.dislikecount<0)
            {
             dislikecount = 0
             }
            if(likecount<0)
            {
              likecount = 0
            }
            self.dislikelabel.text = "\(self.dislikecount)"
            self.likelabel.text = "\(self.likecount)"
            
            
            
            var url = String(format: "%@%@", LoginCredentials.Dislikeapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)

            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    // let Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    // print(Catdata_dict)
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to access this section")

           
        }
        
    }
    //MARK:- Taptolike
   
    @IBAction func Taptolike(_ sender: UIButton) {
        
        
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            var parameters = [String:String]()
            if(!islike)
            {
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "like":"1",
                    "content_type":"video",
                ]
                likecount =  likecount + 1
                
            }
            else
            {
                
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "like":"0",
                    "content_type":"video",
                ]
                    likecount =  likecount - 1
                 //dislikecount =  dislikecount + 1
            }
            
            
            
       
            
            
            if(self.islike)
            {
                self.likebutton.setImage(UIImage.init(named: "likedisable"), for: .normal)
                self.islike = false
                toast.isShow("Removed from liked videos")
                
                
            }
            else
            {
                self.likebutton.setImage(UIImage.init(named: "like"), for: .normal)
                self.islike = true
                 toast.isShow("Added to liked videos")
                
                
            }
          
            
            
            
            
            
            if(self.isdislike)
            {
                dislikecount =  dislikecount - 1
                self.isdislike = false
                self.dislikebutton.setImage(UIImage.init(named: "dislikedisable"), for: .normal)
            }

            self.dislikelabel.text = "\(self.dislikecount)"
            self.likelabel.text = "\(self.likecount)"
            
            var url = String(format: "%@%@", LoginCredentials.Likeapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)

            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                     print(dict)
 
                    
   
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
            
        }
        else
        {
          Common.Showloginalert(view: self, text: "Please login to access this section")
        }
        
        
    }
    
    
    
    
    func setdataincontinuewatching() {
 
        if(!isplayadd)
        {
            if(self.videoPlayer != nil)
            {
                if(playbackSlider.maximumValue != self.playbackSlider.value && self.playbackSlider.value > 10.0)
                    
                {
                    if(Common.Islogin())
                    {
                        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                         let continuewatchingarray = dataBase.getcontinuewatchingfromdatabase(userid: (dict.value(forKey: "id") as! NSNumber).stringValue) as NSMutableArray
                          print(continuewatchingarray)
                        
                        
                        for i in 0..<continuewatchingarray.count {
                            let videoid = (continuewatchingarray.object(at: i) as! NSDictionary).value(forKey: "id") as! String
                            if(cat_id == videoid) {
                                return
                            }
                         }
                        
         
                        
                        if(continuewatchingarray.count>9) {
                            dataBase.deleteLastindexdataFromcontinuewatching()
                        }
                        
        dataBase.Savecontinuewatching(id: (dict.value(forKey: "id") as! NSNumber).stringValue, videiid: cat_id, seektime: self.playbackSlider.value, data: Download_dic)
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CallHomeapi"), object: nil, userInfo: nil)
                        
                        
                        // dataBase.Savecontinuewatching(id: (dict.value(forKey: "id") as! NSNumber).stringValue, seektime: self.playbackSlider.value, data: Download_dic)
                    }
                    
                }
                
            }
        }
    }
    
    
    func backstoppalyer()
    {
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
    }
    //MARK:- Taptoback

    @IBAction func Taptoback(_ sender: UIButton) {
        
       
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
//        AppUtility.lockOrientation(.portrait)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
 
       self.setdataincontinuewatching()
        Common.callappanalytics()
        if Playeraddtime != nil
        {
            Playeraddtime.invalidate()
            Playeraddtime  = nil
        }
        
        LoginCredentials.isvideostartorendtime = "2"
         if(Common.Islogin())
        {
            
            LoginCredentials.isvideostartorendtime = ""
             LoginCredentials.Video_sid = ""
            
        }
        else
        {
            Common.stopHeartbeat()
            
        }
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
        avLayer.removeFromSuperlayer()
        self.videoPlayer.pause()
        self.videoPlayer = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.backstoppalyer()
        })
        
        (self.navigationController?.popViewController(animated: true))!
        
    }
    
    //MARK:- MXSegmentedPager Set menu

    func setmenu()
    {
        mXSegmentedPager = MXSegmentedPager.init(frame: CGRect.init(x: 0, y: channelview.frame.origin.y+channelview.frame.size.height, width: self.view.frame.size.width, height: 41))
        mXSegmentedPager.segmentedControl.selectionIndicatorLocation = .down
        mXSegmentedPager.segmentedControl.backgroundColor =  UIColor(red: 247/255, green: 230/255, blue: 70/255, alpha: 1.0)
        mXSegmentedPager.segmentedControl.selectionIndicatorColor = UIColor.black
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0), NSFontAttributeName: UIFont.init(name: "Baloo", size: 14.0) as Any]
        mXSegmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0), NSFontAttributeName: UIFont.init(name: "Baloo", size: 14.0) as Any]
        //mXSegmentedPager.segmentedControlPosition = .bottom
        mXSegmentedPager.dataSource = self
        mXSegmentedPager.delegate = self
        self.myscroolview.addSubview(mXSegmentedPager)
        
        
        
        
      
        
        
        
        
        
    }
    
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int
    {
        return 2
    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String
    {
        
        switch index {
        case 0:
            return "Related Videos"
        case 1:
            return "More Videos"
        default:
            break
        }
        return ""
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView
    {
        let label = UILabel()
        //label.text! = "Page #\(index)"
        // label.textAlignment = .Center
        //label.text = "Ashish"
        return label
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int)
    {
        switch index {
        case 0:
            ismore = true
            self.Mycollectionview.reloadData()
            //self.scrollviewheighltcontrant.constant = (CGFloat(self.moredataarray.count/2) * 141.0)
            //  mytableview.reloadData()
            print(index)
            
        case 1:
            ismore = false
            self.Mycollectionview.reloadData()
           // self.scrollviewheighltcontrant.constant = (CGFloat(self.recomdentdedataarray.count/2) * 141.0)
            //  mytableview.reloadData()
            print(index)
            
        default:
            break
        }
        
    }
    
  
    
    
    
    //MARK:collection View delegate method
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ismore {
            
            return self.moredataarray.count
        }
            
        else
        {
            return self.recomdentdedataarray.count
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
        Common.getRoundImage(imageView: cell.bannerimaheview, radius: 15.0)
        Common.getRounduiview(view: cell.cellview, radius: 15.0)
        Common.getRoundImage(imageView: cell.cellbottomimageview, radius: 15.0)
        Common.setuiimageviewdborderwidth(imageView: cell.bannerimaheview!, borderwidth: 2.0)
        Common.getshadowofviewcollection(myView: cell.cellview!)

        
        if ismore
        {
          cell.titilelabel.text = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        
             let time = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
            cell.uploaddatelabel.text = Common.convertvideoduration(videotime: time!)
            
            
            if(Common.isNotNull(object: (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
            {
            let url = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
            if(url.count>0)
            {
                let str = ((url.object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                cell.bannerimaheview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
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
        }
        else
        {
        
        cell.titilelabel.text = (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        
            
     let videotime = (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
            
       cell.uploaddatelabel.text = Common.convertvideoduration(videotime: videotime!)
            
            if(Common.isNotNull(object: (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
            {
            let url = (self.recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
            if(url.count>0)
            {
                let str = ((url.object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                cell.bannerimaheview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
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
 
         }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        self.setdataincontinuewatching()
      
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            
            self.videoPlayer = nil
        }
        soundaarray.removeAll()
        Common.callappanalytics()
        midroletime = 0.0
        skiptime = 0
        self.bHideControl = false
        self.singleTapped()
        Download_dic.removeAllObjects()
        fromdownload = "no"
        
        
       if(ismore)
       {
        print(moredataarray.object(at: indexPath.row))
        
        
         self.cat_id = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        
        let catdataarray = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        
         if(catdataarray.count == 0)
        {
           catid = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
        }
        else
        {
            
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            catid = ids
        }

        
        
        
     
        
        
        
         tilttext = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
         if(Common.isNotNull(object: (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
            self.descriptiontext = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        else
        {
            self.descriptiontext = ""
        }
        
        
        self.setvideodescription(titile: tilttext, like: "", des: descriptiontext, url:"")
        getplayerurl()
        self.getuserrelatedvideo()
        self.getmorevideo()
 
        }
        else
       {
        print(recomdentdedataarray.object(at: indexPath.row))
        
        
        self.cat_id = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        
        
        let catdataarray = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        
        if(catdataarray.count == 0)
        {
            catid = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
        }
        
        else
        
        {
        var ids = String()
        for i in 0..<catdataarray.count
        {
            
            let str = ((recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
            ids = ids + str + ","
            
        }
        ids = ids.substring(to: ids.index(before: ids.endIndex))
        catid = ids
        
        }
        
        
        tilttext = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        
        if(Common.isNotNull(object: (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
            self.descriptiontext = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        else
        {
            self.descriptiontext = ""
        }
        
         self.setvideodescription(titile: tilttext, like: "", des: descriptiontext, url:"")
        
        
        getplayerurl()
        self.getuserrelatedvideo()
        self.getmorevideo()

        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-8, height: 97)
    }
    
    
    
 
    
   //MARK:-Scrollview delegate method
    
     func scrollViewDidScroll(_ scrollView: UIScrollView)
     {
        print(scrollView.frame)
    }
    //MARK:-Taptofarword5sec
  
    
    @IBAction func Taptofarword5sec(_ sender: UIButton) {
        
   PlayNextvideoinmoresection()
        
        
        
        
//        let seconds : Int64 = Int64(playbackSlider.value + 5.0)
//        let targetTime:CMTime = CMTimeMake(seconds, 1)
//        print("seconds >>>",seconds)
//        self.videoPlayer!.seek(to: targetTime)
//        self.playbackSlider.value = Float(CGFloat(seconds))
//        self.bSlideBar = true
//        if self.videoPlayer!.rate == 0
//        {
//            self.videoPlayer?.play()
//        }
        
    }
    
    
    
    
    
    
    
    func PlayNextvideoinmoresection()
    {
        
        if(moredataarray.count == 0 )
        {
            EZAlertController.alert(title: "Can't Play , no videos in more section")
            return
        }
        
        
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
             self.videoPlayer = nil
        }
        
        Common.callappanalytics()
        midroletime = 0.0
        skiptime = 0
        self.bHideControl = false
        self.singleTapped()
        Download_dic.removeAllObjects()
        fromdownload = "no"
        
        
       
        
        if(ismore)
        {
            print(moredataarray.object(at: 0))
            
            
            self.cat_id = (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "id") as! String
            
            let catdataarray = (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "category_ids") as! NSArray
            
            var ids = String()
            if(catdataarray.count == 0)
            {
                ids = (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "category_id") as! String
            }
            else
            {
            for i in 0..<catdataarray.count
            {
                
                let str = ((moredataarray.object(at: 0) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
          
            }
            
            catid = ids
            tilttext = (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "title") as! String
            if(Common.isNotNull(object: (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "des") as AnyObject?))
            {
                self.descriptiontext = (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "des") as! String
            }
            else
            {
                self.descriptiontext = ""
            }
            
            
            self.setvideodescription(titile: tilttext, like: "", des: descriptiontext, url:"")
            getplayerurl()
            self.getuserrelatedvideo()
            self.getmorevideo()
            
        }
    }
    
    
    
    
    
    
    
    
    //MARK:-Taptobackword5sec
 
    @IBAction func Taptobackword5sec(_ sender: UIButton)
    {
        if(playbackSlider.value < 10.0)
        {
            
        }
        else
        {
            let seconds : Int64 = Int64(playbackSlider.value - 10.0)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            self.videoPlayer!.seek(to: targetTime)
            self.playbackSlider.value = Float(CGFloat(seconds))
            self.bSlideBar = true
            if self.videoPlayer!.rate == 0
            {
                self.videoPlayer?.play()
            }
        }
    }
    
    //MARK:-parseallsteme All Resoltion

    
    func parseallsteme(url:String)
    {
        
  
        
        if(!(Common.isNotNull(object: url as AnyObject?)) || (url == "") )
        {
            return
        }
        videoresoulationtypearray.removeAllObjects()
        videoresoulationurlarray.removeAllObjects()
        let typenadresolutionarray = NSMutableDictionary()
        
        let xStreamList = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList
        let count1 = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList.count
        for i in 0..<count1 {
            
            let str = (xStreamList?.xStreamInf(at: i).resolution.height)! as Float
            let str1 = "\(str.cleanValue)\("P")"
            print(xStreamList?.xStreamInf(at: i).m3u8URL())
            typenadresolutionarray.setValue((xStreamList?.xStreamInf(at: i).m3u8URL())!, forKey: str1)
        }
        print(typenadresolutionarray)
        
        
        let reverser = typenadresolutionarray.sorted(by: { (a, b) in (a.value as! String) < (b.value as! String) })
        
        
        for i in 0..<reverser.count {
            videoresoulationtypearray.add(reverser[i].key)
            videoresoulationurlarray.add(reverser[i].value)
        }
        
        print(videoresoulationtypearray)
        print(videoresoulationurlarray)
        videoresoulationtypearray.insert("Auto", at: 0)
        videoresoulationurlarray.insert(url, at: 0)
        
    }
    
    
    //MARK:-Action sheet resloution
   
    func downloadSheet1()
    {
  
        let alert = UIAlertController(title: "SETTING", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Quality", style: .default , handler:{ (UIAlertAction)in
            self.downloadSheet()
        }))
        if(soundaarray.count<=0)
        {
        soundaarray = (self.videoPlayer.currentItem?.tracks(type: .audio))! as [String]
        }
        if(soundaarray.count>0)
        {
        alert.addAction(UIAlertAction(title: "Language", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
             self.downloadsoundSheet()
        }))
        }
      
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
         self.present(alert, animated: true, completion: {
            print("completion block")
        })

    }
    
    
    
    
    
    func downloadsoundSheet()
    {
        
        print(soundaarray)
           soundactionSheet = UIActionSheet(title: "Language", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        
        for i in 0..<soundaarray.count {
            
            if(i == vertitualselectsoundindex) {
                soundactionSheet.addButton(withTitle: "\(soundaarray[i])\(" ✓")")
            }
            else
            {
                soundactionSheet.addButton(withTitle: soundaarray[i])
                
            }
 
         }
        
        soundactionSheet.show(in: view)
        
        
        
    }
    
    
    
    
    func downloadSheet()
    {
        
        let orderedSet = NSOrderedSet(object: videoresoulationtypearray)
        print(orderedSet.array)
        
        let set = NSSet(array: [videoresoulationtypearray.mutableCopy()])
        videoresoulationtypearray.removeAllObjects()
        let array1:NSMutableArray=NSMutableArray()
        array1.add(set.allObjects)
        videoresoulationtypearray = (((array1.object(at: 0) as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray)
        
        
        let set1 = NSSet(array: [videoresoulationurlarray.mutableCopy()])
        videoresoulationurlarray.removeAllObjects()
        let array2:NSMutableArray=NSMutableArray()
        array2.add(set1.allObjects)
        videoresoulationurlarray = (((array2.object(at: 0) as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray)
        
  
        let actionSheet = UIActionSheet(title: "Video Quality", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        
        for i in 0..<videoresoulationtypearray.count {
            
            if(i == vertitualselectresolutionindex) {
                actionSheet.addButton(withTitle: "\(videoresoulationtypearray.object(at: i) as! String)\(" ✓")")
            }
            else
            {
                actionSheet.addButton(withTitle: videoresoulationtypearray.object(at: i) as? String)

            }
            
        }
        
        
        actionSheet.show(in: view)
        
        
        
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print(buttonIndex)
        if(actionSheet == soundactionSheet)
        {
               if buttonIndex>0 {
                
                  Islangaugechange = true
                  if(!IsplayMaster)
                {
                self.playvideo(url: videoresoulationurlarray.object(at: 0) as! String)
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                    self.skiptimeinterval()
                      let success = self.videoPlayer.currentItem?.select(type: .audio, name: self.soundaarray[buttonIndex-1])
                })
                }
                else
                {
                    let success = self.videoPlayer.currentItem?.select(type: .audio, name: self.soundaarray[buttonIndex-1])
                    
                }
                 selectsoundindex = buttonIndex-1
                vertitualselectsoundindex = buttonIndex-1
                
             }
         }
        else
        {
        if buttonIndex>0 {
            
            vertitualselectresolutionindex = buttonIndex-1
            if(buttonIndex-1 == 0)
            {
             IsplayMaster = true
            }
            else
            {
                IsplayMaster = false
            }
            
            
            
            if(Islangaugechange)
            {
                self.playvideo(url: videoresoulationurlarray.object(at: 0) as! String)
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                    self.skiptimeinterval()
                    let success = self.videoPlayer.currentItem?.select(type: .audio, name: self.soundaarray[self.selectsoundindex])
                    
                    
                })
                
            }
            else
            {
              
                
                self.playvideo(url: videoresoulationurlarray.object(at: buttonIndex-1) as! String)
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                    self.skiptimeinterval()
                    
                })
                
            }
            
//            if(IsplayMaster)
//            {
//            self.playvideo(url: videoresoulationurlarray.object(at: buttonIndex-1) as! String)
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
//                 self.skiptimeinterval()
//                
//            })
//             }
//            else
//            {
//             
//                
//                self.playvideo(url: videoresoulationurlarray.object(at: 0) as! String)
//                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
//                    self.skiptimeinterval()
//                    let success = self.videoPlayer.currentItem?.select(type: .audio, name: self.soundaarray[self.selectsoundindex])
//                    
//                    
//                })
//                
//             }
           }
        }
    }
    
    
    
   
    func skiptimeinterval()
    {
        print("self.playerTime >>>",LoginCredentials.Contantplaytime)
        let seconds : Int64 = Int64(LoginCredentials.Contantplaytime)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
          let success = self.videoPlayer.currentItem?.select(type: .audio, name: soundaarray[selectsoundindex])
        print(success)
    }
    
    
    //MARK:-Taptosound

    @IBAction func Taptosound(_ sender: UIButton) {
   
        if (sender.currentImage?.isEqual(UIImage(named: "Unmute")))! {
            //do something here
            self.videoPlayer.isMuted = true
            sender.setImage(UIImage.init(named: "Mute"), for: .normal)
        }
        else
        {
            self.videoPlayer.isMuted = false
            sender.setImage(UIImage.init(named: "Unmute"), for: .normal)
        }
        
        
    }
    
    
    //MARK:-TaptoResolution

    @IBAction func TaptoResolution(_ sender: UIButton) {
        
        self.downloadSheet1()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func setvideoinwatchlist()
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            let asset = AVURLAsset(url: URL(string: Video_url)!)
            let duration: CMTime = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            print(durationTime)
            
            var parameters = [String:Any]()
            parameters = [
                "device": "ios",
                "content_id":cat_id,
                "c_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                "total_duration":durationTime,
                "duration":"0"
                
            ]
            print(parameters)
            var url = String(format: "%@%@", LoginCredentials.watchdurationapi,Apptoken)
            url = url.trimmingCharacters(in: .whitespaces)

            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    // let Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    // print(Catdata_dict)
                    
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
            
        }
        else
        {
            
        }
    }
    
    
    
    
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
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        self.view.frame.origin.y =  -30
     }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
}
extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
