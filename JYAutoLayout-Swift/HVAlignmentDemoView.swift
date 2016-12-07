//
//  HVAlignmentDemoView.swift
//  FFAutoLayout iOS Examples
//
//  Created by wei_jingyun on 15/6/29.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit
class HVAlignmentDemoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        // 上左
//        let topBtn = UIButton(title: "上", bgColor: UIColor.red)
//        addSubview(topBtn)
//        topBtn.ff_more(tlbr: Ftlbr.unbottom, v: self).topSet(64).height(50).end()
//        
//        let leftBtn = UIButton(title: "左", bgColor: UIColor.orange)
//        addSubview(leftBtn)
//        leftBtn.ff_more(tlbr: Ftlbr.unright, v: self).topSet(64).width(30).end()
//
//        // 右下
//        let rightBtn = UIButton(title: "右", bgColor: UIColor.blue)
//        addSubview(rightBtn)
//        rightBtn.ff_more(tlbr: Ftlbr.unleft, v: self).topSet(64).width(30).end()
//
//        let bottomBtn = UIButton(title: "下", bgColor: UIColor.brown)
//        addSubview(bottomBtn)
//        bottomBtn.ff_more(tlbr: Ftlbr.untop, v: self).height(50).end()
//
//        let demo1 = UIButton(title: "左上固定大小", bgColor: UIColor.red)
//        addSubview(demo1)
//        demo1.top(topBtn,c: 20).left(leftBtn,c:20).size(80, h: 80).end()
//
//        let demo2 = UIButton(title: "右上固定大小", bgColor: UIColor.red)
//        addSubview(demo2)
//        demo2.top(topBtn,c: 20).right(rightBtn,c:20).size(CGSize(width: 80, height: 80)).end()
//        
//        let demo3 = UIButton(title: "左下固定大小", bgColor: UIColor.red)
//        addSubview(demo3)
//        demo3.left(leftBtn,c: 30).bottom(bottomBtn,c:30).size(70, h: 50).end()
//    
//        let demo4 = UIButton(title: "右下上固定大小", bgColor: UIColor.red)
//        addSubview(demo4)
//        demo4.bottom(bottomBtn,c: 30).right(rightBtn,c:50).size(50, h: 50).end()
//       
//        let demo5 = UIButton(title: "四边距离", bgColor: UIColor.orange)
//        addSubview(demo5)
//        demo5.top(topBtn).bottom(bottomBtn).left(leftBtn).right(rightBtn).edgeSet(100, l: 100, b: 100, r: 100).end()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("deinit")
    }
}
