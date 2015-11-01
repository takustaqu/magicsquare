//
//  RotateImageView.swift
//  GuruGuru
//
//  Created by 山本　恭大 on 2015/11/01.
//  Copyright © 2015年 山本　恭大. All rights reserved.
//

import UIKit

class RotateImageView: UIImageView {
    func startAnimation()
    {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 5.0
        animation.repeatCount = 1e100
        let ff : Float = Float((M_PI / 180) * 360)
        animation.toValue = NSNumber(float:ff)
        self.layer.addAnimation(animation, forKey: "rotateAnimation")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
