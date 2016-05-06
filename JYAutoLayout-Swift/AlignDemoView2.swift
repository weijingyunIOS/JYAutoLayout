//
//  AlignDemoView2.swift
//  JYAutoLayout-Swift
//
//  Created by weijingyun on 16/5/5.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit

class AlignDemoView2: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        let btnSize = CGSize(width: 40, height: 30)
        // 中心参照按钮
        let centerBtn = UIButton(title: "中心按钮")
        addSubview(centerBtn)
        centerBtn.center(self).size(150, h: 150).end()
        
        // 水平右上
        let htrBtn = UIButton(title: "右上", bgColor: UIColor.orangeColor())
        centerBtn.addSubview(htrBtn)
        htrBtn.left(centerBtn,c:8).alignTop(centerBtn).size(btnSize).end()

        // 水平右中
        let hcrBtn = UIButton(title: "右中", bgColor: UIColor.orangeColor())
        addSubview(hcrBtn)
        hcrBtn.left(centerBtn,c:8).centerY(centerBtn).size(btnSize).end()
        
        // 水平右下
        let hbrBtn = UIButton(title: "右下", bgColor: UIColor.orangeColor())
        addSubview(hbrBtn)
        hbrBtn.left(centerBtn,c:8).alignBottom(centerBtn).size(btnSize).end()

        // 水平左上
        let htlBtn = UIButton(title: "左上", bgColor: UIColor.orangeColor())
        addSubview(htlBtn)
        htlBtn.right(centerBtn,c:8).alignTop(centerBtn).size(btnSize).end()

        // 水平左中
        let hclBtn = UIButton(title: "左中", bgColor: UIColor.orangeColor())
        addSubview(hclBtn)
        hclBtn.right(centerBtn,c:8).centerY(centerBtn).size(btnSize).end()

        // 水平左下
        let hblBtn = UIButton(title: "左下", bgColor: UIColor.orangeColor())
        addSubview(hblBtn)
        hblBtn.right(centerBtn,c:8).alignBottom(centerBtn).size(btnSize).end()

        // MARK: 垂直上下布局
        // 垂直左上
        let vtlBtn = UIButton(title: "左上", bgColor: UIColor.orangeColor())
        addSubview(vtlBtn)
        vtlBtn.alignLeft(centerBtn).bottom(centerBtn,c:8).size(btnSize).end()
        
        // 垂直中上
        let vtcBtn = UIButton(title: "中上", bgColor: UIColor.orangeColor())
        addSubview(vtcBtn)
        vtcBtn.centerX(centerBtn).bottom(centerBtn,c:8).size(btnSize).end()

        // 垂直右上
        let vtrBtn = UIButton(title: "右上", bgColor: UIColor.orangeColor())
        addSubview(vtrBtn)
        vtrBtn.alignRight(centerBtn).bottom(centerBtn,c:8).size(btnSize).end()

        // 垂直左下
        let vblBtn = UIButton(title: "左下", bgColor: UIColor.orangeColor())
        addSubview(vblBtn)
        vblBtn.alignLeft(centerBtn).top(centerBtn,c:8).size(btnSize).end()
        
        // 垂直中下
        let vbcBtn = UIButton(title: "中下", bgColor: UIColor.orangeColor())
        addSubview(vbcBtn)
        vbcBtn.centerX(centerBtn).top(centerBtn,c:8).size(btnSize).end()

        // 垂直右下
        let vbrBtn = UIButton(title: "右下", bgColor: UIColor.orangeColor())
        addSubview(vbrBtn)
        vbrBtn.alignRight(centerBtn).top(centerBtn,c:8).size(btnSize).end()

        // MARK: - 内部按钮
        // 内部按钮
        // 内部左上
        let itlBtn = UIButton(title: "左上", bgColor: UIColor.whiteColor())
        addSubview(itlBtn)
        itlBtn.alignLeft(centerBtn,c:8).alignTop(centerBtn,c:8).size(btnSize).end()
        
        // 内部中上
        let itcBtn = UIButton(title: "中上", bgColor: UIColor.whiteColor())
        addSubview(itcBtn)
        itcBtn.centerX(centerBtn).alignTop(centerBtn,c:8).size(btnSize).end()

        // 内部右上
        let itrBtn = UIButton(title: "右上", bgColor: UIColor.whiteColor())
        addSubview(itrBtn)
        itrBtn.alignRight(centerBtn,c:8).alignTop(centerBtn,c:8).size(btnSize).end()

        // 内部左中
        let iclBtn = UIButton(title: "左中", bgColor: UIColor.whiteColor())
        addSubview(iclBtn)
        iclBtn.alignLeft(centerBtn,c:8).centerY(centerBtn).size(btnSize).end()
        
        // 内部中中
        let iccBtn = UIButton(title: "中中", bgColor: UIColor.whiteColor())
        addSubview(iccBtn)
        iccBtn.center(centerBtn).size(btnSize).end()
        
        // 内部右中
        let icrBtn = UIButton(title: "右中", bgColor: UIColor.whiteColor())
        addSubview(icrBtn)
        icrBtn.alignRight(centerBtn,c:8).centerY(centerBtn).size(btnSize).end()

        // 内部左下
        let iblBtn = UIButton(title: "左下", bgColor: UIColor.whiteColor())
        addSubview(iblBtn)
        iblBtn.alignLeft(centerBtn,c:8).alignBottom(centerBtn,c:8).size(btnSize).end()
        
        // 内部中下
        let ibcBtn = UIButton(title: "中下", bgColor: UIColor.whiteColor())
        addSubview(ibcBtn)
        ibcBtn.centerX(centerBtn).alignBottom(centerBtn,c:8).size(btnSize).end()

        // 垂直右下
        let ibrBtn = UIButton(title: "右下", bgColor: UIColor.whiteColor())
        addSubview(ibrBtn)
         ibrBtn.alignRight(centerBtn,c:8).alignBottom(centerBtn,c:8).size(btnSize).end()
        
    }
   
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("deinit")
    }
}
