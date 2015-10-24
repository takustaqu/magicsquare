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
    
    private var manager : EmotionManager? = EmotionManager.instance
    
    private var player :AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.manager?.changeCommand = { command in
            switch(command)
            {
            case .normal:
                let urlString = NSBundle.mainBundle().pathForResource("magic-flame1", ofType: "mp3")
                let url:NSURL  = NSURL.fileURLWithPath(urlString!)
                
                do {
                    try self.player =  AVAudioPlayer(contentsOfURL: url)
                } catch {
                    //Handle the error
                }
                self.player?.play()
                break
            default:
                break
            }
            
        }
        self.manager?.start()
    }
    
    @IBAction private func player1()
    {
        
    }
    
    @IBAction private func player2()
    {
        
    }
    
    @IBAction private func player3()
    {
        
    }
    
    @IBAction private func player4()
    {
        
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
        
        Alamofire.request(.GET, "http://magicrune.cloudapp.net/magicrune.cloudapp.net/api/", parameters: parameters, encoding: .JSON)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

