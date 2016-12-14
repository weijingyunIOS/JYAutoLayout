# JYAutoLayout
使用Swift 对AutoLayout的轻量级封装简单好用，功能强大完善 
![enter image description here](http://images2015.cnblogs.com/blog/737816/201612/737816-20161213104937589-48017836.png)

###支持 CocoaPods
	
	pod 'JYAutoLayout'

如图所示，所有橙色 和 白色的View 均相对于灰色的大View 而每个view的布局只需要短短的一行代码
    
       UIedgeView(htrBtn).left(centerBtn,c:8).alignTop(centerBtn).size(btnSize).end()
       

下面将会讲封装的思路以及使用介绍：

###1.NSLayoutConstraint

       convenience init(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toItem view2: AnyObject?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat)
       这是一条约束的创建，它的约束关系是 view1.attr1 < = > view2.attr2 * multiplier + c
       	所以我们可以看到决定一个View1的某条约束所需的参数有：
    var View2    : UIView?                    相对于哪个view 即view2
    var Attribute1 : NSLayoutAttribute?	    view1  的NSLayoutAttribute
    var Attribute2 : NSLayoutAttribute?		view2  的NSLayoutAttribute
    var Multiplier : CGFloat?					比例系数
    var Equal = NSLayoutRelation.Equal        大于 等于 小于
    var offset : CGFloat                      偏移 
    var priority : UILayoutPriority           当然还有当前约束的优先级
  
  
	
###2.NSLayoutAttribute 包含有		

    case Left                     	   //左侧
	case Right                        //右侧
	case Top                          //上方
	case Bottom                       //下方
	case Leading                      //首部
	case Trailing                     //尾部
	case Width                        //宽度
	case Height                       //高度
	case CenterX                      //X轴中心
	case CenterY                      //Y轴中心
	case Baseline                     //文本底标线
	case NotAnAttribute               //没有属性
	在iOS8.0下又多了 一些边界属性
    case LeftMargin
    case RightMargin
    case TopMargin
    case BottomMargin
    case LeadingMargin
    case TrailingMargin
    case CenterXWithinMargins
    case CenterYWithinMargins
    
    注：Left/Right 和 Leading/Trailing的区别是Left/Right永远是指左右，而Leading/Trailing在某些从右至左习惯的地区会变成，leading是右边，trailing是左边。
    
###3.简化封装
	
	以view的上边为例我们可以提供下面一个方法来表示一条约束参数
	private func top(v:UIView! , c : CGFloat , a : NSLayoutAttribute = NSLayoutAttribute.Bottom , m : CGFloat = 1.0 , e : NSLayoutRelation = NSLayoutRelation.Equal, p : UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
       
    }
    view的top 与 v 的 a * m + c  当然还有优先级
    swift有个非常好的地方，那就是只要设置了默认参数就可以不用传该参数，而在我们实际使用中 一般都是 等于 而比例细数也基本 是1.0，所以通常 只要设置 v（view）c (偏移) a(对应的边)即可，而优先级也基本不使用。
    
    又考虑到 top 对 top 与 top 对 Bottom 是极为常见的所以又以方法名来区分 以 alignTop方法来表示 top 对 top关系 而 top方法默认表示 top 对 Bottom关系 当然top方法仍可以传入NSLayoutAttribute参数，这样％90的情况下我们只需要设置两个参数 view 与 c 就可以描述一条参数。如： htrBtn.left(centerBtn,c:8)
   
    同理对 Bottom Right Left  Width Height CenterX CenterY做了处理。
    
###4.链式编程的实现

	swift的方法调用都是点语法，再也不像OC那样需要［］,我们只需要在一个方法结束时返回self 就可以无限调用 
	 @discardableResult  func top(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.bottom , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.top , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffTop)
        return self
    }
    
