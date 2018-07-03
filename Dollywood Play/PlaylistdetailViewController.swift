//
//  PlaylistdetailViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 18/07/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class PlaylistdetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet var mycollectionview: UICollectionView!
    @IBOutlet var headerlabel: UILabel!
    @IBOutlet var mytableview: UITableView!
    var playlistid = String()
    var playlistname = String()
    var dataarray = NSArray()
    var display_offset = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        display_offset = "0"
          self.mycollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        headerlabel.text = playlistname
        getPlaylist()
        
       

        // Do any additional setup after loading the view.
    }
    @IBAction func Taptoback(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

    
    
    func getPlaylist()
    {
        //playlist_id //if i click on playlist
        Common.startloder(view: self.view)
        
        var parameters = [String : Any]()
        var url = String()

        if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            let user_id = dict.value(forKey: "id") as! String
         parameters = [ "playlist_id":playlistid,
                       "device":"ios",
                       "user_id":user_id
        ]
            
      url = String(format: "%@%@/playlist_id/%@/device/ios/user_id/%@/max_counter/10/current_offset/%@", LoginCredentials.Listapi,Apptoken,playlistid,user_id,display_offset)
            
            
            
        }
        else
        {
            parameters = [ "playlist_id":playlistid,
                           "device":"ios",
            ]
            
                  url = String(format: "%@%@/playlist_id/%@/device/ios/max_counter/10/current_offset/%@", LoginCredentials.Listapi,Apptoken,playlistid,display_offset)
        }
        
        url = url.trimmingCharacters(in: .whitespaces)

  //  http://yuvadmin.multitvsolution.com/v4/content/list/token/59a942cd8175f/max_counter/10/device/web/current_offset/0/user_id/240/playlist_id/38
         let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                Common.stoploder(view: self.view)
                
                let dict = responseObject as! NSDictionary
                if((dict.value(forKey: "code") as! NSNumber) == 0)
                {
                    
                    self.dataarray = NSArray()
                    self.mycollectionview.reloadData()
                     //self.mytableview.reloadData()
                    
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
                    
                    self.dataarray = chaneeldata_dict.value(forKey: "content") as! NSArray
                    self.mycollectionview.reloadData()
                    //self.mytableview.reloadData()
                    
                }
                
                
                
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataarray.count
    }
    
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
            
            
            
            cell.titletypwlabel.text = ""
            
            
            var discriptiontext = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.desciptionlabel.text = discriptiontext
        
          let url = ((((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
         
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.Video_url = ""
        
        if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
            playerViewController.descriptiontext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        else
        {
            playerViewController.descriptiontext = ""
        }
        playerViewController.liketext =  ""
        playerViewController.tilttext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        
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
        self.navigationController?.pushViewController(playerViewController, animated: true)
        
        
    }

    //MARK:collection View delegate method
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.dataarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.clipsToBounds = true
        
        
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
       
        
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
          playerViewController.catid = ids
          playerViewController.cat_id = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-5, height: 100)
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

}
