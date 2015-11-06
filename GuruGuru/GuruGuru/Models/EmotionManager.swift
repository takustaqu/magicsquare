//
//  EmotionManager.swift
//  dishLand
//
//  Created by 山本　恭大 on 2015/06/13.
//  Copyright (c) 2015年 daisuke. All rights reserved.
//

import UIKit
import CoreMotion


enum COMMAND {
    case normal // 通常時
    case weak
    case strong
}

final class EmotionManager: NSObject {
    var changeCommand: (COMMAND) -> Void = {command in}
    //MARK: API
    var myMotionManager: CMMotionManager!
    var moveCount = 0
    var command : COMMAND = COMMAND.normal
    static let instance = EmotionManager()
    
    //MARK: private
    private var waiting = false
    
    private let friq = 0.1 // 計測周期
    private let waitingTime = 10// 変化の時間
    private var waitingCounter = 0;
    
    private let weakCount = 1.2;
    private let normalCount = 1.8;
    private let strongcount = 2.5;
    
    private var xRawData : Double = 0
    
    private var yRawData : Double = 0
    
    private var zRawData : Double = 0
    
    private var xRawDataBefore : Double = 0
    
    private var yRawDataBefore : Double = 0
    
    private var zRawDataBefore : Double = 0
    
    private override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "dummy", object: nil)
        
    }
    
    func update(notification: NSNotification)  {
        self.changeCommand(.normal)
    }
    
    private func analysis()
    {
        // MotionManagerを生成.
        myMotionManager = CMMotionManager()
        
        // 更新周期を設定.
        myMotionManager.accelerometerUpdateInterval = self.friq
        
        
        let handler:CMAccelerometerHandler = {(data:CMAccelerometerData?, error:NSError?) -> Void in
            
            self.xRawData = data!.acceleration.x - self.xRawDataBefore
            self.yRawData = data!.acceleration.y - self.yRawDataBefore
            self.zRawData = data!.acceleration.z - self.zRawDataBefore
            
            self.xRawDataBefore = data!.acceleration.x
            self.yRawDataBefore = data!.acceleration.y
            self.zRawDataBefore = data!.acceleration.z
            /*
            print("\(self.xRawData)")
            print("\(self.yRawData)")
            print("\(self.zRawData)")
            */
            if(self.waiting == true)
            {
                self.waitingCounter = self.waitingCounter + 1
            }
            if(self.waiting == false) // no wait
            {
                if((self.xRawData < -self.strongcount || self.strongcount < self.xRawData))
                {
                    self.changeCommand(.strong)
                    self.waiting = true
                    self.waitingCounter = 0
                }
                else if((self.xRawData < -self.normalCount || self.normalCount < self.xRawData))
                {
                    self.changeCommand(.normal)
                    self.waiting = true
                    self.waitingCounter = 0
                }
                else if((self.xRawData < -self.weakCount || self.weakCount < self.xRawData))
                {
                    self.changeCommand(.weak)
                    self.waiting = true
                    self.waitingCounter = 0
                }
            }
            if(self.waitingTime < self.waitingCounter)
            {
                self.waiting = false
            }
        }
        
        //取得開始
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:handler)
    }
    
    
    func start(){
        self.waiting = false
        analysis()
    }
    
    func stop()
    {
        myMotionManager.stopAccelerometerUpdates()
    }
    
}
