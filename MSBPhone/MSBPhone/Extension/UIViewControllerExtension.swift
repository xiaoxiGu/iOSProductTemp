//
//  UIViewControllerExtension.swift
//  QooccShow
//
//  Created by LiuYu on 14/11/3.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

import UIKit

//MARK:- 为 UIViewController ... 扩展一个公有的从storyboard构建的方法
extension UIViewController {
    //MARK: 从 Main.storyboard 初始化一个当前类
    // 从 Main.storyboard 中创建一个使用了当前类作为 StoryboardID 的类
    public class func CreateFromMainStoryboard() ->  AnyObject! {
        return self.CreateFromStoryboard("Main")
    }
    
    //MARK: 从 storyboardName.storyboard 初始化一个当前类
    // 从 storyboardName.storyboard 中创建一个使用了当前类作为 StoryboardID 的类
    public class func CreateFromStoryboard(name: String) -> AnyObject! {
        let classFullName = NSStringFromClass(self.classForCoder())
        let className = classFullName.componentsSeparatedByString(".").last as String!
        let mainStoryboard = UIStoryboard(name: name, bundle:nil)
        return mainStoryboard.instantiateViewControllerWithIdentifier(className)
    }
    
    
}

//MARK:- 为 UIViewController ... 扩展一个 返回功能
extension UIViewController {
    @IBAction func back() {
        if let navigationController = self.navigationController where navigationController.viewControllers.first != self {
            navigationController.popViewControllerAnimated(true)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in })
        }
    }
}

private var navigationKey: Void?
private var navigationItemKey: Void?
public extension UIViewController{
    var xNavigationBar: UINavigationBar?{
        get{
           return objc_getAssociatedObject(self, &navigationKey) as? UINavigationBar
        }
        set{
            self.willChangeValueForKey("xNavigationBar")
            objc_setAssociatedObject(self, &navigationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValueForKey("xNavigationBar")
        }
    }
    
    var xNavigationBarItem: UINavigationItem?{
        get{
            return objc_getAssociatedObject(self, &navigationItemKey) as? UINavigationItem
        }
        set{
            self.willChangeValueForKey("xNavigationBarItem")
            objc_setAssociatedObject(self, &navigationItemKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            self.didChangeValueForKey("xNavigationBarItem")
        }
    }
    
    func configNavigationBarItem(title:String?) -> UINavigationItem?{
        
        if self.xNavigationBarItem != nil{
            let titleLable = UILabel()
            titleLable.textAlignment = NSTextAlignment.Center
            titleLable.font = UIFont.systemFontOfSize(18.0)
            titleLable.frame = CGRectMake(-(Screen_Width - 40)/2, -15, Screen_Width - 40, 30)
            titleLable.text = title
            let view = UIView()
            view.addSubview(titleLable)
            
            self.xNavigationBarItem?.titleView = view
            
            let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target:nil ,action:nil)
            fixedSpace.width = -15;
            
            if let navigationController = self.navigationController where navigationController.viewControllers.first != self {
                let button = UIButton(frame: CGRectMake(0, 0, 50, 44))
                button.setImage(UIImage(named: "second")!.imageWithColor(appThemeColor), forState: .Normal)
                button.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
                
                self.xNavigationBarItem!.leftBarButtonItems = [fixedSpace, UIBarButtonItem(customView: button)]
            }
        }
        return self.xNavigationBarItem
    }
}


