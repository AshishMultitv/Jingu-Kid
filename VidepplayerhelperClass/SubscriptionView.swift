//
//  SubscriptionView.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 05/03/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class SubscriptionView: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Subscriptiontableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(LoginCredentials.UserPakegeList)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        Subscriptiontableview.reloadData()
         self.navigationController?.isNavigationBarHidden = true
    }
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return LoginCredentials.UserPakegeList.count
    }
    // cell height
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[3] as! Custometablecell
        cell.subscriptionname.text = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_name") as? String
        cell.subscriptionprice.text = "\("₹ ")\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_price") as! String)"
        let subscriptionenddate = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "subscription_end_date") as! String
       let subscriptionenddatearry =   subscriptionenddate.components(separatedBy: " ")
        cell.subscriptiondatelabel.text = subscriptionenddatearry[0]
        Common.getRounduiview(view: cell.subscriptionview, radius: 10.0)
        Common.setuiviewdbordercolor(View: cell.subscriptionview, borderwidth: 1.0, bordercolor: UIColor.blue)
        
        let issubcribed = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "is_subscriber") as! String
        if(issubcribed == "1") {
            cell.subscriptionInfolabel.text = "Subscribed"
            cell.subscriptionview.backgroundColor = UIColor.blue
        }
        else
        {
            cell.subscriptionInfolabel.text = "Subscribe"
            cell.subscriptionview.backgroundColor = UIColor.white
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
        if(Common.Islogin())
        {
            
           if(!Common.Isuserissubscribe(Userdetails: self as AnyObject))
           {
           
            let id = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "package_id") as! String
            let pakagename = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_name") as! String
            Common.startloderonsubscription(view: self.view)
           //Common.startloder(view: self.view)
             self.getorderid(id: id, type: pakagename)
        // self.getorderid(id: id)
            }
            else
           {
            EZAlertController.alert(title: "You are already subscribed")
            }
        }
        else
        {
            
         
            let alert = UIAlertController(title: "", message: "Please login to Subscripton", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
             }))
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (action) in
               // self.dismiss(animated: true, completion: nil)
                self.goTologin()
             }))
            self.present(alert, animated: true, completion: nil)
            
            
        //   Common.Showloginalert(view: self, text: "Please login to access this section")
        }
    }
    
    func goTologin()
    {
      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
       // let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
      //   self.navigationController?.pushViewController(channeldetailViewController, animated: true)
        self.dismiss(animated: true, completion: nil)


    }
    
    
    
    
    
    
    func getorderid(id:String,type:String) {
        
        let newid = (id as NSString).intValue
        print(newid)
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let items = ["id":newid] as [String:Any]
        let itemsarray = [items]
         let cartdetail = ["items" :itemsarray] as [String:Any]
        print(cartdetail)
        print(Common.convertdictinyijasondata(data: cartdetail as NSDictionary))
        
        let Param =   ["cart":Common.convertdictinyijasondata(data: cartdetail as NSDictionary),
                       "c_id":(dict.value(forKey: "id") as! NSNumber),
                       "paymentgateway":"inapp",
                       ] as NSDictionary
        print(Common.convertdictinyijasondata(data: Param as NSDictionary))
        var url = String(format: "%@%@/device/ios",LoginCredentials.Subscriptioncreatordereapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: Param, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                     Common.stoploderonsubscription(view: self.view)

                }
                    
                else
                {
                    
                    let subs_id = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "subscriber_id") as! Int
                     let Order_id = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "id") as! Int
                      print(subs_id)
                     self.PaywithIap(type: type, orderid: Int(Order_id), subscriptionid: subs_id)
                    
                 }
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonsubscription(view: self.view)
        }
         
            
        
    }
    

    func PaywithIap(type:String,orderid:Int,subscriptionid:Int)
{
    print(Constant.getsubscriptionid(type: type))
    NetworkActivityIndicatorManager.networkOperationStarted()
     SwiftyStoreKit.purchaseProduct(Constant.getsubscriptionid(type: type), atomically: true) { result in
        NetworkActivityIndicatorManager.networkOperationFinished()
         if case .success(let purchase) = result {
          Common.stoploderonsubscription(view: self.view)
              switch purchase.transaction.transactionState {
            case .purchased:
                print(purchase.transaction.transactionIdentifier!)
                let trsnid = purchase.transaction.transactionIdentifier!
                print(purchase.productId)
                self.VerifyPaymentourserver(tran_id: trsnid, sub_id: subscriptionid, orderid: orderid)
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            case .purchasing:
                print(purchase.transaction.transactionIdentifier!)
                let trsnid = purchase.transaction.transactionIdentifier!
                print(purchase.productId)
                self.VerifyPaymentourserver(tran_id: trsnid, sub_id: subscriptionid, orderid: orderid)
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
              case .failed:
                 print("failed Transition")
                break
              case .restored:
                    print("Restores Transition")
                break
            case .deferred:
                 break
            }
          
             // Deliver content from server, then:
        
        }
        if case .error(let eror) = result
        {
            print(eror.code)
            Common.stoploderonsubscription(view: self.view)

        }
        if let alert = self.alertForPurchaseResult(result) {
            self.showAlert(alert)
 
        }
    }
    }
 
  
    
    
    
    func VerifyPaymentourserver(tran_id:String,sub_id:Int,orderid:Int)
    {
        Common.startloderonsubscription(view: self.view)
        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = (receiptData?.base64EncodedString(options: []))! as String
        print(receiptString)

        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")

        print(dict.value(forKey: "id") as! NSNumber)
        print(tran_id)
        print(receiptString)
         print(sub_id)
         print(orderid)
        
        let Param =   ["c_id":dict.value(forKey: "id") as! NSNumber,
                       "paymentgateway":"inapp",
                       "trans_id":tran_id,
                       "signature":receiptString,
                       "subscription_id":sub_id,
                       "order_id":orderid,
                       "status":"1"
         ] as [String:Any]
        print(Param)
       //  var url = String(format: "%@/subscriptionapi/v6/subscription/complete_order/token/%@/device/ios",Subscriptionbaseurl,Apptoken)
        
        var url = String(format: "%@%@/device/ios",LoginCredentials.Subscriptioncompleteorderapi,Apptoken)

        
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: Param, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                Common.stoploderonsubscription(view: self.view)
                self.chekcUsersubscription()
                self.dismiss(animated: true, completion: nil)
                 Common.gotomyprofile()
                
                
               
          
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonsubscription(view: self.view)
            self.dismiss(animated: true, completion: nil)

        }
        
        
        
        
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
                        
                        self.Subscriptiontableview.reloadData()
                        
                        
                    }
                }
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    @IBAction func TapToCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
