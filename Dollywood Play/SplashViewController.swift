//
//  SplashViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 31/10/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class SplashViewController: UIViewController {
var player: AVPlayer?
    
    @IBOutlet var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        deletecathdata()
       AppUtility.lockOrientation(.portrait)
        loadVideo()
        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view.
    }

    
    
    func deletecathdata() {
        LoginCredentials.Agegroup = "0-0"
        dataBase.deletedataentity(entityname: "Sidemenudata")
        dataBase.deletedataentity(entityname: "Homedata")
        dataBase.deletedataentity(entityname: "Slidermenu")
        dataBase.deletedataentity(entityname: "Catlistdata")
        dataBase.deletedataentity(entityname: "Continuewatching")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadVideo() {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        let path = Bundle.main.path(forResource: "eryhrturtuj", ofType:"mp4")
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        self.imageview.layer.addSublayer(playerLayer)
        player?.seek(to: kCMTimeZero)
        player?.play()
       // player?.volume = 1.0
       NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:player?.currentItem)
      }
    
    func playerDidFinishPlaying(note: NSNotification)
    {
       print("dum dum dum video ktm")
          redirecttoscreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    func redirecttoscreen()
    {
        if(Common.Islogin())
        {
            if(Common.isInternetAvailable())
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                 self.navigationController?.pushViewController(channeldetailViewController, animated: true)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "DownloadsViewController") as! DownloadsViewController
                self.navigationController?.pushViewController(channeldetailViewController, animated: true)
            }
        }
        else
        {
          
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
          //  let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
             let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(channeldetailViewController, animated: true)
        }
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
    extension SplashViewController : SlideMenuControllerDelegate {
        
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
    

