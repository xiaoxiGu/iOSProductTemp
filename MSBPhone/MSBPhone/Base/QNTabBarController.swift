//
//  QNTabBarController.swift
//  QooccHealth
//
//  Created by 肖小丰 on 15/4/14.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import UIKit

private enum IndexItem {
    case Home
    case Server
    case IM
    case UserCenter
    
    init(index:NSInteger){
        switch index{
        case 0:
            self = Home
        case 1:
            self = Server
        case 2:
            self = IM
        case 3:
            self = UserCenter
        default:
            self = Home
        }
    }
    
    var image : UIImage?{
        switch self{
        case .Home:
            return UIImage(named: "first")
        case .Server:
            return UIImage(named: "first")
        case .IM:
            return UIImage(named: "first")
        case .UserCenter:
            return UIImage(named: "first")
        }
    }
    
    var selectedImage : UIImage?{
        switch self{
        case .Home:
            return UIImage(named: "second")
        case .Server:
            return UIImage(named: "second")
        case .IM:
            return UIImage(named: "second")
        case .UserCenter:
            return UIImage(named: "second")
        }
    }
    
    var title : String{
        switch self{
        case .Home:
            return "首页"
        case .Server:
            return "客服"
        case .IM:
            return "消息"
        case .UserCenter:
            return "我"
        }
    }
    
    var needRedDot : Bool{
        switch self{
        case .Home:
            return false
        case .Server:
            return false
        case .IM:
            return false
        case .UserCenter:
            return true
        }
    }
    

}

class QNTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 修改底部工具条的字体和颜色
        self.tabBar.translucent = false
        self.tabBar.barTintColor = UIColor.whiteColor()
        self.tabBar.tintColor = UINavigationBar.appearance().tintColor
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(objectsAndKeys: defaultGrayColor, NSForegroundColorAttributeName, UIFont.systemFontOfSize(12), NSFontAttributeName) as [NSObject : AnyObject], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(objectsAndKeys: appThemeColor, NSForegroundColorAttributeName, UIFont.systemFontOfSize(12), NSFontAttributeName) as [NSObject : AnyObject], forState: .Selected)

        // 图标配置
        if let itemsArray = self.tabBar.items {
            for var i=0; i<itemsArray.count; i++ {
                if let item = itemsArray[i] as? UITabBarItem {
                    let indexItem = IndexItem(index: i)
                    if !indexItem.needRedDot {
                        item.image = indexItem.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                        item.selectedImage = indexItem.selectedImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                    }else{
                        item.image = self.imageAddDotView(indexItem.image!).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                        item.selectedImage = self.imageAddDotView(indexItem.selectedImage!).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                    }
                    item.title = indexItem.title
                }
            }
        }
        

    }
    
    private func imageAddDotView(image: UIImage) -> UIImage {
        let imageView = UIImageView(image: image)
        
        let dotView = UIView(frame: CGRect(x: imageView.bounds.width - 8, y:  8, width: 8, height: 8))
        dotView.layer.masksToBounds = true
        dotView.layer.cornerRadius = dotView.bounds.width/2.0
        dotView.backgroundColor = UIColor(red: 251/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
        imageView.addSubview(dotView)
        
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        imageView.layer.renderInContext(context)
        let imageResult = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageResult
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