###5.约束的添加 end() remake() update()

	UIedgeView(htrBtn).left(centerBtn,c:8).alignTop(centerBtn).size(btnSize).end()
	对于这么一个布局 htrBtn.left(centerBtn,c:8).alignTop(centerBtn).size(btnSize) 都是约束的准备只是将约束所需要的参数保存到了UIedgeView这么一个对象中(不要吐槽我的取名)
	
    而 end() remake() update() 才是添加相应的约束
    end()      什么都不管只管添加约束
    remake()   会将之前的约束全部删除，重新添加
    update()   会根据当前代码所设计到的约束，而删除对应约束，比如 btn.centerX(self).size(100, h: 100).update() 它涉及到了 centerX Width Height 的约束那么它会将之前添加的关于 centerX Width Height 的所有约束删除然后添加。
    
    注意：1.remake() update() 删除约束使用的是以下方法：
    public func removeConstraint(constraint: NSLayoutConstraint) // This method will be deprecated in a future release and should be avoided.  Instead set NSLayoutConstraint's active property to NO.
    这个方法将会在将来的版本中被弃用,应该避免。苹果也不太建议删除约束再添加，如果有约束改变应当记录约束直接修改，可以参考Demo中的AnimDemoView1，或者添加多个约束使用修改优先级来达到改变的目的，可以参考Demo中的AnimDemoView2
    	
    	2.不要使用 btn.centerX(self).centerX(view2).end() 这种写法是错误的，有效约束只会是centerX(view2)。如有需要应当如下：
    	 btn.makeConstraint { (make) in
            make.centerX(reference1,p:priorityMedium).end()
            make.centerX(reference2,p:priorityHigh).end()
        }
    
    
###6.约束的查找与记录
	
	上面提到了 取出对应约束进行修改，那么如何取出对应约束。
	UIedgeView(btn).centerX(reference1,p:priorityMedium).end()
    let cons ＝ UIedgeView(btn).centerX(reference2,p:priorityHigh).end()
    end() remake() update() 执行后都会返回一个当前添加的约束数组，注意是当前添加的约束数组不是改View的所有约束数组(所有约束数组被记录在了constraintsList属性我设置的是private)
    
        public func ff_Constraint(constraintsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraintsList {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
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
    
    注意：在实际中一个约束属性可能有多个约束不是唯一的，这也是出现约束冲突的原因如：
     UIedgeView(btn).centerX(reference1,p:priorityMedium).end()
     UIedgeView(btn).centerX(reference2,p:priorityHigh).end()
     关于 centerX 的约束会有两条如果采用 下面方法从view的约束中查找centerX约束 不会反回数组而回返回第一个找到的，如果需要请在写约束时就拿到它
     // MARK: 从已添加的约束 查找指定 attribute 的约束  parameter attribute: 约束属性
    public func ff_Constraint(attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        let cons = constraintsList
        if (cons != nil) {
            return ff_Constraint(cons!, attribute: attribute)
        }
        return nil
    }
    
    
###7.提供的方法说明

	top         		默认 top 对 bottom
	alignTop    	    top 对 top
	left				默认 left 对 right
    alignLeft			left 对 left
    bottom				默认 bottom 对 top
	alignBottom		    bottom 对 bottom
	right				默认 right 对 left
	alignRight			right 对 right
	centerX				默认 centerX 对 centerX	
	centerY				默认 centerY 对 centerY	
	center				默认 centerX 对 centerX centerY 对 centerY
	height				有对view 的 height 也有提供 数字 50
	width				有对view 的 width 也有提供  数字 50
	size				有对view 的 width height 也有提供 CGsize
	
	方法的参数描述
	@discardableResult  func top(_ v: UIView! , c: CGFloat = 0 , a: NSLayoutAttribute = NSLayoutAttribute.bottom , m: CGFloat = 1.0 , e: NSLayoutRelation = NSLayoutRelation.equal, p: UILayoutPriority = UILayoutPriorityDefaultHigh) -> UIedgeView {
        
        let layout = JYlayout(v: v, c: c, a1:NSLayoutAttribute.top , a2: a, m: m, e: e, p: p)
        dict .setValue(layout, forKey: ffTop)
        return self
    }
    
    v ：参照的view
    c : 偏移
    m : 比例系数
    a : 参照view的NSLayoutAttribute
    e : NSLayoutRelation.Equal 大于 等于 小于
    p : 优先级
    
    关于优先级定义：
    public let  priorityHighTop = (UILayoutPriority)(UILayoutPriorityDefaultHigh + 1); 
	public let  priorityHigh = UILayoutPriorityDefaultHigh;
	public let  priorityMedium = (UILayoutPriority)(500);
	public let  priorityLow = UILayoutPriorityDefaultLow;
	public let  priorityRequired = UILayoutPriorityRequired;
	public let  priorityFittingSizeLevel = UILayoutPriorityFittingSizeLevel;
	
	如果还需要 Baseline 等相关关系可自行封装，都是体力活
 