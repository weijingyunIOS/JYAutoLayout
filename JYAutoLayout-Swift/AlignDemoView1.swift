//
//  InnerAlignView.swift
//  JYAutoLayout-Swift
//
//  Created by weijingyun on 16/5/5.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit

class AlignDemoView1: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        let btnSize = CGSize(width: 80, height: 30)
        let followSize = CGSize(width: 100, height: 30)
        
        // 左上
        let tlButton1 = UIButton(title: "Top Left")
        addSubview(tlButton1)
        tlButton1.alignTop(self,c:64).alignLeft(self,c:8).size(btnSize).end()
        
        let tlButton2 = UIButton(title: "V Bottom Left", bgColor: UIColor.orange)
        addSubview(tlButton2)
        tlButton2.top(tlButton1,c:8).alignLeft(tlButton1).size(followSize).end()

        // 中上
        let tcButton1 = UIButton(title: "Top Center")
        addSubview(tcButton1)
        tcButton1.alignTop(self,c:64).centerX(self).size(btnSize).end()

        let tcButton2 = UIButton(title: "V Bottom Center", bgColor: UIColor.orange)
        addSubview(tcButton2)
        tcButton2.top(tcButton1,c:8).centerX(tcButton1).size(btnSize).end()
        
        // 右上
        let trButton1 = UIButton(title: "Top Right")
        addSubview(trButton1)
        trButton1.alignTop(self,c:64).alignRight(self,c:8).size(btnSize).end()
    
        let trButton2 = UIButton(title: "V Bottom Right", bgColor: UIColor.orange)
        addSubview(trButton2)
        trButton2.top(trButton1,c:8).alignRight(trButton1).size(followSize).end()
        
        // 左下
        let blButton1 = UIButton(title: "Bottom Left")
        addSubview(blButton1)
        blButton1.alignLeft(self,c:8).alignBottom(self,c:8).size(btnSize).end()
        
        let blButton2 = UIButton(title: "V Top Left", bgColor: UIColor.orange)
        addSubview(blButton2)
        blButton2.alignLeft(blButton1).bottom(blButton1,c:8).size(followSize).end()

        // 中下
        let bcButton1 = UIButton(title: "Bottom Center")
        addSubview(bcButton1)
        bcButton1.centerX(self).alignBottom(self,c:8).size(btnSize).end()
        
        let bcButton2 = UIButton(title: "V Top Center", bgColor: UIColor.orange)
        addSubview(bcButton2)
        bcButton2.centerX(bcButton1).bottom(bcButton1,c:8).size(followSize).end()

        // 右下
        let brButton1 = UIButton(title: "Bottom Right")
        addSubview(brButton1)
        brButton1.alignRight(self,c:8).alignBottom(self,c:8).size(btnSize).end()
        
        let brButton2 = UIButton(title: "V Top Right", bgColor: UIColor.orange)
        addSubview(brButton2)
        brButton2.alignRight(self,c:8).bottom(brButton1,c:8).size(followSize).end()

        // 左中
        let clButton1 = UIButton(title: "Center Left")
        addSubview(clButton1)
        clButton1.alignLeft(self,c:8).centerY(self).size(btnSize).end()

        let clButton2 = UIButton(title: "V Bottom Left", bgColor: UIColor.orange)
        addSubview(clButton2)
        clButton2.alignLeft(self,c:8).top(clButton1,c:8).size(followSize).end()
        
        let clButton3 = UIButton(title: "V Top Left", bgColor: UIColor.orange)
        addSubview(clButton3)
        clButton3.alignLeft(self,c:8).bottom(clButton1,c:8).size(followSize).end()

        // 中中
        let ccButton1 = UIButton(title: "Center Center")
        addSubview(ccButton1)
        ccButton1.center(self).size(btnSize).end()
        
        let ccButton2 = UIButton(title: "V Bottom Center", bgColor: UIColor.orange)
        addSubview(ccButton2)
        ccButton2.centerX(ccButton1).top(ccButton1,c:8).size(followSize).end()
        
        let ccButton3 = UIButton(title: "V Top Center", bgColor: UIColor.orange)
        addSubview(ccButton3)
        ccButton3.centerX(ccButton1).bottom(ccButton1,c:8).size(followSize).end()

        // 中右
        let crButton1 = UIButton(title: "Center Right")
        addSubview(crButton1)
        crButton1.centerY(self).alignRight(self,c:8).size(btnSize).end()
        
        let crButton2 = UIButton(title: "V Bottom Right", bgColor: UIColor.orange)
        addSubview(crButton2)
        crButton2.alignRight(crButton1).top(crButton1,c:8).size(followSize).end()
        
        let crButton3 = UIButton(title: "V Top Right", bgColor: UIColor.orange)
        addSubview(crButton3)
        crButton3.alignRight(crButton1).bottom(crButton1,c:8).size(followSize).end()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("deinit")
    }
}
