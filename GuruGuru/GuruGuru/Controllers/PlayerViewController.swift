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
import AudioToolbox

class PlayerViewController: UIViewController{
    
    private let URI = "http://magicrune.cloudapp.net/api"
    
    @IBOutlet weak private var guButton : UIButton!
    @IBOutlet weak private var chokiButton : UIButton!
    @IBOutlet weak private var parButton : UIButton!
    
    @IBOutlet weak private var startingImage : UIImageView!
    @IBOutlet weak private var guSelect : TransformImageView!
    @IBOutlet weak private var chokiSelect : TransformImageView!
    @IBOutlet weak private var parSelect : TransformImageView!
    
    @IBOutlet weak private var mahoujinImage : RotateImageView!
    
    @IBOutlet weak private var explane : UILabel!
    
    @IBOutlet weak private var palyer1Button : UIButton!
    @IBOutlet weak private var palyer2Button : UIButton!
    
    private var manager : EmotionManager? = EmotionManager.instance
    private var channel = -1
    private var commandString = "open"
    
    private var boisArray:[String] = ["voice-magic-01","voice-magic-earth01","voice-magic-fire01","voice-magic-ice01","voice-magic-wind01","voice-hanyou01","voice-hanyou-C03","voice-hanyou02","voice-berserk01","voice-berserk03","voice-berserk04"]
    
    private var imageP1_ON = UIImage(named:"btn_player1_on")
    private var imageP1_OFF = UIImage(named:"btn_player1_off")
    
    private var imageP2_ON = UIImage(named:"btn_player2_on")
    private var imageP2_OFF = UIImage(named:"btn_player2_off")
    
    private var playerNumber = 0
    
    private var player :AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.guButton.enabled = false;
        self.chokiButton.enabled = false;
        self.parButton.enabled = false;
        
        self.guSelect.hidden = true;
        self.chokiSelect.hidden = true;
        self.parSelect.hidden = true;
        self.startingImage.hidden = false;
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
                    "player": "\(self.playerNumber)",
                    "command": "\(self.commandString)",
                    "intensity":"\(intency)"
                ]
                Alamofire.request(.POST, self.URI, parameters: parameters, encoding: .JSON)
                    .responseJSON { response in
                        print("\(response)")
                }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            
            if(self.commandString == "open")
            {
                self.guButton.enabled = true;
                self.chokiButton.enabled = true;
                self.parButton.enabled = true;
                self.startingImage.hidden = true;
                self.mahoujinImage.startAnimation()
                self.explane.text = "出す手を選んでください"
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
            
            if(self.commandString == "goo" || self.commandString == "choki" || self.commandString == "par")
            {
                self.commandString = "open"
                
                self.explane.text = "出す手を選んでください"
                
                self.guButton.enabled = true;
                self.chokiButton.enabled = true;
                self.parButton.enabled = true;
                
                self.guSelect.hidden = true;
                self.chokiSelect.hidden = true;
                self.parSelect.hidden = true;
                
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
        
        Alamofire.request(.POST, self.URI, parameters: parameters , encoding:.JSON)
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
        
        Alamofire.request(.POST, self.URI, parameters: parameters , encoding:.JSON)
            .responseJSON { response in
                print("\(response)")
        }
    }
    
    @IBAction private func player1Select()
    {
        self.playerNumber = 0;
        self.palyer1Button.setBackgroundImage(self.imageP1_ON, forState: UIControlState.Normal);
        self.palyer2Button.setBackgroundImage(self.imageP2_OFF, forState: UIControlState.Normal);
    }
    
    
    @IBAction private func player2Select()
    {
        self.playerNumber = 1;
        self.palyer1Button.setBackgroundImage(self.imageP1_OFF, forState: UIControlState.Normal);
        self.palyer2Button.setBackgroundImage(self.imageP2_ON, forState: UIControlState.Normal);
    }
    
    
    @IBAction private func gu()
    {
        self.commandString = "goo"
        self.chokiButton.enabled = false;
        self.parButton.enabled = false;
        
        self.guSelect.hidden = false;
        self.chokiSelect.hidden = true;
        self.parSelect.hidden = true;
        
        self.guSelect.startAnimation()
        
        self.explane.text = "対戦相手と同時に\niPhoneを振ってください"
    }
    
    @IBAction private func choki()
    {
        self.commandString = "choki"
        self.guButton.enabled = false;
        self.parButton.enabled = false;
        
        self.guSelect.hidden = true;
        self.chokiSelect.hidden = false;
        self.parSelect.hidden = true;
        
        self.chokiSelect.startAnimation()
        
        self.explane.text = "対戦相手と同時に\niPhoneを振ってください"
    }
    
    @IBAction private func pa()
    {
        self.commandString = "par"
        self.chokiButton.enabled = false;
        self.guButton.enabled = false;
        
        self.guSelect.hidden = true;
        self.chokiSelect.hidden = true;
        self.parSelect.hidden = false;
        
        self.parSelect.startAnimation()
        
        self.explane.text = "対戦相手と同時に\niPhoneを振ってください"
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
        self.startingImage.hidden = false;
        
        self.guSelect.hidden = true;
        self.chokiSelect.hidden = true;
        self.parSelect.hidden = true;
        self.explane.text = "iPhoneを振って魔法陣を\n召喚してください"
        
        let parameters = [
            "player": "\(self.playerNumber)",
            "command": "close",
            "intensity":"weak"
        ]
        Alamofire.request(.POST, self.URI, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print("\(response)")
        }
        
        self.commandString = "open"
    }
    
    @IBAction private func test()
    {
        let parameters = [
            "player": "0",
            "command": "open",
            "intensity":"weak"
        ]
        Alamofire.request(.POST, self.URI, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print("\(response)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

