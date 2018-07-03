//
//  PrivacyPolicyViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 08/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var headerlabel: UILabel!

    @IBOutlet weak var webview: UIWebView!
     var str = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
 // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
        self.webview.isOpaque = false;
        self.webview.backgroundColor = UIColor.clear
        headerlabel.text = LoginCredentials.headerlabeltext
        if LoginCredentials.headerlabeltext == "Privacy Policy" {
            
            
            let url = URL (string:LoginCredentials.Privacypolcy)
            let requestObj = URLRequest(url: url!)
            webview.loadRequest(requestObj)
          //   webview.loadHTMLString("<html><head><style>body {background:clear} p {color:white;}</style></head><body><p>\(LoginCredentials.Privacypolcy)<p></body></html>", baseURL: nil)
        }
        else if(LoginCredentials.headerlabeltext == "Terms and Use" )
        {
            let url = URL (string:LoginCredentials.Termsanduse)
            let requestObj = URLRequest(url: url!)
            webview.loadRequest(requestObj)
             // webview.loadHTMLString("<html><head><style>body {background:clear} p {color:white;}</style></head><body><p>\(LoginCredentials.Termsanduse)<p></body></html>", baseURL: nil)
          
            
        }
        else if(LoginCredentials.headerlabeltext == "Disclaimer" )
        {
            let url = URL (string:LoginCredentials.Disclaimer)
            let requestObj = URLRequest(url: url!)
            webview.loadRequest(requestObj)
          //  webview.loadHTMLString("<html><head><style>body {background:yellow} p {color:white;}</style></head><body><p>\(LoginCredentials.Disclaimer)<p></body></html>", baseURL: nil)
            

         
            
        }
        else if(LoginCredentials.headerlabeltext == "About" )
        {
            let url = URL (string:LoginCredentials.About)
            let requestObj = URLRequest(url: url!)
            webview.loadRequest(requestObj)
          //  webview.loadHTMLString("<html><head><style>body {background:clear} p {color:black;}</style></head><body><p>\(LoginCredentials.About)<p></body></html>", baseURL: nil)
             
            
        }
        
        Common.startloder(view: self.view)

    }
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
      Common.stoploder(view: self.view)
    }
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        print("getting error in loading")
        Common.stoploder(view: self.view)
    }
    @IBAction func Taptomenu(_ sender: UIButton)
    {
        slideMenuController()?.openLeft()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 

}
extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
