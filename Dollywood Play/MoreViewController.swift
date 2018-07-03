//
//  MoreViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 21/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking
import KRPullLoader


class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var nolableheader: UILabel!
    @IBOutlet var nolabledescription: UILabel!
    @IBOutlet var Morecollectionview: UICollectionView!
    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet var Collectiontopsonstrant: NSLayoutConstraint!
    
     var id = String()
     var display_offset = String()
     var headertext = String()
     var headerimageurl = String()
     var dataarray = NSMutableArray()
     var moreorzoner = String()
     let loadMoreView = KRPullLoadView()
     var Isfromhome = Bool()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display_offset = "0"
        
        if(Isfromhome)
        {
        Collectiontopsonstrant.constant = 5.0
        }
        else
        {
            print("Zonar data")
         Collectiontopsonstrant.constant = 5.0
        }
        
     self.Morecollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        print(id)
        print(headertext)
        headerlabel.text = headertext
      
        Common.startloder(view: self.view)
        getdata()
        self.showhiddendata(text: headertext)

        
      }
    

    @IBAction func taptosearch(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
 
    

     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        getdata()
    }
  
    
    func showhiddendata(text:String)
    {
        switch text {
        case "Backstage Pass":
           nolableheader.text = backstageheader.uppercased()
           nolabledescription.text = backstagedes
            break
         case "Live@Nocturnal":
            nolableheader.text = livenocturnalheader.uppercased()
            nolabledescription.text = livenocturnaldes
            break
        case "Kick Out The Jams":
            nolableheader.text = kickoutjamsheader.uppercased()
            nolabledescription.text = kickoutjamsdes
            break
        case "Motaimadi Muzak":
            nolableheader.text = muzakheader.uppercased()
            nolabledescription.text = muzakdes
            break
        case "Sounds & Stories":
            nolableheader.text = soundstoriesheader.uppercased()
            nolabledescription.text = soundstoriesdes
            break
        case "Revamps":
            nolableheader.text = revampsheader.uppercased()
            nolabledescription.text = revampsdes
            break
        case "Two to Tango":
            nolableheader.text = twotangoheader.uppercased()
            nolabledescription.text = twotangodes
            break
        case "Inside A Song":
            nolableheader.text = insideasongheader.uppercased()
            nolabledescription.text = insideasongdes
            break
        case "YoSee":
            nolableheader.text = yoseeheader.uppercased()
            nolabledescription.text = yoseedes
            break
        case "Must Watch":
            nolableheader.text = mustwatchheader.uppercased()
            nolabledescription.text = mustwatchdes
            break
        case "Film Room":
            nolableheader.text = filmroomheader.uppercased()
            nolabledescription.text = filmroomdes
            break
        case "May Day":
            nolableheader.text = maydayheader.uppercased()
            nolabledescription.text = maydaydes
            break
        case "August Rush":
            nolableheader.text = augustrushheader.uppercased()
            nolabledescription.text = augustrushdes
            break
        case "Come September":
            nolableheader.text = comeseptemberheader.uppercased()
            nolabledescription.text = comeseptemberdes
            break
        case "Red October":
            nolableheader.text = redoctoberheader.uppercased()
            nolabledescription.text = redoctoberdes
            break
        case "Comedy & Satire":
            nolableheader.text = comedystireheader.uppercased()
            nolabledescription.text = comedystiredes
            break
        case "Stand-Up":
            nolableheader.text = standupheader.uppercased()
            nolabledescription.text = standupdes
            break
        default:
            break
        }
    }
    
    
    
    
    func getdata()
    {
       
        
     // http://development.multitvsolution.com/automatorapi/v5/content/list/token/59ed85d805d3d/device/android/cat_type/video/max_counter/10/current_offset/0/genre_id/339
       
        var parameters =  [String : Any]()
         var url  = String()
        if(Isfromhome)
        {
          parameters = [
            "device": "ios",
            "cat_id": id,
            "current_offset":display_offset,
            "max_counter":"20"
            ] as [String : Any]
        
            
            
         // url = String(format: "%@%@/device/ios/cat_id/%@/content_count/20/display_limit/20/display_offset/%@", LoginCredentials.Listapi,Apptoken,id,display_offset)
            
            
         url = String(format: "%@%@/device/ios/current_offset/%@/max_counter/100/cat_id/%@", LoginCredentials.Listapi,Apptoken,display_offset,id)
            
            if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
            {
                url = String(format: "%@%@/device/ios/current_offset/%@/max_counter/100/cat_id/%@/age_group/%@", LoginCredentials.Listapi,Apptoken,display_offset,id,LoginCredentials.Agegroup)
            }
            
            
        }
        else
        {
            parameters = [
                "device": "ios",
                "genre_id": id,
                "current_offset":display_offset,
                "max_counter":"20",
                "cat_type":"video"
                  ] as [String : Any]
            
            
            // url = String(format: "%@%@/device/ios/genre_id/%@/content_count/20/display_limit/20/display_offset/%@", LoginCredentials.Listapi,Apptoken,id,display_offset)
              url = String(format: "%@%@/device/ios/current_offset/%@/max_counter/100/genre_id/%@", LoginCredentials.Listapi,Apptoken,display_offset,id)
            
            if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
            {
                url = String(format: "%@%@/device/ios/current_offset/%@/max_counter/100/genre_id/%@/age_group/%@", LoginCredentials.Listapi,Apptoken,display_offset,id,LoginCredentials.Agegroup)
            }
            
   
        }
        url = url.trimmingCharacters(in: .whitespaces)

        print(parameters)
        print(url)
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
                        EZAlertController.alert(title: "No result found.")
                        return
                    }
                }
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
                
                
                let array = Catdata_dict.value(forKey: "content") as! NSArray
                for i in 0..<array.count {
                    self.dataarray.add(array.object(at: i) as! NSDictionary)
                }
                
                
                
