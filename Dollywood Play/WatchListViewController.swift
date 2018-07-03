//
//  WatchListViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 08/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class WatchListViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet var mycollectionview: UICollectionView!
    @IBOutlet var mytabelview: UITableView!
    var dataarray = NSArray()
    var display_offset = String()


    override func viewDidLoad() {
        super.viewDidLoad()
        display_offset = "0"
         self.mycollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if(Common.Islogin())
        {
            self.Getwatchlist()
        }
        else
        {
            self.dataarray = NSArray()
            self.mycollectionview.reloadData()
            Common.Showloginalert(view: self, text: "Please login see your watchlist")

         }

    }
    
    
    
    func Getwatchlist()
    {
        Common.startloder(view: self.view)
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
//   "type": "watching"
        let parameters = [
            "device": "ios",
            "user_id": (dict.value(forKey: "id") as! NSNumber).stringValue,
             "display_limit" : "100",
             "type":"favorite"
        ]
       // var url = String(format: "%@%@/device/ios/user_id/%@/max_counter/20/type/liked/current_offset/%@", LoginCredentials.Userrelatedapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue,display_offset)
        
         var url = String(format: "%@%@/device/ios/current_version/0.0/max_counter/100/current_offset/%@/user_id/%@/type/liked", LoginCredentials.Userrelatedapi,Apptoken,display_offset,(dict.value(forKey: "id") as! NSNumber).stringValue)
        
        
        if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
        {
         url = String(format: "%@%@/device/ios/current_version/0.0/max_counter/100/current_offset/%@/user_id/%@/type/liked/age_group/%@", LoginCredentials.Userrelatedapi,Apptoken,display_offset,(dict.value(forKey: "id") as! NSNumber).stringValue,LoginCredentials.Agegroup)
        }
        
        url = url.trimmingCharacters(in: .whitespaces)

        let manager = AFHTTPSessionManager()
        
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                
                Common.stoploder(view: self.view)

                if let _ = dict.value(forKey: "code")
                {
                    if(dict.value(forKey: "code") as! NSNumber == 0)
                    {
                        return
                    }
                }
                
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptUserrelatedapi)
                {
                    Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    
                }
                print(Catdata_dict)
                self.dataarray = Catdata_dict.value(forKey: "content") as! NSArray
                 if(self.dataarray.count == 0)
                {
                    EZAlertController.alert(title: "No result found")
                }
                
                //self.mytabelview.reloadData()
                self.mycollectionview.reloadData()
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
            EZAlertController.alert(title: error.localizedDescription)

        }
        
    }

    @IBAction func Taptomenu(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataarray.count
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
        
        cell.titlelabel.text = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        
        
        if Common.isNotNull(object: ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as AnyObject)
        {
            cell.titletypwlabel.text = ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as? String
        }
        else
        {
            cell.titletypwlabel.text = ""
        }
        
        var discriptiontext = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cell.desciptionlabel.text = discriptiontext
        let url = ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String
        cell.imageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
        let videotime = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if(Common.Islogin())
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            playerViewController.Video_url = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String
            if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
            {
            playerViewController.descriptiontext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            }
            playerViewController.liketext =  ""
            if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as AnyObject?))
            {
            playerViewController.tilttext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            }
            playerViewController.Download_dic = (dataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            playerViewController.fromdownload = "no"
            
            if Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
                
                playerViewController.downloadVideo_url = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as! String
                
            }
            else
            {
                playerViewController.downloadVideo_url = ""
            }
            
            
            var ids = String()
            for i in 0..<((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
            {
                
                
                let str = ((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
            playerViewController.cat_id = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            
            
            
            if(Common.Islogin())
            {
                
                self.navigationController?.pushViewController(playerViewController, animated: true)

//
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
//
//
//                }
            }
            else
            {
                Common.Showloginalert(view: self, text: "Please Login to watch Video")
            }
            
            
            
         //   self.navigationController?.pushViewController(playerViewController, animated: true)
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to watch video")

         }
        
    }
    

    //MARK:collection View delegate method
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.dataarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
       // cell.layer.borderWidth = 0.5
      //  cell.layer.borderColor = UIColor.white.cgColor
       // cell.clipsToBounds = true
        Common.getRoundImage(imageView: cell.bannerimaheview, radius: 15.0)
        Common.getRounduiview(view: cell.cellview, radius: 15.0)
         Common.getRoundImage(imageView: cell.cellbottomimageview, radius: 15.0)
        Common.setuiimageviewdborderwidth(imageView: cell.bannerimaheview!, borderwidth: 2.0)
        Common.getshadowofviewcollection(myView: cell.cellview!)
        if(Common.isNotNull(object: (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject)) {
        let url = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
        
        
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
        cell.titilelabel.text = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
         let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let videotime = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
        cell.uploaddatelabel.text = Common.convertvideoduration(videotime: videotime!)
         return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
        playerViewController.descriptiontext =  (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        
        if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as AnyObject?))
        {
        playerViewController.tilttext =   (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        }
        playerViewController.fromdownload = "no"
        
        
        let catdataarray = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        if(catdataarray.count == 0)
        {
            playerViewController.catid = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
        }
        else
        {
            
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
        }
        
        
        playerViewController.cat_id = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        
        
        if(Common.Islogin())
        {
            
            
            self.navigationController?.pushViewController(playerViewController, animated: true)

//
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width/2-10, height: 100)
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

}
