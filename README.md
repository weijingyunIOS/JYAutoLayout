# JYAutoLayout
使用Swift 对AutoLayout的轻量级封装简单好用，功能强大完善 
![enter image description here](http://img.coloranges.com/1605/4973412352730.png)

如图所示，所有橙色 和 白色的View 均相对于灰色的大View 而每个view的布局只需要短短的一行代码
    
       htrBtn.left(centerBtn,c:8).alignTop(centerBtn).size(btnSize).end()

下面将会讲封装的思路以及使用介绍：

1.NSLayoutConstraint

       public convenience init(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toItem view2: AnyObject?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat)
       这是一条约束的创建，它的约束关系是 view1.attr1 < = > view2.attr2 * multiplier + c
       	所以我们可以看到决定一个View1的某条约束所需的参数有：
    var View2    : UIView?                    相对于哪个view 即view2
    var Attribute1 : NSLayoutAttribute?	    view1  的NSLayoutAttribute
    var Attribute2 : NSLayoutAttribute?		view2  的NSLayoutAttribute
    var Multiplier : CGFloat?					比例系数
    var Equal = NSLayoutRelation.Equal        大于 等于 小于
    var offset : CGFloat                      偏移 
    var priority : UILayoutPriority           当然还有当前约束的优先级
  
  
	
2.NSLayoutAttribute 包含有		

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
    
3.简化封装
	
	根据实际情况 view1 的left 
    
    
    
    
    
    
	
 