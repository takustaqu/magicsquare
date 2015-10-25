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
    
    private var manager : EmotionManager? = EmotionManager.instance
    private var channel = -1
    private var commandString = "Open"
    
    private var player :AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var intency = ""
        // Do any additional setup after loading the view, typically from a nib.
        self.manager?.changeCommand = { command in
            switch(command)
            {
            case .normal:
                intency = "normal"
                let urlString = NSBundle.mainBundle().pathForResource("magic-flame1", ofType: "mp3")
                let url:NSURL  = NSURL.fileURLWithPath(urlString!)
                
                do {
                    try self.player =  AVAudioPlayer(contentsOfURL: url)
                } catch {
                    //Handle the error
                }
                self.player?.play()
                print("normal")
                break
            case .weak:
                intency = "weak"
                let urlString = NSBundle.mainBundle().pathForResource("magic-flame1", ofType: "mp3")
                let url:NSURL  = NSURL.fileURLWithPath(urlString!)
                
                do {
                    try self.player =  AVAudioPlayer(contentsOfURL: url)
                } catch {
                    //Handle the error
                }
                self.player?.play()
                print("weak")
                break
            case .strong:
                intency = "strong"
                let urlString = NSBundle.mainBundle().pathForResource("magic-flame1", ofType: "mp3")
                let url:NSURL  = NSURL.fileURLWithPath(urlString!)
                
                do {
                    try self.player =  AVAudioPlayer(contentsOfURL: url)
                } catch {
                    //Handle the error
                }
                self.player?.play()
                print("strong")
                break
            default:
                break
            }
            if(self.commandString != "" ||  self.channel != -1)
            {
                let parameters = [
                    "player": "\(self.channel)",
                    "command": "\(self.commandString)",
                    "intensity":"\(intency)"
                ]
                Alamofire.request(.POST, "http://magicrune.cloudapp.net/magicrune.cloudapp.net/api/", parameters: parameters, encoding: .JSON)
                    .responseJSON { response in
                        print("\(response)")
                }
                if()
            }
            
        }
        self.manager?.start()
    }
    
    @IBAction private func player1()
    {
        self.channel = 0
        
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
        self.commandString = "Goo"
    }
    
    @IBAction private func choki()
    {
        self.commandString = "Choki"
    }
    
    @IBAction private func pa()
    {
        self.commandString = "Par"
    }
    
    @IBAction private func sneak()
    {
        self.commandString = "Sneak"
    }
    
    @IBAction private func spock()
    {
        self.commandString = "Spock"
    }
    
    
    @IBAction private func testPost()
    {
        let parameters = [
            "target": "objectName",
            "baz": ["a", 1],
            "payload": [
                "arg1": "param",
                "arg2": "param",
                "arg3": "param"
            ]
        ]
        
        Alamofire.request(.POST, "http://magicrune.cloudapp.net/api", parameters: parameters , encoding:.JSON)
            .responseJSON { response in
                print("\(response)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

