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

public extension UIView{
    // MARK: 运行时绑定属性获取对应参数 约束数组 与约束参数
    fileprivate var constraintsList: [NSLayoutConstraint]?{
        
        get{ return objc_getAssociatedObject(self, &UIView_Cons) as? [NSLayoutConstraint] }
        set{
            objc_setAssociatedObject(self, &UIView_Cons, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: 约束集合
    @discardableResult func makeConstraint(_ constraint: ((_ : UIEdgeView) -> Void)) -> [NSLayoutConstraint]? {
        
        let edgeView =  UIEdgeView(self)
        constraint(edgeView)
        return constraintsList
    }
    
    // MARK: 从已添加的约束 查找指定 attribute 的约束  parameter attribute: 约束属性
    @discardableResult func ff_Constraint(_ attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
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
    @discardableResult func ff_Constraint(_ constraintsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
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
     
     :param: edgesView UIEdgeView 类链表结构设置参数
     
     :returns: 约束数组
     */
    fileprivate func ff_edgesView(_ edgesView: UIEdgeView!) -> [NSLayoutConstraint]? {
        
        translatesAutoresizingMaskIntoConstraints = false
        let dict = edgesView.dict
        var currentCons = [NSLayoutConstraint]() //当前添加的约束
        // 遍历添加约束
        for key in dict.allKeys {
            let layout = dict.object(forKey: key) as! JYlayout
            let offset = (key as! String == ffRight || key as! String == ffBootom) ? -layout.offset: layout.offset
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
        edgesView.clear()
        return currentCons;
    }
    
    /**
     约束处理
     end: 添加约束不管以前的约束
     remake: 删除该view的所有约束重新添加
     update: 修改当前所改的约束
     */
    fileprivate func ff_clearLayoutConstraint(_ edgesView: UIEdgeView!) -> [NSLayoutConstraint] {
        
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
                    let layout = dict.object(forKey: key) as! JYlayout
                    cons = ff_removeAttributeConstraints(layout.Attribute1!, cons: cons)
                }
                if edgesView.esize != CGSize(width: -1 , height: -1){
                    cons = ff_removeAttributeConstraints(NSLayoutAttribute.width, cons: cons)
                    cons = ff_removeAttributeConstraints(NSLayoutAttribute.height, cons: cons)
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
    fileprivate func ff_removeCurrentConstraint(_ constraint: NSLayoutConstraint?){
        if constraint == nil {
            return
        }
        self.removeConstraint(constraint!)
        self.superview!.removeConstraint(constraint!)
    }
    fileprivate func ff_removeCurrentConstraints(_ constraints: [NSLayoutConstraint]?){
        if constraints == nil {
            return
        }
        for constraint in constraints!{
            ff_removeCurrentConstraint(constraint)
        }
    }
    
    fileprivate func ff_removeAttributeConstraints(_ attribute: NSLayoutAttribute, cons:[NSLayoutConstraint]?) -> [NSLayoutConstraint]?{
        if (cons == nil) {
            return cons
        }
        let constraint = ff_Constraint(cons!, attribute: attribute)
        if (constraint == nil) {
            return cons
        }
        ff_removeCurrentConstraint(constraint)
        var varcons = cons!
        varcons.remove(at: varcons.index(of: constraint!)!)
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
    fileprivate func ff_positionConstraint(_ attribute1: NSLayoutAttribute , equal: NSLayoutRelation , referView: UIView, attribute2:NSLayoutAttribute , multiplier: CGFloat , offset: CGFloat ) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self , attribute: attribute1, relatedBy: equal, toItem: referView, attribute: attribute2 , multiplier:multiplier , constant: offset)
    }
    
    ///  尺寸约束数组
    ///
    ///  - parameter size: 视图大小
    ///
    ///  - returns: 约束数组
    fileprivate func ff_sizeConstraints(_ size: CGSize) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        if size.width >= 0 {
            cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.width))
        }
        
        if size.height >= 0{
            cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.height))
        }
        return cons
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
enum LayoutType {
    case end
    case remake
    case update
}

// 位移枚举
public struct  Ftlbr: OptionSet {
    
    public let rawValue: Int
    public static let top                  = Ftlbr(rawValue: 1 << 0)
    public static let left                 = Ftlbr(rawValue: 1 << 1)
    public static let bottom               = Ftlbr(rawValue: 1 << 2)
    public static let right                = Ftlbr(rawValue: 1 << 3)
    public static let all:      Ftlbr    = [.top, .left, .bottom, .right]
    public static let untop:    Ftlbr    = [.left, .bottom, .right]
    public static let unleft:   Ftlbr    = [.top, .bottom, .right]
    public static let unbottom: Ftlbr    = [.top, .left, .right]
    public static let unright:  Ftlbr    = [.top, .left, .bottom]
    
    public init(rawValue: Int){
        self.rawValue = rawValue
    }
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
public class UIEdgeView: NSObject {
    
    private weak var view: UIView?
    var dict: NSMutableDictionary = NSMutableDictionary()
    var type: LayoutType = LayoutType.end
    var esize = CGSize(width: -1.0 , height: -1.0)
    
    fileprivate func clear(){
        dict.removeAllObjects()
        esize = CGSize(width: -1.0 , height: -1.0)
        type = LayoutType.end
    }
    
    public init(_ view: UIView) {
        
        self.view = view
    }
    
    // MARK: end remake update 三种约束处理
    @discardableResult public func end() -> [NSLayoutConstraint]?{
        
        if view == nil { return nil }
        type = LayoutType.end
        return view!.ff_edgesView(self)
    }
    
    @discardableResult public func remake() -> [NSLayoutConstraint]?{
        
        if view == nil { return nil }
        type = LayoutType.remake
        return view!.ff_edgesView(self)
    }
    
    @discardableResult public func update() -> [NSLayoutConstraint]?{
        
        if view == nil { return nil }
        type = LayoutType.update
        return view!.ff_edgesView(self)
    }

    
    @discardableResult public func ff_fill(_ v:UIView!) -> UIEdgeView {
        
        let isSuper = view?.superview == v
        if !isSuper {
            top(v, c: 0).left(v, c: 0).bottom(v, c: 0).right(v, c: 0)
        }else{
            alignTop(v, c: 0).alignLeft(v, c: 0).alignBottom(v, c: 0).alignRight(v, c: 0)
        }
        return self
    }
    
    @discardableResult public func ff_more(tlbr: Ftlbr , v:UIView!) -> UIEdgeView {
        
        let isSuper = view?.superview == v
        if !isSuper {
            if tlbr.contains(Ftlbr.top) {top(v, c: 0)}
            if tlbr.contains(Ftlbr.left) {left(v, c: 0)}
            if tlbr.contains(Ftlbr.bottom) {bottom(v, c: 0)}
            if tlbr.contains(Ftlbr.right) {right(v, c: 0)}
        }else{
            
            if tlbr.contains(Ftlbr.top) {alignTop(v, c: 0)}
            if tlbr.contains(Ftlbr.left) {alignLeft(v, c: 0)}
            if tlbr.contains(Ftlbr.bottom) {alignBottom(v, c: 0)}
            if tlbr.contains(Ftlbr.right) {alignRight(v, c: 0)}
        }
        return self
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
    
    @discardableResult public func alignTop(_ v: UIView! , c: CGFloat = 0 ,m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
       
        return top(v, c: c, a: NSLayoutAttribute.top, m: m, e: e, p: p)
    }
    
    
    @discardableResult public func alignLeft(_ v: UIView! , c: CGFloat = 0  , a: NSLayoutAttribute = NSLayoutAttribute.right , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh ) -> UIEdgeView {
     
        return left(v, c: c, a: NSLayoutAttribute.left, m: m, e: e, p: p)
    }
    
    @discardableResult public func alignBottom(_ v: UIView! , c: CGFloat = 0 , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh ) -> UIEdgeView {
        
        return bottom(v, c: c, a: NSLayoutAttribute.bottom, m: m, e: e, p: p)
    }
    
    @discardableResult public func alignRight(_ v: UIView! , c: CGFloat = 0, m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
        
        return right(v, c: c, a: NSLayoutAttribute.right, m: m, e: e, p: p)
    }
    
    @discardableResult public func top(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.bottom , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.top , a2: a, m: m, e: e, p: p)
        dict.setValue(layout, forKey: ffTop)
        return self
    }
    
    @discardableResult public func left(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.right , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.left , a2: a, m: m, e: e , p: p)
        dict.setValue(layout, forKey: ffLeft)
        return self
    }
    
    @discardableResult public func bottom(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.top , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.bottom , a2: a, m: m, e: e, p: p)
        dict.setValue(layout, forKey: ffBootom)
        return self
    }
    
    @discardableResult public func right(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.left , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.right , a2: a, m: m, e: e, p: p)
        dict.setValue(layout, forKey: ffRight)
        return self
    }
    
    @discardableResult public func centerX(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.centerX , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.centerX , a2: a, m: m, e: e, p: p)
        dict.setValue(layout, forKey: ffCenterX)
        return self
    }
    
