//
//  ViewController.swift
//  GuruGuru
//
//  Created by 山本　恭大 on 2015/10/24.
//  Copyright © 2015年 山本　恭大. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class PlayerViewController: UIViewController{
    
    @IBOutlet weak private var segmentControl : UISegmentedControl!
    
    @IBOutlet weak private var guButton : UIButton!
    @IBOutlet weak private var chokiButton : UIButton!
    @IBOutlet weak private var parButton : UIButton!
    
    private var manager : EmotionManager? = EmotionManager.instance
    private var channel = -1
    private var commandString = "open"
    
    private var boisArray:[String] = ["voice-magic-01","voice-magic-earth01","voice-magic-fire01","voice-magic-ice01","voice-magic-wind01","voice-hanyou01","voice-hanyou-C03","voice-hanyou02","voice-berserk01","voice-berserk03","voice-berserk04"]
    
    private var player :AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.guButton.enabled = false;
        self.chokiButton.enabled = false;
        self.parButton.enabled = false;
        
        var intency = ""
        // Do any additional setup after loading the view, typically from a nib.
        self.manager?.changeCommand = { command in
            switch(command)
            {
            case .normal:
                intency = "normal"
                print("normal")
                break
            case .weak:
                intency = "weak"
                print("weak")
                break
            case .strong:
                intency = "strong"
                print("strong")
                break
            default:
                break
            }
            if(self.commandString != "" ||  self.channel != -1)
            {
                let parameters = [
                    "player": "\(self.segmentControl.selectedSegmentIndex)",
                    "command": "\(self.commandString)",
                    "intensity":"\(intency)"
                ]
                Alamofire.request(.POST, "http://magicrune.cloudapp.net/magicrune.cloudapp.net/api/", parameters: parameters, encoding: .JSON)
                    .responseJSON { response in
                        print("\(response)")
                }
            }
            
            if(self.commandString == "open")
            {
                self.guButton.enabled = true;
                self.chokiButton.enabled = true;
                self.parButton.enabled = true;
                
                self.segmentControl.enabled = false;
                let randData:Int = Int(arc4random() % 11)
                print("\(self.boisArray[randData])")
                let urlString = NSBundle.mainBundle().pathForResource(self.boisArray[randData], ofType: "wav")
                
                let url:NSURL  = NSURL.fileURLWithPath(urlString!)
                
                do {
                    try self.player =  AVAudioPlayer(contentsOfURL: url)
                } catch {
                    //Handle the error
                }
                self.player?.play()
            }
            
        }
        self.manager?.start()
    }
    
    @IBAction private func player1()
    {
        self.channel = 0
        print("\(self.segmentControl.selectedSegmentIndex)")
        let parameters = [
            "player": "\(self.channel)",
            "command": "Open",
            "intensity":"weak"
        ]
        
        Alamofire.request(.POST, "http://magicrune.cloudapp.net/api", parameters: parameters , encoding:.JSON)
            .responseJSON { response in
                print("\(response)")
        }
    }
    
    @IBAction private func player2()
    {
        self.channel = 1
        
        let parameters = [
            "player": "\(self.channel)",
            "command": "Close",
            "intensity":"weak"
        ]
        
        Alamofire.request(.POST, "http://magicrune.cloudapp.net/api", parameters: parameters , encoding:.JSON)
            .responseJSON { response in
                print("\(response)")
        }
    }
    
    @IBAction private func player3()
    {
        self.channel = 2
    }
    
    @IBAction private func player4()
    {
        self.channel = 3
    }
    
    
    @IBAction private func gu()
    {
        self.commandString = "goo"
        self.chokiButton.enabled = false;
        self.parButton.enabled = false;
    }
    
    @IBAction private func choki()
    {
        self.commandString = "choki"
        self.guButton.enabled = false;
        self.parButton.enabled = false;
    }
    
    @IBAction private func pa()
    {
        self.commandString = "par"
        self.chokiButton.enabled = false;
        self.guButton.enabled = false;
    }
    
    @IBAction private func sneak()
    {
        self.commandString = "sneak"
    }
    
    @IBAction private func spock()
    {
        self.commandString = "spock"
    }
    
    @IBAction private func logOut()
    {
        
        self.guButton.enabled = false;
        self.chokiButton.enabled = false;
        self.parButton.enabled = false;
        
        self.segmentControl.enabled = true;
        
        let parameters = [
            "player": "\(self.segmentControl.selectedSegmentIndex)",
            "command": "close",
            "intensity":"weak"
        ]
        Alamofire.request(.POST, "http://magicrune.cloudapp.net/api", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print("\(response)")
        }
        self.commandString = "open"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

