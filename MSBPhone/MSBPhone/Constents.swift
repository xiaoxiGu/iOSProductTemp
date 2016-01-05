//
//  Constents.swift
//  TestSwify
//
//  Created by LiuYu on 14/10/31.
//  Copyright (c) 2014年 Liuyu. All rights reserved.
//

import UIKit

// MARK: - Path
// MARK:  Caches 目录
let PATH_CACHES = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray).firstObject as! NSString
// MARK:  Documents 目录
let PATH_DOCUMENTS = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray).firstObject as! NSString

// MARK: - Application information
// MARK:  App ID (必须与 iTunes Connect 上设置的一致)
let APP_ID  = "994849514"
// MARK:  App SKU码 (必须与 iTunes Connect 上设置的一致)
let APP_SKU = "com.easyder.masterorg"
// MARK:  App Bundle Id
let APP_BUNDLE_ID = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleIdentifier") as! String
// MARK:  App 名称
let APP_NAME = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String
// MARK:  App 版本号
let APP_VERSION = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
// MARK:  App 编译版本号
let APP_VERSION_BUILD = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
// MARK:  APP 下载地址前缀
let APP_URL_IN_ITUNES_PREFIX = "https://itunes.apple.com/cn/app/id%@?ls=1&mt=8"
// MARK:  APP 下载地址（在iTunes中）
let APP_URL_IN_ITUNES: String = NSString(format: APP_URL_IN_ITUNES_PREFIX, APP_ID) as String

// MARK: - 屏幕高度 & 屏幕宽度
let Screen_Height = UIScreen.mainScreen().bounds.size.height
let Screen_Width = UIScreen.mainScreen().bounds.size.width

// MARK: - System
// MARK:  系统名称
let SYSTEM_NAME: String = UIDevice.currentDevice().systemName
// MARK:  系统版本号 （字符串）
let SYSTEM_VERSION: String = UIDevice.currentDevice().systemVersion
// MARK:  系统版本号 （浮点数）
let SYSTEM_VERSION_FLOAT: Float = (SYSTEM_VERSION as NSString).floatValue

// MARK: - NSUserDefaults.standardUserDefaults() 相关
// MARK: 从 NSUserDefaults.standardUserDefaults() 中获取数据
func getObjectFromUserDefaults(key: String) -> AnyObject? {
    return NSUserDefaults.standardUserDefaults().objectForKey(key)
}
// MARK: 保存 obj 到 NSUserDefaults.standardUserDefaults() 中
func saveObjectToUserDefaults(key: String, value: AnyObject) {
    NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
    NSUserDefaults.standardUserDefaults().synchronize()
}
// MARK: 从 NSUserDefaults.standardUserDefaults() 中移除数据
func removeObjectAtUserDefaults(key: String) {
    NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
    NSUserDefaults.standardUserDefaults().synchronize()
}

// MARK: - 获取最顶层的ViewController
func topViewController() -> UIViewController? {
    var resultViewController: UIViewController? = nil
    // 多window的情况下， 需要对window进行有效选择选择
    if let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
        resultViewController = __topViewController(rootViewController)
        while resultViewController?.presentedViewController != nil {
            resultViewController = resultViewController?.presentedViewController
        }
    }
    return resultViewController
}

private func __topViewController(object: AnyObject!) -> UIViewController? {
    if let navigationController = object as? UINavigationController {
        return __topViewController(navigationController.viewControllers.last)
    }
    else if let tabBarController = object as? UITabBarController {
        if tabBarController.selectedIndex < tabBarController.viewControllers?.count {
            return __topViewController(tabBarController.viewControllers![tabBarController.selectedIndex])
        }
    }
    else if let vc = object as? UIViewController {
        return vc
    }
    
    return nil
}

// MARK: - 版本比较(无法进行比较会返回nil)
func compareVersion(version1: String, version2: String) -> NSComparisonResult? {
    let version1Array = version1.componentsSeparatedByString(".")
    let version2Array = version2.componentsSeparatedByString(".")
    
    let iCount = min(version1Array.count, version2Array.count)
    if iCount == 0 {
        return nil  // 无法进行比较 version的格式错误
    }
    
    for index in 0..<iCount {
        let iVersion1Sub = Int((version1Array[index]))
        let iVersion2Sub = Int((version2Array[index]))
        if iVersion1Sub != nil && iVersion2Sub != nil {
            if iVersion1Sub == iVersion2Sub {
                continue // 相同，则去判断下一个位置
            }
            else if iVersion1Sub > iVersion2Sub {
                return NSComparisonResult.OrderedDescending
            }
            else {
                return NSComparisonResult.OrderedAscending
            }
        }
        else { // 无法进行比较 version的格式错误
            return nil
        }
    }
    
    if version1Array.count == version2Array.count {
        return NSComparisonResult.OrderedSame
    }
    else if version1Array.count > version2Array.count {
        return NSComparisonResult.OrderedDescending
    }
    else {
        return NSComparisonResult.OrderedAscending
    }
}