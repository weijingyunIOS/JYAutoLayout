//
//  UIButton+Extension.swift
//  JYAutoLayout-Swift
//
//  Created by weijingyun on 16/5/5.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit

extension UIButton {

    convenience init(title: String) {
        self.init(frame: CGRect.zero)
        
        setTitle(title, for: UIControlState())
        setTitleColor(UIColor.black, for: UIControlState())
        backgroundColor = UIColor.lightGray
        titleLabel?.font = UIFont.systemFont(ofSize: 11)
    }
    
    convenience init(title: String, bgColor: UIColor) {
        self.init(frame: CGRect.zero)
        
        setTitle(title, for: UIControlState())
        setTitleColor(UIColor.black, for: UIControlState())
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: 11)
    }
}
