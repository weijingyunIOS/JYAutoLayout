//
//  AlignDemoView3.swift
//  JYAutoLayout-Swift
//
//  Created by weijingyun on 16/5/6.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit

class AlignDemoView3: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let updateBtn = UIButton(title: "update")
        addSubview(updateBtn)
        updateBtn.makeConstraint { (make) in
            make.center(self).size(100, h: 100).end()
        }
        updateBtn.addTarget(self, action: #selector(AlignDemoView3.update(_:)), for: UIControlEvents.touchUpInside)
        
        let remakeBtn = UIButton(title: "remake")
        addSubview(remakeBtn)
        remakeBtn.makeConstraint { (make) in
         make.center(self).size(100, h: 100).end()
        }
        remakeBtn.addTarget(self, action: #selector(AlignDemoView3.remake(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func remake(_ btn:UIButton){
        
        btn.isSelected = !btn.isSelected
        btn.makeConstraint { (make) in
            if (btn.isSelected) {
                make.alignLeft(self,c:50).alignTop(self,c:64).size(50, h: 100).remake()
            }else{
                make.center(self).size(100, h: 100).remake()
            }
        }
    }
    
    func update(_ btn:UIButton){
        
        btn.isSelected = !btn.isSelected
        btn.makeConstraint { (make) in
            if (btn.isSelected) {
                make.centerX(self,c:100).size(50, h: 100).update()
            }else{
                make.centerX(self).size(100, h: 100).update()
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print((#file as NSString).lastPathComponent, #function)
    }
}
