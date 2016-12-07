//
//  PriorityRehearseView.swift
//  JYAutoLayout-Swift
//
//  Created by weijingyun on 16/5/5.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit

class AnimDemoView2: UIView {
    var centerXConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let reference1 = UIButton(title: "reference1")
//        addSubview(reference1)
//        reference1.alignLeft(self,c:8).alignTop(self,c:64).size(100, h: 100).end()
//        
//        let reference2 = UIButton(title: "reference2")
//        addSubview(reference2)
//        reference2.alignRight(self,c:8).alignTop(self,c:64).size(100, h: 100).end()
//        
//        let priorityBtn = UIButton(title: "Click Me")
//        addSubview(priorityBtn)
//        priorityBtn.centerY(self).size(100, h: 100).end()
//        priorityBtn.centerX(reference1,p:priorityMedium).end()
//        centerXConstraint = priorityBtn.centerX(reference2,p:priorityHigh).end()?.first
//        priorityBtn.addTarget(self, action: #selector(AnimDemoView2.priority(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func priority(_ btn:UIButton){
        btn.isSelected = !btn.isSelected
        centerXConstraint?.priority = btn.isSelected ? priorityLow: priorityHigh
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.layoutIfNeeded()
            }, completion: { _ in

        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("deinit")
    }
}
