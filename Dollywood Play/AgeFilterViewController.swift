//
//  AgeFilterViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 15/03/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class AgeFilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var mytableview: UITableView!
    var seletedageindex = Int()
     var allagegoup = NSMutableArray()
    var isagegroupseleted = Bool()
     @IBOutlet weak var seletedallimageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
         if(LoginCredentials.Agegroup == "0-0") {
           seletedallimageview.image = #imageLiteral(resourceName: "ageselected")
        }
        
    getAgegroup()
    
        // Do any additional setup after loading the view.
    }

    
    @IBAction func Taptoselectallage(_ sender: UIButton) {
        if(LoginCredentials.Agegroup == "0-0") {
         EZAlertController.alert(title: "This age group already selected")
            return
         }
  
        self.updateAgeGoup(agegroup: "0-0")
    }
    @IBAction func taptoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 64.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allagegoup.count
    }
    // cell height
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[4] as! Custometablecell
        Common.setuiviewdbordercolor(View: cell.agefilterview, borderwidth: 1.0, bordercolor: UIColor(red: 173/255.0, green: 173/255.0, blue: 173/255.0, alpha: 1.0) )
        Common.getRounduiview(view: cell.agefilterview, radius: 10.0)
        cell.Agepakege.text = (allagegoup.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
         cell.seletedageimage.addTarget(self, action: #selector(taptobutton(sender:)), for: .touchUpInside)
         if(isagegroupseleted)
        {
        if(indexPath.row == seletedageindex) {
            cell.seletedageimage.setImage(#imageLiteral(resourceName: "ageselected"), for: .normal)
         }
        else
        {
            cell.seletedageimage.setImage(#imageLiteral(resourceName: "agenotselected"), for: .normal)

         }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func updateAgeGoup(agegroup:String)
    {
       Common.startloder(view: self.view)
        var newagegroup = agegroup
        if(newagegroup == "5+")
        {
          newagegroup = "5-15"
        }
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(dict)
        var parameters = [String : String]()
        parameters = ["age_group":newagegroup,
                      "device": "ios",
                      "id": (dict.value(forKey: "id") as! NSNumber).stringValue]
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
                LoginCredentials.Agegroup = newagegroup
                dataBase.deletedataentity(entityname: "Logindata")
                dataBase.Savedatainentity(entityname: "Logindata", key: "logindatadict", data: data)
                dataBase.deletedataentity(entityname: "Sidemenudata")
                dataBase.deletedataentity(entityname: "Homedata")
                dataBase.deletedataentity(entityname: "Slidermenu")
                dataBase.deletedataentity(entityname: "Catlistdata")
                dataBase.deletedataentity(entityname: "Continuewatching")
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshHome"), object: nil, userInfo: nil)
                

               self.navigationController?.popViewController(animated: true)
                
              
 
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            // Common.stoploder(view: self.view)
            Common.stopwhiteloder(view: self.view)
            
        }
    }
  

    
    
    func getAgegroup()
    {
        Common.startloder(view: self.view)
      var url = String(format: "http://staging.multitvsolution.com:9001/automatorapi/v6/content/age_group/token/%@/device/ios",Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
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
                
                self.allagegoup = (dict.value(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
                 print(self.allagegoup )
                self.getselectedagegroup()
             
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            // Common.stoploder(view: self.view)
            Common.stopwhiteloder(view: self.view)
            
        }
    }
    

    
    func getselectedagegroup()
    {
          mytableview.reloadData()
        for i in 0..<self.allagegoup.count {
            
            if(LoginCredentials.Agegroup ==  ((self.allagegoup.object(at: i) as! NSDictionary).value(forKey: "age_group") as! String))
            {
                self.seletedageindex = i
                self.isagegroupseleted = true
                mytableview.reloadData()
                return
            }
        }
        
      
        

        
        
    }
    
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seletedageindex = indexPath.row
        isagegroupseleted = true
        mytableview.reloadData()
        self.updateAgeGoup(agegroup: ((self.allagegoup.object(at: indexPath.row) as! NSDictionary).value(forKey: "age_group") as! String))
        
     }
    
    
    
    func taptobutton(sender:UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.mytableview)
        let cellIndexPath = self.mytableview.indexPathForRow(at: pointInTable)
        seletedageindex = (cellIndexPath?.row)!
        isagegroupseleted = true
        mytableview.reloadData()
        self.updateAgeGoup(agegroup: ((self.allagegoup.object(at: (cellIndexPath?.row)!) as! NSDictionary).value(forKey: "age_group") as! String))
        
        
     }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
