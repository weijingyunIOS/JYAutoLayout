//
//  UIView+AutoLayout.swift
//  JYAutoLayout-Swift
//
//  Created by weijingyun on 16/5/5.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit

// MARK:- 枚举对应 end remake update
public let  priorityHighTop = (UILayoutPriority)(UILayoutPriorityDefaultHigh + 1);
public let  priorityHigh = UILayoutPriorityDefaultHigh;
public let  priorityMedium = (UILayoutPriority)(500);
public let  priorityLow = UILayoutPriorityDefaultLow;
public let  priorityRequired = UILayoutPriorityRequired;
public let  priorityFittingSizeLevel = UILayoutPriorityFittingSizeLevel;

private var UIView_Cons = "UIView_Cons"
private var UIView_edgeView = "UIView_edgeView"

extension UIView{
  
    // MARK: end remake update 三种约束处理
    @discardableResult public func makeConstraints(_ constraint:((_: UIedgeView) -> Void))-> [NSLayoutConstraint]? {

        let edgeView = UIedgeView(self)
        constraint(edgeView)
        return nil
    }
    
//    @discardableResult public func end() -> [NSLayoutConstraint]? {
//       
//        return nil
//    }
//    
//    @discardableResult public func remake() -> [NSLayoutConstraint]? {
//        return nil
//    }
//    
//    @discardableResult public func update() -> [NSLayoutConstraint]?{
//        return nil
//    }

}


// MARK:- ff_edgesView 参数设置相关类和方法

let ffTop = "fftop"
let ffLeft = "ffLeft"
let ffRight = "ffRight"
let ffBootom = "ffBootom"
let ffCenterX = "ffCenterX"
let ffCenterY = "ffCenterY"
let ffHeight = "ffHeight"
let ffWidth = "ffWidth"

// MARK:- 枚举对应 end remake update
enum LayoutType {
    case end
    case remake
    case update
}

// 位移枚举
struct Ftlbr: OptionSet {
    
    let rawValue: Int
    static let top                = Ftlbr(rawValue: 1 << 0)
    static let left               = Ftlbr(rawValue: 1 << 1)
    static let bottom             = Ftlbr(rawValue: 1 << 2)
    static let right              = Ftlbr(rawValue: 1 << 3)
    static let all:      Ftlbr    = [.top, .left, .bottom, .right]
    static let untop:    Ftlbr    = [.top, .left, .bottom, .right]
    static let unleft:   Ftlbr    = [.top, .left, .bottom, .right]
    static let unbottom: Ftlbr    = [.top, .left, .bottom, .right]
    static let unright:  Ftlbr    = [.top, .left, .bottom, .right]
}


// MARK: 约束参数类 记录一个约束的所有参数
private class JYlayout: NSObject {
    
    var View: UIView?
    var Attribute1: NSLayoutAttribute?
    var Attribute2: NSLayoutAttribute?
    var Multiplier: CGFloat?
    var Equal = NSLayoutRelation.equal
    var offset: CGFloat
    var priority: UILayoutPriority
    
    init(v:UIView! , c: CGFloat, a1: NSLayoutAttribute  , a2: NSLayoutAttribute, m: CGFloat, e: NSLayoutRelation, p: UILayoutPriority) {
        View =  v
        Multiplier = m
        Attribute1 = a1
        Attribute2 = a2
        Equal = e
        offset = c
        priority = p
    }
}

// MARK: 设置需要的约束参数
public class UIedgeView: NSObject {
    
    let view: UIView
    var dict: NSMutableDictionary = NSMutableDictionary()
    var type: LayoutType = LayoutType.end
    var esize = CGSize(width: -1.0 , height: -1.0)
    
    init(_ view: UIView) {
        self.view = view
    }
    
    fileprivate func clear(){
        dict .removeAllObjects()
        esize = CGSize(width: -1.0 , height: -1.0)
        type = LayoutType.end
    }
    
