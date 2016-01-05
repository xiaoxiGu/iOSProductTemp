//
//  AppDelegate.swift
//  MSBPhone
//
//  Created by 顾金友 on 15/6/30.
//  Copyright (c) 2015年 msb. All rights reserved.
//

import UIKit
let kKeyIsFirstStartApp = ("IsFirstStartApp" as NSString).encrypt(g_SecretKey) // 第一次启动判断的Key

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //开启样式控制
//        QNInterceptor.start()
        //开启支付功能
//        PayTool.sharedPayTool()
        //集成环信SDK
//        EaseMob.sharedInstance().registerSDKWithAppKey("mingshibao365#mingshibao", apnsCertName: "")
//        EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//        EaseMob.sharedInstance().chatManager.asyncLoginWithUsername("10086", password: "123456", completion: { (array, error) -> Void in
//            print("111")
//        }, onQueue: nil)
        
        // 启动过渡页
//        let allowShowStartPages = !NSUserDefaults.standardUserDefaults().boolForKey(kKeyIsFirstStartApp)
//        if allowShowStartPages {
//            UIApplication.sharedApplication().statusBarHidden = true
//            let startPagesWindow = StartPagesWindow()
//            startPagesWindow.finished = { () -> Void in
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kKeyIsFirstStartApp)
//            }
//        }
        
//
//        // 自动显示app评论框
//        if !allowShowStartPages {
            QNTool.autoShowCommentAppAlertView()
//        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        EaseMob.sharedInstance().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        EaseMob.sharedInstance().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        EaseMob.sharedInstance().applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        EaseMob.sharedInstance().applicationWillTerminate(application)
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool{
        return PayTool.HandleApplicationOpenURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
    func onResp(resp:BaseResp){
        if (resp.isKindOfClass(PayResp.self)){
            let response = resp
            let title = "支付结果"
            let msg = NSString(format: "errcode:%d",response.errCode)
            //            let alert = UIAlertView(title: title, message: msg, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles:nil, nil)
            //            alert.show()
            if response.errCode == WXSuccess.rawValue{
                print("支付成功", terminator: "")
            }else{
                print("支付失败", terminator: "")
            }
        }
    }
    
}

