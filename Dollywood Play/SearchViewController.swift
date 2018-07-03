//
//  SearchViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 22/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var mycollectionview: UICollectionView!
    @IBOutlet weak var resultcountlabel: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var mytableview: UITableView!
    var dataarray = NSArray()
    var sectiondataarray = NSArray()
    var autosuggectionaarray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        //searchbar.layer.borderColor = UIColor.blue.cgColor
       // searchbar.layer.borderWidth = 1.0
         self.mycollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
       // mycollectionview.register(Searchheaderview.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "Searchheader")
//        searchbar.isTranslucent = true
//        searchbar.alpha = 1
//        searchbar.backgroundColor = UIColor.init(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)
//        searchbar.barTintColor = UIColor.init(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)
//        searchbar.backgroundImage = UIImage()
//        searchbar.barTintColor = UIColor.clear

        // Do any additional setup after loading the view.
    }

    @IBAction func Taptoback(_ sender: UIButton) {
        
       self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.view.endEditing(true)
    }
    
    func Getautosuggestion(searchkey:String)
    {
        var url = String(format: "%@%@/title/%@", LoginCredentials.Autosuggestapi,Apptoken,searchkey)
        
         if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
        {
            url = String(format: "%@%@/title/%@/age_group/%@", LoginCredentials.Autosuggestapi,Apptoken,searchkey,LoginCredentials.Agegroup)
         
        }
        
        
        
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                
                print(dict)
                
                
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    self.autosuggectionaarray = NSArray()
                    
                }
                else
                {
                    
                    self.autosuggectionaarray = dict.value(forKey: "result") as! NSArray
                }
                
                
                if(self.autosuggectionaarray.count == 0)
                {
                    self.mytableview.isHidden = true
                }
                else
                {
                    self.mytableview.reloadData()
                    self.mytableview.isHidden = false
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    
    func searchwithstring(searchkey:String)
    {
        Common.startloder(view: self.view)
        let parameters = [
            "device": "ios",
            "search_tag": searchkey,
            "content_count": "20",
            "display_limit" : "20"
        ]
     // var url = String(format: "%@%@/device/ios/search_tag/%@/content_count/20/display_limit/20", LoginCredentials.Searchapi,Apptoken,searchkey)
        
       var url = String(format: "%@%@/device/ios/current_offset/0/max_counter/100/search_tag/%@", LoginCredentials.Searchapi,Apptoken,searchkey)
        if(Common.Islogin() && LoginCredentials.Agegroup != "0-0" && Common.isNotNull(object: LoginCredentials.Agegroup as AnyObject))
        {
            
                url = String(format: "%@%@/device/ios/current_offset/0/max_counter/100/search_tag/%@/age_group/%@", LoginCredentials.Searchapi,Apptoken,searchkey,LoginCredentials.Agegroup)
        }
        
        
       // url = url.trimmingCharacters(in: .whitespaces)
     url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let manager = AFHTTPSessionManager()
        
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                 print(dict)
                Common.stoploder(view: self.view)
                self.mytableview.isHidden = true
                 if let _ = dict.value(forKey: "code")
                {
                    if(dict.value(forKey: "code") as! NSNumber == 0)
                    {
                        return
                    }
                }

                
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptSearchapi)
                {
                    Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    
                }
                print(Catdata_dict)
                self.dataarray = Catdata_dict.value(forKey: "content") as! NSArray
                self.sectiondataarray = Catdata_dict.value(forKey: "content") as! NSArray
             self.resultcountlabel.text = "Total results:\(self.dataarray.count)"
                if(self.dataarray.count == 0)
                {
                 EZAlertController.alert(title: "No result found")
                }
                
                  //  self.mytableview.reloadData()
                
                self.mycollectionview.reloadData()
  
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            EZAlertController.alert(title: error.localizedDescription)
             Common.stoploder(view: self.view)
        }
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
      self.mytableview.isHidden = true
      searchwithstring(searchkey: searchBar.text!)
      searchBar.resignFirstResponder()
    }
    
  
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.autosuggectionaarray = NSArray()
        self.mytableview.reloadData()
        if(searchText.length > 2)
        {
            Getautosuggestion(searchkey: searchText)
        }
        else
        {
            mytableview.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.autosuggectionaarray.count
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[5] as! Custometablecell
        if(autosuggectionaarray.count>0)
        {
         cell.suggestionlabel.text = autosuggectionaarray.object(at: indexPath.row) as? String
        }
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        self.mytableview.isHidden = true
        searchwithstring(searchkey: (autosuggectionaarray.object(at: indexPath.row) as? String)!)
        searchbar.resignFirstResponder()
    }
    
    
    
    //MARK:collection View delegate method
    
    
    
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int
//    {
//        print(sectiondataarray.count)
//        return sectiondataarray.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headersection", for: indexPath as IndexPath) 
//        header.backgroundColor  =  UIColor.init(colorLiteralRed: 11/255, green: 11/255, blue: 11/255, alpha: 1.0)
//         let headerimageview = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 45, height: 25))
//        let headertextlabel = UILabel.init(frame: CGRect.init(x: 70, y: 17, width: 200, height: 15))
//        headertextlabel.textColor = UIColor.white
//        headertextlabel.text = ""
//        if(Common.isNotNull(object: (dataarray.object(at: indexPath.section) as! NSDictionary).value(forKey: "image") as AnyObject?))
//        {
//        let str  = (dataarray.object(at: indexPath.section) as! NSDictionary).value(forKey: "image") as! String
//        headerimageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
//        }
//        else
//        {
//            
//        }
//        
//        if(Common.isNotNull(object: (dataarray.object(at: indexPath.section) as! NSDictionary).value(forKey: "image") as AnyObject?))
//        {
//            let str1  = (dataarray.object(at: indexPath.section) as! NSDictionary).value(forKey: "name") as! String
//            headertextlabel.text = str1
//        }
//        else
//        {
//          headertextlabel.text = ""
//        }
//
//        
//        header.addSubview(headerimageview)
//        header.addSubview(headertextlabel)
//        return header
//    }
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//    {
//        return CGSize.init(width: collectionView.bounds.width, height: 50.0)
//        
//        
//        
//    }
    
    
  
    
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
    
        return self.sectiondataarray.count
   
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
        Common.getRoundImage(imageView: cell.bannerimaheview, radius: 15.0)
        Common.getRounduiview(view: cell.cellview, radius: 15.0)
        Common.getRoundImage(imageView: cell.cellbottomimageview, radius: 15.0)
        Common.setuiimageviewdborderwidth(imageView: cell.bannerimaheview!, borderwidth: 2.0)
        Common.getshadowofviewcollection(myView: cell.cellview!)
       
        
        
        if(Common.isNotNull(object: (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
        {
         let url = (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
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
        cell.titilelabel.text = (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
 
        let videotime = (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
        
        cell.uploaddatelabel.text = Common.convertvideoduration(videotime: videotime!)
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        
        if(Common.isNotNull(object:  (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
        
        playerViewController.descriptiontext =  (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        if(Common.isNotNull(object:  (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as AnyObject?))
        {
        playerViewController.tilttext =   (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        }
        playerViewController.fromdownload = "no"
        
        
        let catdataarray = (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        if(catdataarray.count == 0)
        {
            playerViewController.catid = (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
        }
        else
        {
            
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
        }
        
        
        playerViewController.cat_id = (sectiondataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        
        
        
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
