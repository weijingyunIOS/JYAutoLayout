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
    // MARK: 运行时绑定属性获取对应参数 约束数组 与约束参数
    private func edgeView() ->UIedgeView{
        var edgeView =  objc_getAssociatedObject(self, &UIView_edgeView) as? UIedgeView
        if (edgeView == nil) {
            edgeView = UIedgeView()
            objc_setAssociatedObject(self, &UIView_edgeView, edgeView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return edgeView!
    }
    
    var constraintsList : [NSLayoutConstraint]?{
        get{ return objc_getAssociatedObject(self, &UIView_Cons) as? [NSLayoutConstraint] }
        set{
            objc_setAssociatedObject(self, &UIView_Cons, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: end remake update 三种约束处理
    public func end() -> [NSLayoutConstraint]?{
        edgeView().type = LayoutType.end
        return ff_edgesView(edgeView())
    }
    
    public func remake() -> [NSLayoutConstraint]?{
        edgeView().type = LayoutType.remake
        return ff_edgesView(edgeView())
    }
    
    public func update() -> [NSLayoutConstraint]?{
        edgeView().type = LayoutType.update
        return ff_edgesView(edgeView())
    }
    
    // MARK: 从已添加的约束 查找指定 attribute 的约束  parameter attribute: 约束属性
    public func ff_Constraint(attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        let cons = constraintsList
        if (cons != nil) {
            return ff_Constraint(cons!, attribute: attribute)
        }
        return nil
    }
    
    ///  从约束数组中查找指定 attribute 的约束
    ///
    ///  - parameter constraintsList: 约束数组
    ///  - parameter attribute:       约束属性
    ///
    ///  - returns: attribute 对应的约束
    public func ff_Constraint(constraintsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraintsList {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
    
    // MARK: 私有类添加移除约束
    /**
     与四周控件的参照关系
     
     :param: edgesView UIedgeView 类链表结构设置参数
     
     :returns: 约束数组
     */
    private func ff_edgesView(edgesView: UIedgeView!) -> [NSLayoutConstraint]? {
        
        translatesAutoresizingMaskIntoConstraints = false
        let dict = edgesView.dict
        var currentCons = [NSLayoutConstraint]() //当前添加的约束
        // 遍历添加约束
        for key in dict.allKeys {
            let layout = dict.objectForKey(key) as! JYlayout
            let offset = (key as! String == ffRight || key as! String == ffBootom) ? -layout.offset : layout.offset
            let constraint = ff_positionConstraint(layout.Attribute1!, equal: layout.Equal, referView: layout.View!, attribute2: layout.Attribute2!, multiplier: layout.Multiplier!, offset: offset)
            constraint.priority = layout.priority;
            currentCons.append(constraint)
        }
        
        // 看是否是指定数值的Size
        if edgesView.esize != CGSize(width: -1 , height: -1){
            currentCons += ff_sizeConstraints(edgesView.esize)
        }
        
        let cons = ff_clearLayoutConstraint(edgesView)
        superview!.addConstraints(currentCons)
        constraintsList = cons + currentCons
        // 置位完成后一出所有绑定属性，以免循环引用
        // objc_removeAssociatedObjects(self)
        edgeView().clear()
        return currentCons;
    }
    
    /**
     约束处理
     end : 添加约束不管以前的约束
     remake : 删除该view的所有约束重新田间
     update : 修改当前所改的约束
     */
    private func ff_clearLayoutConstraint(edgesView: UIedgeView!) -> [NSLayoutConstraint] {
        let dict = edgesView.dict
        let type = edgesView.type
        var cons = constraintsList
        
        switch type {
            case LayoutType.end:
           
            break
                
            case LayoutType.remake:
                ff_removeCurrentConstraints(cons)
                cons = nil
            break
            
            case LayoutType.update:
                if (cons != nil) {
                    for key in dict.allKeys {
                        let layout = dict.objectForKey(key) as! JYlayout
                        cons = ff_removeAttributeConstraints(layout.Attribute1!, cons: cons)
                    }
                    if edgesView.esize != CGSize(width: -1 , height: -1){
                        cons = ff_removeAttributeConstraints(NSLayoutAttribute.Width, cons: cons)
                        cons = ff_removeAttributeConstraints(NSLayoutAttribute.Height, cons: cons)
                    }
                }
            break
        }
        if (cons == nil){
            cons = [NSLayoutConstraint]()
        }
        return cons!
    }
    
    /**
     约束移除
     */
    private func ff_removeCurrentConstraint(constraint : NSLayoutConstraint?){
        if constraint == nil {
            return
        }
        self.removeConstraint(constraint!)
        self.superview!.removeConstraint(constraint!)
    }
    private func ff_removeCurrentConstraints(constraints : [NSLayoutConstraint]?){
        if constraints == nil {
            return
        }
        for constraint in constraints!{
            ff_removeCurrentConstraint(constraint)
        }
    }
    
    private func ff_removeAttributeConstraints(attribute : NSLayoutAttribute, cons:[NSLayoutConstraint]?) -> [NSLayoutConstraint]?{
        if (cons == nil) {
            return cons
        }
        let constraint = ff_Constraint(cons!, attribute: attribute)
        if (constraint == nil) {
             return cons
        }
        ff_removeCurrentConstraint(constraint)
        var varcons = cons!
        varcons.removeAtIndex(varcons.indexOf(constraint!)!)
        return varcons
    }
    
    /**
     单一位置约束
     :param: attribute1  self 的 参照属性
     :param: referView   参照视图
     :param: attribute2  参照属性
     :param: offset      偏移
     :returns: 约束
     */
    private func ff_positionConstraint(attribute1: NSLayoutAttribute , equal : NSLayoutRelation , referView: UIView, attribute2:NSLayoutAttribute , multiplier : CGFloat , offset: CGFloat ) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self , attribute: attribute1, relatedBy: equal, toItem: referView, attribute: attribute2 , multiplier:multiplier , constant: offset)
    }

    ///  尺寸约束数组
    ///
    ///  - parameter size: 视图大小
    ///
    ///  - returns: 约束数组
    private func ff_sizeConstraints(size: CGSize) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        if size.width >= 0 {
            cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: size.width))
        }
        
        if size.height >= 0{
            cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: size.height))
        }
        return cons
    }

    
    
    // MARK: 设置需要的约束参数 只是发方便调用
    /**
     参数描述 基本可不填
     
     :param: v 参考view
     :param: c 偏移 量
     :param: a 默认底边 如果参考View 是父控件就是 上边
     :param: m 比例系数，默认为 1.0
     :param: e 大于等于小于 默认 等于
     
     :returns: self
     */
    
    public func ff_fill(v:UIView!) -> UIView {
        let isSuper = self.superview == v
        if !isSuper {
            top(v).left(v).bottom(v).right(v)
        }else{
            alignTop(v).alignLeft(v).alignBottom(v).alignRight(v)
        }
        return self
    }
    
    public func ff_more(tlbr tlbr : ff_tlbr , v:UIView!) -> UIView {
        
        let isSuper = self.superview == v
        if !isSuper {
            if tlbr & ff_tlbr.top == ff_tlbr.top {top(v) }
            if tlbr & ff_tlbr.left == ff_tlbr.left { left(v)}
            if tlbr & ff_tlbr.bottom == ff_tlbr.bottom { bottom(v) }
            if tlbr & ff_tlbr.right == ff_tlbr.right { right(v) }
        }else{
            if tlbr & ff_tlbr.top == ff_tlbr.top {alignTop(v) }
            if tlbr & ff_tlbr.left == ff_tlbr.left { alignLeft(v)}
            if tlbr & ff_tlbr.bottom == ff_tlbr.bottom { alignBottom(v) }
            if tlbr & ff_tlbr.right == ff_tlbr.right { alignRight(v) }
        }
        return self
    }
    
    public func top(v:UIView! , c : CGFloat = 0 , m : CGFloat = 1.0 , a : NSLayoutAttribute = NSLayoutAttribute.Bottom ,  e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIView {
        edgeView().top(v, c: c, a: a, m: m, e: e, p: p)
        return self
    }
    
    public func alignTop(v:UIView! , c : CGFloat = 0 ,m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIView {
        edgeView().top(v, c: c, a: NSLayoutAttribute.Top, m: m, e: e, p: p)
        return self
    }
    
    public func left(v:UIView! , c : CGFloat = 0 , m : CGFloat = 1.0 , a : NSLayoutAttribute = NSLayoutAttribute.Right , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh ) -> UIView {
        edgeView().left(v, c: c, a : a, m: m, e: e, p: p)
        return self
    }
    
    public func alignLeft(v:UIView! , c : CGFloat = 0  , a : NSLayoutAttribute = NSLayoutAttribute.Right , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh ) -> UIView {
        edgeView().left(v, c: c, a: NSLayoutAttribute.Left, m: m, e: e, p: p)
        return self
    }

    public func bottom(v:UIView! , c : CGFloat = 0 , a : NSLayoutAttribute = NSLayoutAttribute.Top, m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh ) -> UIView {
        edgeView().bottom(v, c: c, a: a, m: m, e: e, p: p)
        return self
    }
    
    public func alignBottom(v:UIView! , c : CGFloat = 0 , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh ) -> UIView {
        edgeView().bottom(v, c: c, a: NSLayoutAttribute.Bottom, m: m, e: e, p: p)
        return self
    }

    public func right(v:UIView! , c : CGFloat = 0, m : CGFloat = 1.0 , a : NSLayoutAttribute = NSLayoutAttribute.Left, e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIView {
        edgeView().right(v, c: c, a: a, m: m, e: e, p: p)
        return self
    }
    
    public func alignRight(v:UIView! , c : CGFloat = 0, m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIView {
        edgeView().right(v, c: c, a: NSLayoutAttribute.Right, m: m, e: e, p: p)
        return self
    }

    public func centerX(v:UIView! , c : CGFloat = 0 , a : NSLayoutAttribute = NSLayoutAttribute.CenterX , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIView {
        edgeView().centerX(v, c: c, a: a, m: m, e: e, p: p)
        return self
    }

    public func centerY(v:UIView! , c : CGFloat = 0 , a : NSLayoutAttribute = NSLayoutAttribute.CenterY , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal,  p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIView {
        edgeView().centerY(v, c: c, a: a, m: m, e: e, p: p)
        return self
    }

    public func center(v:UIView! , p : CGPoint = CGPointZero ) -> UIView {
        edgeView().center(v, p: p)
        return self
    }

    public func height(v:UIView! , c : CGFloat = 0 , a : NSLayoutAttribute = NSLayoutAttribute.Height , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal,  p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIView {
        edgeView().height(v, c: c, a: a, m: m, e: e, p: p)
        return self
    }

    public func width(v:UIView! , c : CGFloat = 0 , a : NSLayoutAttribute = NSLayoutAttribute.Width , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal,  p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIView {
        edgeView().width(v, c: c, a: a, m: m, e: e, p: p)
        return self
    }

    public func size (v:UIView! , set : CGPoint = CGPointZero) -> UIView {
        edgeView().size(v, set: set)
        return self
    }

    public func height(h : CGFloat!) -> UIView {
        edgeView().height(h)
        return self
    }

    public func width(w : CGFloat!) -> UIView {
        edgeView().width(w)
        return self
    }
    
    public func size (size : CGSize!) -> UIView {
        edgeView().size(size)
        return self
    }

    public func size (w : CGFloat! , h : CGFloat!) -> UIView {
        edgeView().size(w,h:h)
        return self
    }

    /// 如果没有设置参照view 设置此参数无用
    public func topSet(c : CGFloat) -> UIView{
        edgeView().topSet(c)
        return self
    }
    
    /// 如果没有设置参照view 设置此参数无用
    public func leftSet(c : CGFloat) -> UIView{
        edgeView().leftSet(c)
        return self
    }

    /// 如果没有设置参照view 设置此参数无用
    public func bottomSet(c : CGFloat) -> UIView {
        edgeView().bottomSet(c)
        return self
    }

    /// 如果没有设置参照view 设置此参数无用
    public func rightSet(c : CGFloat) -> UIView {
        edgeView().rightSet(c)
        return self
    }

    private func ff_offset (s: String , c: CGFloat) -> UIView {
        edgeView().ff_offset(s,c:c)
        return self
    }

    /// 如果没有设置参照view 设置此参数无用
    public func edgeSet(t: CGFloat , l : CGFloat , b : CGFloat , r : CGFloat) -> UIView{
        edgeView().edgeSet(t, l: l, b: b, r: r)
        return self
    }

    /// 如果没有设置参照view 设置此参数无用
    public func edgeSet(edge : UIEdgeInsets) -> UIView {
        edgeView().edgeSet(edge)
        return self
    }

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
private enum LayoutType {
    case end
    case remake
    case update
}

// MARK: swift 貌似关于位移枚举 没啥解决方案 在网上找的 用结构体实现位移枚举
public struct ff_tlbr  {
    var value: UInt = 0
    init(_ value: UInt) { self.value = value }
    func toRaw() -> UInt { return self.value }
    func getLogicValue() -> Bool { return self.value != 0 }
    
    static func fromRaw(raw: UInt) -> ff_tlbr? { return ff_tlbr(raw) }
    static func fromMask(raw: UInt) -> ff_tlbr { return ff_tlbr(raw) }
    
    public  static var top : ff_tlbr   { return ff_tlbr(1 << 0) }
    public  static var left : ff_tlbr  { return ff_tlbr(1 << 1) }
    public  static var bottom : ff_tlbr   { return ff_tlbr(1 << 2) }
    public  static var right : ff_tlbr   { return ff_tlbr(1 << 3) }
    public  static var all : ff_tlbr   { return ff_tlbr(UInt.max) }
    public  static var untop : ff_tlbr   { return ff_tlbr.left | ff_tlbr.bottom | ff_tlbr.right }
    public  static var unleft : ff_tlbr   { return ff_tlbr.top | ff_tlbr.bottom | ff_tlbr.right }
    public  static var unbottom : ff_tlbr   { return ff_tlbr.left | ff_tlbr.top | ff_tlbr.right }
    public  static var unright : ff_tlbr   { return ff_tlbr.left | ff_tlbr.bottom | ff_tlbr.top }
    
}

public func == (lhs: ff_tlbr, rhs: ff_tlbr) -> Bool     { return lhs.value == rhs.value }
public func | (lhs: ff_tlbr, rhs: ff_tlbr) -> ff_tlbr { return ff_tlbr(lhs.value | rhs.value) }
public func & (lhs: ff_tlbr, rhs: ff_tlbr) -> ff_tlbr { return ff_tlbr(lhs.value & rhs.value) }
public func ^ (lhs: ff_tlbr, rhs: ff_tlbr) -> ff_tlbr { return ff_tlbr(lhs.value ^ rhs.value) }

// MARK: 约束参数类 记录一个约束的所有参数
private class JYlayout : NSObject {
    var View    : UIView?
    var Attribute1 : NSLayoutAttribute?
    var Attribute2 : NSLayoutAttribute?
    var Multiplier : CGFloat?
    var Equal = NSLayoutRelation.Equal
    var offset : CGFloat
    var priority : UILayoutPriority
    
    init(v:UIView! , c : CGFloat, a1 : NSLayoutAttribute  , a2 : NSLayoutAttribute, m : CGFloat, e : NSLayoutRelation, p : UILayoutPriority) {
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
private class UIedgeView : NSObject {
    var dict : NSMutableDictionary = NSMutableDictionary()
    var type : LayoutType = LayoutType.end
    var esize = CGSize(width: -1.0 , height: -1.0)
    
//    private static let instance: UIedgeView = {
//       let edgeView = UIedgeView()
//        return edgeView
//    }()
    
    private func clear(){
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
    private func top(v:UIView! , c : CGFloat , a : NSLayoutAttribute = NSLayoutAttribute.Bottom , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.Top , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffTop)
        return self
    }
    
    private func left(v:UIView! , c : CGFloat  , a : NSLayoutAttribute = NSLayoutAttribute.Right , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.Left , a2: a, m: m, e: e , p: p)
        dict .setValue(layout, forKey: ffLeft)
        return self
    }
    
    private func bottom(v:UIView! , c : CGFloat  , a : NSLayoutAttribute = NSLayoutAttribute.Top , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.Bottom , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffBootom)
        return self
    }
    
    private func right(v:UIView! , c : CGFloat  , a : NSLayoutAttribute = NSLayoutAttribute.Left , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.Right , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffRight)
        return self
    }
    
    private func centerX(v:UIView! , c : CGFloat  , a : NSLayoutAttribute = NSLayoutAttribute.CenterX , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.CenterX , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffCenterX)
        return self
    }
    
    private func centerY(v:UIView! , c : CGFloat  , a : NSLayoutAttribute = NSLayoutAttribute.CenterY , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.CenterY , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffCenterY)
        return self
    }
    
    private func center(v:UIView! , p : CGPoint = CGPointZero ) -> UIedgeView {
        centerX(v, c: p.x)
        centerY(v, c: p.y)
        return self
    }
    
    private func height(v:UIView! , c : CGFloat = 0 , a : NSLayoutAttribute = NSLayoutAttribute.Height , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal,  p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.Height , a2: a, m: m, e: e, p:p)
        dict .setValue(layout, forKey: ffHeight)
        return self
    }
    
    private func width(v:UIView! , c : CGFloat = 0 , a : NSLayoutAttribute = NSLayoutAttribute.Width , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.Width , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffWidth)
        return self
    }
    
    private func size (v:UIView! , set : CGPoint = CGPointZero) -> UIedgeView {
        height(v, c: set.x)
        width(v, c: set.y)
        return self
    }
    
    private func height(h : CGFloat!) -> UIedgeView {
        esize.height = h
        return self
    }
    
    private func width(w : CGFloat!) -> UIedgeView {
        esize.width = w
        return self
    }
    
    private func size (size : CGSize!) -> UIedgeView {
        esize = size
        return self
    }
    
    private func size (w : CGFloat! , h : CGFloat!) -> UIedgeView {
        esize = CGSize(width: w, height: h)
        return self
    }
    
    /// 如果没有设置参照view 设置此参数无用
    private func topSet(c : CGFloat) -> UIedgeView{
        return ff_offset(ffTop, c: c)
    }
    
    /// 如果没有设置参照view 设置此参数无用
    private func leftSet(c : CGFloat) -> UIedgeView{
        return ff_offset(ffLeft, c: c)
        
    }
    
    /// 如果没有设置参照view 设置此参数无用
    private func bottomSet(c : CGFloat) -> UIedgeView {
        return ff_offset(ffBootom, c: c)
    }
    
    /// 如果没有设置参照view 设置此参数无用
    private func rightSet(c : CGFloat) -> UIedgeView {
        return ff_offset(ffRight, c: c)
    }
    
    private func ff_offset (s: String , c: CGFloat) -> UIedgeView {
        let laout = dict[s] as? JYlayout
        if laout == nil {
            return self
        }
        laout!.offset = c
        return self
    }
    
    /// 如果没有设置参照view 设置此参数无用
    private func edgeSet(t: CGFloat , l : CGFloat , b : CGFloat , r : CGFloat) -> UIedgeView{
        return topSet(t).leftSet(l).bottomSet(b).rightSet(r)
    }
    
    /// 如果没有设置参照view 设置此参数无用
    private func edgeSet(edge : UIEdgeInsets) -> UIedgeView {
        return edgeSet(edge.top, l: edge.left, b: edge.bottom, r: edge.right)
    }
}