    @discardableResult public func centerY(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.centerY , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.centerY , a2: a, m: m, e: e, p: p)
        dict.setValue(layout, forKey: ffCenterY)
        return self
    }
    
    @discardableResult public func center(_ v: UIView! , p: CGPoint = CGPoint.zero ) -> UIEdgeView {
        
        centerX(v, c: p.x)
        centerY(v, c: p.y)
        return self
    }
    
    @discardableResult public func height(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.height , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal,  p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.height , a2: a, m: m, e: e, p:p)
        dict.setValue(layout, forKey: ffHeight)
        return self
    }
    
    @discardableResult public func width(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.width , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIEdgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.width , a2: a, m: m, e: e, p: p)
        dict.setValue(layout, forKey: ffWidth)
        return self
    }
    
    @discardableResult public func size (_ v: UIView! , set: CGPoint = CGPoint.zero) -> UIEdgeView {
        height(v, c: set.x)
        width(v, c: set.y)
        return self
    }
    
    @discardableResult public func height(_ h: CGFloat!) -> UIEdgeView {
        esize.height = h
        return self
    }
    
    @discardableResult public func width(_ w: CGFloat!) -> UIEdgeView {
        esize.width = w
        return self
    }
    
    @discardableResult public func size (_ size: CGSize!) -> UIEdgeView {
        esize = size
        return self
    }
    
    @discardableResult public func size (_ w: CGFloat! , h: CGFloat!) -> UIEdgeView {
        esize = CGSize(width: w, height: h)
        return self
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult public func topSet(_ c: CGFloat) -> UIEdgeView{
        return ff_offset(ffTop, c: c)
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult public func leftSet(_ c: CGFloat) -> UIEdgeView{
        return ff_offset(ffLeft, c: c)
        
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult public func bottomSet(_ c: CGFloat) -> UIEdgeView {
        return ff_offset(ffBootom, c: c)
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult public func rightSet(_ c: CGFloat) -> UIEdgeView {
        return ff_offset(ffRight, c: c)
    }
    
    @discardableResult  func ff_offset (_ s: String , c: CGFloat) -> UIEdgeView {
        let laout = dict[s] as? JYlayout
        if laout == nil {
            return self
        }
        laout!.offset = c
        return self
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult public func edgeSet(_ t: CGFloat , l: CGFloat , b: CGFloat , r: CGFloat) -> UIEdgeView{
        return topSet(t).leftSet(l).bottomSet(b).rightSet(r)
    }
    
    /// 如果没有设置参照view 设置此参数无用
    @discardableResult public func edgeSet(_ edge: UIEdgeInsets) -> UIEdgeView {
        return edgeSet(edge.top, l: edge.left, b: edge.bottom, r: edge.right)
    }
}
