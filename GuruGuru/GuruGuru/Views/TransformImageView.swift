//
//  TransformImageView.swift
//  GuruGuru
//
//  Created by 山本　恭大 on 2015/11/01.
//  Copyright © 2015年 山本　恭大. All rights reserved.
//

import UIKit

class TransformImageView: UIImageView {
    func startAnimation()
    {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
        animation.repeatCount = 1
        animation.fromValue = NSNumber(float:3.0)
        animation.toValue = NSNumber(float:1.0)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.layer.addAnimation(animation, forKey: "scale-layer")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
