//
//  WideHightAlignment.swift
//  FFAutoLayout iOS Examples
//
//  Created by wei_jingyun on 15/7/1.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit

class WideHightAlignment: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let centerBtn = UIButton(title: "与self中心对齐 ", bgColor: UIColor.redColor())
        addSubview(centerBtn)
        centerBtn.center(self).size(200, h: 200).end();
        
        let leftTop = UIButton(title: "WH参考redView", bgColor: UIColor.blueColor())
        addSubview(leftTop)
        leftTop.alignTop(self,c:64).alignLeft(self).width(centerBtn, m: 0.5).height(centerBtn,m:0.5).end()
        
        let rightTop = UIButton(title: "WH与左上等宽高", bgColor: UIColor.blueColor())
        addSubview(rightTop)
        rightTop.size(leftTop).alignTop(self,c: 64).alignRight(self).end()

        let rightBottom = UIButton(title: "WH与左上等宽高", bgColor: UIColor.blueColor())
        addSubview(rightBottom)
        rightBottom.alignBottom(self).alignRight(self).size(leftTop).end()
    
        let leftBottom = UIButton(title: "WH与左上等宽高", bgColor: UIColor.blueColor())
        addSubview(leftBottom)
        rightBottom.alignBottom(self).alignLeft(self).size(leftTop).end()

        // 以下为对齐
        let centerTop = UIButton(title: "centerTop", bgColor: UIColor.blueColor())
        addSubview(centerTop)
        centerTop.center(leftTop).size(50, h: 50).end()
        
        let centerleft = UIButton(title: "centerleft", bgColor: UIColor.blueColor())
        addSubview(centerleft)
        centerleft.centerX(leftTop).centerY(centerBtn, c: 100).size(50, h: 50).end()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit{
        print("deinit")
    }
}