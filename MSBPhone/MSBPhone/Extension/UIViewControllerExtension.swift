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
        var classFullName = NSStringFromClass(self.classForCoder())
        var className = classFullName!.componentsSeparatedByString(".").last as String! 
        var mainStoryboard = UIStoryboard(name: name, bundle:nil)
        return mainStoryboard.instantiateViewControllerWithIdentifier(className)
    }
    
    
}

//MARK:- 为 UIViewController ... 扩展一个 返回功能
extension UIViewController {
    func back() {
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        }
        else {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in })
        }
    }
}

//MARK:- 为 UIViewController ... 提供一个标准的导航栏返回按钮配置
extension UIViewController {
    public func configBackButton() {
        var fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target:nil ,action:nil)
        fixedSpace.width = -15;
        
        let button = UIButton(frame: CGRectMake(0, 0, 50, 44))
        button.setImage(UIImage(named: "navigation_back_icon")!.imageWithColor(appThemeColor), forState: .Normal)
        button.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationItem.leftBarButtonItems = [fixedSpace, UIBarButtonItem(customView: button)]
    }
}