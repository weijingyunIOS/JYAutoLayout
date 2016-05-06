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
        updateBtn.center(self).size(100, h: 100).end()
        updateBtn.addTarget(self, action: #selector(AlignDemoView3.update(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let remakeBtn = UIButton(title: "remake")
        addSubview(remakeBtn)
        remakeBtn.center(self).size(100, h: 100).end()
        remakeBtn.addTarget(self, action: #selector(AlignDemoView3.remake(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func remake(btn:UIButton){
        btn.selected = !btn.selected
        if (btn.selected) {
            btn.alignLeft(self,c:50).alignTop(self,c:64).size(50, h: 100).remake()
        }else{
            btn.center(self).size(100, h: 100).remake()
        }
    }
    
    func update(btn:UIButton){
        btn.selected = !btn.selected
        if (btn.selected) {
             btn.centerX(self,c:100).size(50, h: 100).update()
        }else{
             btn.centerX(self).size(100, h: 100).update()
        }
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("deinit")
    }
}