//                if(self.Isfromhome)
//                {
//                     let array = Catdata_dict.value(forKey: "content") as! NSArray
//                    for i in 0..<array.count {
//                        self.dataarray.add(array.object(at: i) as! NSDictionary)
//                    }
//                   
//                }
//                else
//                {
//
//                    
//            let array = Catdata_dict.value(forKey: "feature") as! NSArray
//           for i in 0..<array.count {
//            self.dataarray.add(array.object(at: i) as! NSDictionary)
//                }
//                }
            self.display_offset =   (Catdata_dict.value(forKey: "offset") as! NSNumber).stringValue
             if(self.dataarray.count==0)
             {
               self.nolableheader.isHidden = false
               self.nolabledescription.isHidden = false
                print(self.nolableheader.text)
                print(self.nolabledescription.text)
                
                }
                else
             {
                self.nolableheader.isHidden = true
                self.nolabledescription.isHidden = true
                }
                
           self.Morecollectionview.reloadData()
          // self.mytableview.reloadData()
        
              }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
             EZAlertController.alert(title: error.localizedDescription)
            Common.stoploder(view: self.view)
        }
   
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
            
            
            if Common.isNotNull(object: ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "genre") as AnyObject))
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
        let url = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
        if(url.count>0)
        {
            let str = ((url.object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
           cell.imageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
        }
        else
        {
           cell.imageview.image = #imageLiteral(resourceName: "Placehoder")
        }
        
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
        playerViewController.liketext = ""
            
            if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as AnyObject?))
            {
        playerViewController.tilttext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        }
            playerViewController.fromdownload = "no"

            playerViewController.Download_dic = (dataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
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
       //   self.navigationController?.pushViewController(playerViewController, animated: true)
            
            
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
//
//
//                }
            }
            else
            {
                Common.Showloginalert(view: self, text: "Please Login to watch Video")
            }
            
            
            
            
            
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to access this section")

         }

    }
    
    
    
    
    
    
    //MARK:collection View delegate method
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
             return self.dataarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
  
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
        Common.getRoundImage(imageView: cell.bannerimaheview, radius: 15.0)
        Common.getRounduiview(view: cell.cellview, radius: 15.0)
        Common.getRoundImage(imageView: cell.cellbottomimageview, radius: 15.0)
        Common.setuiimageviewdborderwidth(imageView: cell.bannerimaheview!, borderwidth: 2.0)
        Common.getshadowofviewcollection(myView: cell.cellview!)
        if(Common.isNotNull(object: (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
        {
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
        let videotime = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
        
        cell.uploaddatelabel.text = Common.convertvideoduration(videotime: videotime!)
        return cell
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.descriptiontext =  (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        playerViewController.tilttext =   (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
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
        

        
        
      //  self.navigationController?.pushViewController(playerViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
    
    @IBAction func TAptoback(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
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
