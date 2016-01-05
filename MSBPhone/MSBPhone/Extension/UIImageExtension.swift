//
//  UIImageExtension.swift
//  QooccShow
//
//  Created by LiuYu on 14/12/26.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

import UIKit.UIImage

//MARK:- 创建一个颜色图片
extension UIImage {
    /**
    创建一个颜色图片
    
    - parameter color: 颜色
    - parameter size:  如果不设置，则为  ｛2， 2｝
    - returns: 返回图片，图片的scale为当前屏幕的scale
    */
    class func colorImage(color: UIColor) -> UIImage {
        return self.colorImage(color, size: CGSize(width: 2, height: 2))
    }
    class func colorImage(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFillUsingBlendMode(CGRectMake(0, 0, size.width, size.height), CGBlendMode.XOR)
        let cgImage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext())
        UIGraphicsEndImageContext()
        return UIImage(CGImage: cgImage!).stretchableImageWithLeftCapWidth(1, topCapHeight: 1)
    }
}

//MARK:- 改变图片的颜色
extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        let rect = CGRect(origin: CGPointZero, size: self.size)
        CGContextClipToMask(context, rect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, rect);
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}