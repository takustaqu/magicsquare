//
//  RoundImageView.swift
//  VolatilizeMessenger
//
//  Created by 山本　恭大 on 2014/12/10.
//  Copyright (c) 2014年 山本　恭大. All rights reserved.
//

import UIKit

class RoundView: UIView {
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.clipsToBounds = true
    }
    
    @IBInspectable var borderWidth:CGFloat = 0 {
        didSet
        {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.blackColor() {
        didSet
        {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0{
        didSet
        {
            layer.cornerRadius = cornerRadius
        }
    }
}