    /**
     参数描述 基本可不填
     
     :param: v 参考view
     :param: c 偏移 量
     :param: a 默认底边 如果参考View 是父控件就是 上边
     :param: m 比例系数，默认为 1.0
     :param: e 大于等于小于 默认 等于
     
     :returns: self
     */
    @discardableResult func top(_ v: UIView! , c: CGFloat , a: NSLayoutAttribute = NSLayoutAttribute.bottom , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.top , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffTop)
        return self
    }
    
    @discardableResult func left(_ v: UIView! , c: CGFloat  , a: NSLayoutAttribute = NSLayoutAttribute.right , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.left , a2: a, m: m, e: e , p: p)
        dict .setValue(layout, forKey: ffLeft)
        return self
    }
    
    @discardableResult func bottom(_ v: UIView! , c: CGFloat  , a: NSLayoutAttribute = NSLayoutAttribute.top , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.bottom , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffBootom)
        return self
    }
    
    @discardableResult func right(_ v: UIView! , c: CGFloat  , a: NSLayoutAttribute = NSLayoutAttribute.left , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.right , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffRight)
        return self
    }
    
    @discardableResult func centerX(_ v: UIView! , c: CGFloat  , a: NSLayoutAttribute = NSLayoutAttribute.centerX , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.centerX , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffCenterX)
        return self
    }
    
    @discardableResult func centerY(_ v: UIView! , c: CGFloat  , a: NSLayoutAttribute = NSLayoutAttribute.centerY , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.centerY , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffCenterY)
        return self
    }
    
    @discardableResult func center(_ v:UIView! , p: CGPoint = CGPoint.zero ) -> UIedgeView {
        centerX(v, c: p.x)
        centerY(v, c: p.y)
        return self
    }
    
    @discardableResult func height(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.height , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal,  p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.height , a2: a, m: m, e: e, p:p)
        dict .setValue(layout, forKey: ffHeight)
        return self
    }
    
    @discardableResult func width(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.width , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.width , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffWidth)
        return self
    }
    
    @discardableResult func size (_ v: UIView! , set: CGPoint = CGPoint.zero) -> UIedgeView {
        height(v, c: set.x)
        width(v, c: set.y)
        return self
    }
    
    @discardableResult func height(_ h: CGFloat!) -> UIedgeView {
        esize.height = h
        return self
    }
    
    @discardableResult func width(_ w: CGFloat!) -> UIedgeView {
        esize.width = w
        return self
    }
    
    @discardableResult func size (_ size: CGSize!) -> UIedgeView {
        esize = size
        return self
    }
    
    @discardableResult func size (_ w: CGFloat! , h: CGFloat!) -> UIedgeView {
        esize = CGSize(width: w, height: h)
        return self
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult  func topSet(_ c: CGFloat) -> UIedgeView{
        return ff_offset(ffTop, c: c)
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult  func leftSet(_ c: CGFloat) -> UIedgeView{
        return ff_offset(ffLeft, c: c)
        
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult  func bottomSet(_ c: CGFloat) -> UIedgeView {
        return ff_offset(ffBootom, c: c)
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult  func rightSet(_ c: CGFloat) -> UIedgeView {
        return ff_offset(ffRight, c: c)
    }
    
    @discardableResult  func ff_offset (_ s: String , c: CGFloat) -> UIedgeView {
        let laout = dict[s] as? JYlayout
        if laout == nil {
            return self
        }
        laout!.offset = c
        return self
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult  func edgeSet(_ t: CGFloat , l: CGFloat , b: CGFloat , r: CGFloat) -> UIedgeView{
        return topSet(t).leftSet(l).bottomSet(b).rightSet(r)
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult  func edgeSet(_ edge: UIEdgeInsets) -> UIedgeView {
        return edgeSet(edge.top, l: edge.left, b: edge.bottom, r: edge.right)
    }
}
