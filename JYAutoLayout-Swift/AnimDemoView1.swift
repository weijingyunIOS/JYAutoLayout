//
//  AnimDemoView.swift
//  JYAutoLayout-Swift
//
//  Created by weijingyun on 16/5/5.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit

class AnimDemoView1: UIView {

    var centerBtn: UIButton?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        centerBtn = UIButton(title: "Click Me")
        addSubview(centerBtn!)
        centerBtn!.center(self).size(150, h: 150).end()
        widthConstraint = centerBtn!.ff_Constraint(NSLayoutAttribute.Width)
        heightConstraint = centerBtn!
            .ff_Constraint(NSLayoutAttribute.Height)
        centerBtn?.addTarget(self, action: #selector(AnimDemoView1.click), forControlEvents: UIControlEvents.TouchUpInside)
    }
   
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func click() {
        widthConstraint?.constant = 300
        heightConstraint?.constant = 300
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.layoutIfNeeded()
            }, completion: { _ in
                
                self.widthConstraint?.constant = 150
                self.heightConstraint?.constant = 150
                
                UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                    self.layoutIfNeeded()
                    }, completion: { _ in
                        
                })
        })
    }
    
    deinit{
        print("deinit")
    }
}
