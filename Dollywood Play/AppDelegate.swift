

//
//  AppDelegate.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 25/05/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import GoogleSignIn
import AFNetworking
import UserNotifications
import SystemConfiguration
import CryptoSwift
import CoreTelephony
import OneSignal



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
 


    fileprivate func createMenuView() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier:
            "SplashViewController") as! SplashViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
         leftViewController.HomeViewController = nvc
        let slideMenuController =   ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
         slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
      
    }

    
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
         GIDSignIn.sharedInstance().clientID = "545944488954-p1lhodgq73m2nplglgc9ts7th2tceo82.apps.googleusercontent.com"
         /////Set UDID
        let uuid = UUID().uuidString
        if UserDefaults.standard.value(forKey: "UUID") as? String != nil {
            print("already uuid")
        }
        else
        {
            UserDefaults.standard.set(uuid as String, forKey: "UUID")
        }
        
        
     /////SEt Notification 
        
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            application.registerForRemoteNotifications()
        } else {
            if #available(iOS 9, *) {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
            }
            // Fallback on earlier versions
        }
        application.applicationIconBadgeNumber = 0
        NotificationCenter.default.addObserver(self, selector: #selector(appanalytics), name: NSNotification.Name(rawValue: "useranalytics"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotomyprofile), name: NSNotification.Name(rawValue: "gotomyprofilescene"), object: nil)
        

        
        ///////////REGISTER ONE SINGLE NOTIFICATION?//////
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "c8619714-a2f7-4288-99e2-9489effee7f3",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        self.createMenuView()
        self.checkContantUpdate()
        self.Getmasterurl()
        return true
    }
   
    
    
    
    
    
    
    func gotomyprofile()
    {
        

        
        
        let MyAccountViewControllernew: UIViewController!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myProfileViewController = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        MyAccountViewControllernew = UINavigationController(rootViewController: myProfileViewController)
        LoginCredentials.faveprofileorother = "Myaccount"
   self.window?.rootViewController?.slideMenuController()?.changeMainViewController(MyAccountViewControllernew, close: true)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
//         let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
//        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
//        UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
//        leftViewController.HomeViewController = nvc
//        let slideMenuController = ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
//        slideMenuController.automaticallyAdjustsScrollViewInsets = true
//        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
//        self.window?.rootViewController = slideMenuController
//        self.window?.makeKeyAndVisible()
        
        
    }
    
    
    /////Notification Delegate
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString >>",deviceTokenString)
        LoginCredentials.DiviceToken = deviceTokenString
        
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        LoginCredentials.DiviceToken = ""

        
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if application.applicationState == .active {
            //opened from a push notification when the app was on background
        }
        else
        {
            
        }
        let aps = userInfo["aps"] as! [String: AnyObject]
        print(aps)
    }

    
    
    
    
    
    ///////getMasterurl Update
    
    func Getmasterurl()
    {
 
        var url = String(format: "%@%@/device/ios",MaterBaseUrl,Apptoken)
        print(url)
        url = url.trimmingCharacters(in: .whitespaces)
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
                    
                    
                    let Catdata_dict = dict.value(forKey: "result") as! NSDictionary
                    print(Catdata_dict)
                    
                    ////////////////////////////////addapi 1  //////////////////////////
                    let addapi = Catdata_dict.value(forKey: "add") as! String
                    let addapiArr : [String] = addapi.components(separatedBy: "|,")
                    
                    LoginCredentials.AddAPi = addapiArr[1]
                    if((addapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAddAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAddAPi = false
                    }
                    
                    ////////////////////////////////addetail  2 /  /////////////////////////
                    let addetailapi = Catdata_dict.value(forKey: "addetail") as! String
                    let addetailapiArr : [String] = addetailapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Addetailapi = addetailapiArr[1]
                    if((addetailapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAddetailapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAddetailapi = false
                    }
                    
                    ////////////////////////////////analytics  3//////////////////////////
                    let analyticslapi = Catdata_dict.value(forKey: "analytics") as! String
                    let analyticslapiArr : [String] = analyticslapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Analyticsappapi = analyticslapiArr[1]
                    if((analyticslapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAnalyticsappapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAnalyticsappapi = false
                    }
                    
                    
                    ////////////////////////////////autosuggest  4//////////////////////////
                    let autosuggestapi = Catdata_dict.value(forKey: "autosuggest") as! String
                    let autosuggestapiArr : [String] = autosuggestapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Autosuggestapi = autosuggestapiArr[1]
                    if((autosuggestapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAutosuggestapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAutosuggestapi = false
                    }
                    
                    
                    
                    ////////////////////////////////catlist  5  //////////////////////////
                    let catlistapi = Catdata_dict.value(forKey: "catlist") as! String
                    let catlistapiArr : [String] = catlistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.catlistapi = catlistapiArr[1]
                    if((catlistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.Isencriptcatlistapi = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptcatlistapi = false
                    }
                    
                    
                    ////////////////////////////////channel_list  6   //////////////////////////
                    let channellistapi = Catdata_dict.value(forKey: "channel_list") as! String
                    let channellistapiArr : [String] = channellistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Channellistapi = channellistapiArr[1]
                    if((channellistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptChannellistapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptChannellistapi = false
                    }
                    
                    
                    ////////////////////////////////comment_add   7  //////////////////////////
                    let commentaddapi = Catdata_dict.value(forKey: "comment_add") as! String
                    let commentaddapiArr : [String] = commentaddapi.components(separatedBy: "|,")
                    
                    LoginCredentials.CommentaddAPi = commentaddapiArr[1]
                    if((commentaddapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptCommentaddAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptCommentaddAPi = false
                    }
                    
                    ////////////////////////////////commentlist  8  //////////////////////////
                    let commentlistapi = Catdata_dict.value(forKey: "comment_list") as! String
                    let commentlistapiArr : [String] = commentlistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Commentlistapi = commentlistapiArr[1]
                    if((commentlistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptCommentlistapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptCommentlistapi = false
                    }
                    
                    ////////////////////////////////detail   9   //////////////////////////
                    let detailapi = Catdata_dict.value(forKey: "detail") as! String
                    let detailapiArr : [String] = detailapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Detailapi = detailapiArr[1]
                    if((detailapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptDetailapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptDetailapi = false
                    }
                    
                    
                    ////////////////////////////////deviceinfo   10  //////////////////////////
                    let deviceinfoapi = Catdata_dict.value(forKey: "deviceinfo") as! String
                    let deviceinfoapiArr : [String] = deviceinfoapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Deviceinfoapi = deviceinfoapiArr[1]
                    if((deviceinfoapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptDeviceinfoapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptDeviceinfoapi = false
                    }
                    
                    
                    ////////////////////////////////dislike   11   //////////////////////////
                    let dislikeapi = Catdata_dict.value(forKey: "dislike") as! String
                    let dislikeapiArr : [String] = dislikeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Dislikeapi = dislikeapiArr[1]
                    if((dislikeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptDislikeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptDislikeapi = false
                    }
                    
                    
                    ////////////////////////////////edit    12   //////////////////////////
                    let editapi = Catdata_dict.value(forKey: "edit") as! String
                    let editapiArr : [String] = editapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Editapi = editapiArr[1]
                    if((editapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptEditapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptEditapi = false
                    }
                    
                    ////////////////////////////////forgot   13   //////////////////////////
                    let forgotapi = Catdata_dict.value(forKey: "forgot") as! String
                    let forgotapiArr : [String] = forgotapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Forgotapi = forgotapiArr[1]
                    if((forgotapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptForgotapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptForgotapi = false
                    }
                    
                    ////////////////////////////////home    13    //////////////////////////
                    let homeapi = Catdata_dict.value(forKey: "home") as! String
                    let homeapiArr : [String] = homeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Homeapi = homeapiArr[1]
                    if((homeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptHomeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptHomeapi = false
                    }
                    
                    
                    
                    ////////////////////////////////like    14    //////////////////////////
                    let likeapi = Catdata_dict.value(forKey: "like") as! String
                    let likeapiArr : [String] = likeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Likeapi = likeapiArr[1]
                    if((likeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptLikeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptLikeapi = false
                    }
                    
                    
                    ////////////////////////////////list   15    //////////////////////////
                    let listapi = Catdata_dict.value(forKey: "list") as! String
                    let listapiArr : [String] = listapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Listapi = listapiArr[1]
                    if((listapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptListapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptListapi = false
                    }
                    
                    
                    ////////////////////////////////login  16   //////////////////////////
                    let loginapi = Catdata_dict.value(forKey: "login") as! String
                    let loginapiArr : [String] = loginapi.components(separatedBy: "|,")
                    
                    LoginCredentials.LoginAPI = loginapiArr[1]
                    if((loginapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptLoginAPI = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptLoginAPI = false
                    }
                    
                    ////////////////////////////////menu   17   //////////////////////////
                    let menuapi = Catdata_dict.value(forKey: "menu") as! String
                    let menuapiArr : [String] = menuapi.components(separatedBy: "|,")
                    
                    LoginCredentials.MenuAPi = menuapiArr[1]
                    if((menuapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptMenuAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptMenuAPi = false
                    }
                    
                    
                    ////////////////////////////////otp_generate  18    //////////////////////////
                    let otpgenerateapi = Catdata_dict.value(forKey: "otp_generate") as! String
                    let otpgenerateapiArr : [String] = otpgenerateapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Otpgenerateapi = otpgenerateapiArr[1]
                    if((otpgenerateapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptOtpgenerateapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptOtpgenerateapi = false
                    }
                    
                    ////////////////////////////////playlist    19   //////////////////////////
                    let playlistapi = Catdata_dict.value(forKey: "playlist") as! String
                    let playlistapiArr : [String] = playlistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Playlistapi = playlistapiArr[1]
                    if((playlistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptPlaylistapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptPlaylistapi = false
                    }
                    
                    
                    ////////////////////////////////rating     20    //////////////////////////
                    let ratingapi = Catdata_dict.value(forKey: "rating") as! String
                    let ratingapiArr : [String] = ratingapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Ratingapi = ratingapiArr[1]
                    if((ratingapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptRatingapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptRatingapi = false
                    }
                    
                    ////////////////////////////////recomended    21   //////////////////////////
                    let recomendedapi = Catdata_dict.value(forKey: "recomended") as! String
                    let recomendedapiArr : [String] = recomendedapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Recomendedapi = recomendedapiArr[1]
                    if((recomendedapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptRecomendedapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptRecomendedapi = false
                    }
                    
                    ////////////////////////////////search     22     //////////////////////////
                    let searchapi = Catdata_dict.value(forKey: "search") as! String
                    let searchapiArr : [String] = searchapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Searchapi = searchapiArr[1]
                    if((searchapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptSearchapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptSearchapi = false
                    }
                    
                    ////////////////////////////////social     23     //////////////////////////
                    let socialapi = Catdata_dict.value(forKey: "social") as! String
                    let socialapiArr : [String] = socialapi.components(separatedBy: "|,")
                    
                    LoginCredentials.SocialAPI = socialapiArr[1]
                    if((socialapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptSocialAPI = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptSocialAPI = false
                    }
                    
                    
                    
                    ////////////////////////////////subscribe     24     //////////////////////////
                    let subscribeapi = Catdata_dict.value(forKey: "subscribe") as! String
                    let subscribeapiArr : [String] = subscribeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Subscribeapi = subscribeapiArr[1]
                    if((subscribeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptSubscribeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptSubscribeapi = false
                    }
                    
                    ////////////////////////////////unsubscribe     25      //////////////////////////
                    let unsubscribeapi = Catdata_dict.value(forKey: "unsubscribe") as! String
                    let unsubscribeapiArr : [String] = unsubscribeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Unsubscribeapi = unsubscribeapiArr[1]
                    if((unsubscribeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUnsubscribeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUnsubscribeapi = false
                    }
                    
                    ////////////////////////////////udatedevice      26    //////////////////////////
                    let udatedeviceapi = Catdata_dict.value(forKey: "udatedevice") as! String
                    let udatedeviceapiArr : [String] = udatedeviceapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Udatedeviceapi = udatedeviceapiArr[1]
                    if((udatedeviceapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUdatedeviceapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUdatedeviceapi = false
                    }
                    
                    ////////////////////////////////user_behavior     27     //////////////////////////
                    let userbehaviorapi = Catdata_dict.value(forKey: "user_behavior") as! String
                    let userbehaviorapiArr : [String] = userbehaviorapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Userbehaviorapi = userbehaviorapiArr[1]
                    if((userbehaviorapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUserbehaviorapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUserbehaviorapi = false
                    }
                    
                    ////////////////////////////////userrelated    28     //////////////////////////
                    let userrelatedapi = Catdata_dict.value(forKey: "userrelated") as! String
                    let userrelatedapiArr : [String] = userrelatedapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Userrelatedapi = userrelatedapiArr[1]
                    if((userrelatedapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUserrelatedapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUserrelatedapi = false
                    }
                    
                    
                    ////////////////////////////////verify_otp    29     //////////////////////////
                    let verifyotpapi = Catdata_dict.value(forKey: "verify_otp") as! String
                    let verifyotpapiArr : [String] = verifyotpapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Verifyotpapi = verifyotpapiArr[1]
                    if((verifyotpapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptVerifyotpapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptVerifyotpapi = false
                    }
                    
                    ////////////////////////////////version    30     //////////////////////////
                    let versionapi = Catdata_dict.value(forKey: "version") as! String
                    let versionapiArr : [String] = versionapi.components(separatedBy: "|,")
                    
                    LoginCredentials.AppVersionAPi = versionapiArr[1]
                    if((versionapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAppVersionAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAppVersionAPi = false
                    }
                    
                    ////////////////////////////////version_check      31    //////////////////////////
                    let versioncheckapi = Catdata_dict.value(forKey: "version_check") as! String
                    let versioncheckapiArr : [String] = versioncheckapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Versioncheckapi = versioncheckapiArr[1]
                    if((versioncheckapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptVersioncheckapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptVersioncheckapi = false
                    }
                    
                    ////////////////////////////////watchduration     32         //////////////////////////
                    let watchdurationapi = Catdata_dict.value(forKey: "watchduration") as! String
                    let watchdurationapiArr : [String] = watchdurationapi.components(separatedBy: "|,")
                    
                    LoginCredentials.watchdurationapi = watchdurationapiArr[1]
                    if((watchdurationapiArr[0] as String) == "0")
                    {
                        LoginCredentials.Isencriptwatchdurationapi = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptwatchdurationapi = false
                    }
                    
                      ////////////////////////////////abuse     33         //////////////////////////
                    let abuseapi = Catdata_dict.value(forKey: "genre") as! String
                    let abuseapiArr : [String] = abuseapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Zonarapi = abuseapiArr[1]
                    if((abuseapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptZonarapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptZonarapi = false
                    }
                    

                    
                    ////////////////////////////////Fauvout     33         //////////////////////////
                    let fauvoutapi = Catdata_dict.value(forKey: "favorite") as! String
                    let fauvoutapiArr : [String] = fauvoutapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Favrioutapi = fauvoutapiArr[1]
                    if((fauvoutapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptFavrioutapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptFavrioutapi = false
                    }
                    
                    
                    ////////////////////////////////contact_us    33         //////////////////////////
                    let contactusapi = Catdata_dict.value(forKey: "contact_us") as! String
                    let contactusapiArr : [String] = contactusapi.components(separatedBy: "|,")
                    LoginCredentials.ContactUsapi = contactusapiArr[1]
                    
                    
                    let termsapi = Catdata_dict.value(forKey: "pages") as! String
                    let termsapiArr : [String] = termsapi.components(separatedBy: "|,")
                    LoginCredentials.Termsanduse = "\(termsapiArr[1])\("type=tc&token=")\(Apptoken)"
                    
                    
                    
                    ////////////////////////////////Fauvout     33         //////////////////////////
                    let privacyPlociyapi = Catdata_dict.value(forKey: "pages") as! String
                    let privacyPlociyapiArr : [String] = privacyPlociyapi.components(separatedBy: "|,")
                    LoginCredentials.Privacypolcy = "\(privacyPlociyapiArr[1])\("type=privacy&token=")\(Apptoken)"
                    
                   
                    
                    ////////////////////////////////Fauvout     33         //////////////////////////
                    let Aboutapi = Catdata_dict.value(forKey: "pages") as! String
                    let AboutapiArr : [String] = Aboutapi.components(separatedBy: "|,")
                    LoginCredentials.About = "\(AboutapiArr[1])\("type=about&token=")\(Apptoken)"
                    
                    
                    
                    
                    ////////////////////////////////subscriptioncreatordereapi     34         //////////////////////////
                    let subscriptioncreatordereapi = Catdata_dict.value(forKey: "subs_create_order") as! String
                    let subscriptioncreatordereapiArr : [String] = subscriptioncreatordereapi.components(separatedBy: "|,")
                    LoginCredentials.Subscriptioncreatordereapi = subscriptioncreatordereapiArr[1]
                    
                
                    
                    ////////////////////////////////Subscriptionpakegelistapi     34         //////////////////////////
                    let subscriptionpakegelistapi = Catdata_dict.value(forKey: "package_list") as! String
                    let subscriptionpakegelistapiArr : [String] = subscriptionpakegelistapi.components(separatedBy: "|,")
                    LoginCredentials.Subscriptionpakegelistapi = subscriptionpakegelistapiArr[1]
                    
                    
                    
                    
                    ////////////////////////////////Subscriptioncompleteorderapi     34         //////////////////////////
                    let subscriptioncompleteorderapi = Catdata_dict.value(forKey: "subs_complete_order") as! String
                    let subscriptioncompleteorderapiArr : [String] = subscriptioncompleteorderapi.components(separatedBy: "|,")
                    LoginCredentials.Subscriptioncompleteorderapi = subscriptioncompleteorderapiArr[1]
                    
                    
                    
                    
//                    ////////////////////////////////t_c     33         //////////////////////////
//                    let termsapi = Catdata_dict.value(forKey: "t_c") as! String
//                    let termsapiArr : [String] = termsapi.components(separatedBy: "|,")
//                    LoginCredentials.Termsanduse = termsapiArr[1]
//
//
//
//                    ////////////////////////////////privacy_policy     34         //////////////////////////
//                    let privacyPlociyapi = Catdata_dict.value(forKey: "privacy_policy") as! String
//                    let privacyPlociyapiArr : [String] = privacyPlociyapi.components(separatedBy: "|,")
//                    LoginCredentials.Privacypolcy = privacyPlociyapiArr[1]
                    
                   
                    
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    
    
   
    
    

    
    
    ///////Check Contant Update

    func checkContantUpdate()
    {
   
        
             var url = String(format: "%@%@/device/ios", LoginCredentials.AppVersionAPi,Apptoken)
             url = url.trimmingCharacters(in: .whitespaces)
             let manager = AFHTTPSessionManager()
            
            manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    let number = dict.value(forKey: "code") as! NSNumber
                    if(number == 0)
                    {
                      // self.createMenuView()
                    }
                    else
                    {
      
                        var Catdata_dict = NSMutableDictionary()
                        if(LoginCredentials.IsencriptAppVersionAPi)
                        {
                            Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        }
                        else
                        {
                            Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                        }
                        
        
                  
                     if((LoginCredentials.Contentversion == Catdata_dict.value(forKey: "content_version") as! String) && (LoginCredentials.Categoryversion == Catdata_dict.value(forKey: "category_version") as! String) && (LoginCredentials.Dashversion == Catdata_dict.value(forKey: "dash_version") as! String) && (LoginCredentials.Menuversion == Catdata_dict.value(forKey: "menu_version") as! String))
                     {
                        // self.createMenuView()
                        
                        }
                        else
                     {
                        
                  LoginCredentials.Contentversion = Catdata_dict.value(forKey: "content_version") as! String
                   LoginCredentials.Categoryversion = Catdata_dict.value(forKey: "category_version") as! String
                   LoginCredentials.Dashversion = Catdata_dict.value(forKey: "dash_version") as! String
                   LoginCredentials.Menuversion = Catdata_dict.value(forKey: "menu_version") as! String
                        self.deletealldatabase()
                        //  self.createMenuView()
                        
                         }
                    }
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
            
            
        }
    
    
    

    func deletealldatabase()
    {
       
        
        dataBase.deletedataentity(entityname: "Sidemenudata")
        dataBase.deletedataentity(entityname: "Homedata")
        dataBase.deletedataentity(entityname: "Slidermenu")
        dataBase.deletedataentity(entityname: "Catlistdata")
      }
    
    
    
    
  
    
   /////appanalytics APi
    
    func appanalytics()
    {
        print("called for App analytics")
       
        
        let netInfo:CTTelephonyNetworkInfo=CTTelephonyNetworkInfo()
        let carrier = netInfo.subscriberCellularProvider
        let strDeviceName=UIDevice.current.model
        let strResolution=String(format: "%.f*%.f", self.window!.frame.size.width, (self.window?.frame.size.height)!)
        
        // Get carrier name
        let carrierName = carrier?.carrierName
        let systemVersion=UIDevice.current.systemVersion
        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        
        var Pushtoken  = String()
        
        if(!Common.isNotNull(object: UserDefaults.standard.value(forKey: "tokenID") as AnyObject?))
        {
            Pushtoken = ""
        }
        else
        {
            Pushtoken = UserDefaults.standard.value(forKey: "tokenID") as! String
        }
        
        
        var networkname =  String()
        
        if(!Common.isNotNull(object: carrier?.carrierName as AnyObject?))
        {
            networkname = ""
        }
        else
        {
            networkname = (carrier?.carrierName)! as String
        }
        
        
        print(Common.getnetworktype())
        
        
        let dictionaryOtherDetail: NSDictionary = [
            "os_version" : systemVersion,
            "network_type" : Common.getnetworktype(),
            "network_provider" : networkname,
            "app_version" : appversion!
        ]
        let devicedetailss: NSDictionary = [
            "make_model" : Common.getModelname(),
            "os" : "ios",
            "screen_resolution" : strResolution,
            "device_type" : "app",
            "platform" : "iOS",
            "device_unique_id" : UserDefaults.standard.value(forKey: "UUID") as! String,//token! as! String,
            "push_device_token" :  Pushtoken//token! as! String
        ]
         var json = [String:Any]()
        if(Common.Islogin())
        {
           
            
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
           json = ["device":"ios","u_id":(dict.value(forKey: "id") as! NSNumber).stringValue,"c_id":LoginCredentials.Videoid ,"type": "2","buff_d":"0","dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),"dd":Common.convertdictinyijasondata(data: devicedetailss),"pd":LoginCredentials.VideoPlayingtime,"token":Apptoken]
        }
        else
        {
          json = ["device":"ios","u_id":"","c_id":LoginCredentials.Videoid ,"type": "2","buff_d":"0","dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),"dd":Common.convertdictinyijasondata(data: devicedetailss),"pd":LoginCredentials.VideoPlayingtime,"token":Apptoken]   
        }
            print("App analytics json >>",json)
            
        var url = String(format: "%@%@", LoginCredentials.Analyticsappapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
         manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }

        
      
    }

    
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
    return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url as URL!,
                                                                                                                                                                                    sourceApplication: sourceApplication,
                                                                                                                                                                                                      annotation: annotation)
        
        
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return self.orientationLock
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        //Common.stopHeartbeat()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        
  
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
       // Common.stopHeartbeat()
        self.saveContext()
    }

    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Dollywood_Play")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

