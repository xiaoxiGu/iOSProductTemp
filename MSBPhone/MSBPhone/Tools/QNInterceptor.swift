//
//  QNInterceptor.swift
//
//
//  Created by LiuYu on 15/5/28.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import Foundation

private var g_qnInterceptor: QNInterceptor? = nil


//MARK: 遵循此协议的将会拦截
protocol QNInterceptorProtocol {}

//MARK: 自定义导航条
protocol QNInterceptorNavigationBarProtocol: QNInterceptorProtocol {}

//增加页面友盟统计
protocol QNInterceptorMobPageViewProtocol: QNInterceptorProtocol {}

/**
*  @author LiuYu, 15-05-26 14:05:28
*
*  //MARK:- 拦截器，拦截遵循了QNInterceptorProtocol 协议的类的实例
*/
class QNInterceptor : NSObject {
    
    //MARK: 开始拦截
    class func start() {
        if g_qnInterceptor == nil {
            g_qnInterceptor = QNInterceptor()
        }
    }
    
    // 停止拦截
    class func stop() {
        g_qnInterceptor = nil
    }
    
    
    override init() {
        super.init()
        //MARK: 拦截 UIViewController 的 viewDidLoad() 方法
        let viewDidLoad1: @convention(block) (aspectInfo: AspectInfo) -> Void = { (aspectInfo: AspectInfo) -> Void in
            if let viewController = aspectInfo.instance() as? UIViewController {
                if viewController is QNInterceptorNavigationBarProtocol{
                    // 设置基类样式
                    viewController.view.backgroundColor = defaultBackgroundColor
                    viewController.edgesForExtendedLayout = UIRectEdge.None
                    
                    //导航
                    viewController.xNavigationBar = UINavigationBar(frame: CGRectMake(0, 0, Screen_Width, 64.0))
                    viewController.view.addSubview(viewController.xNavigationBar!)
                    viewController.xNavigationBarItem = UINavigationItem()
                    viewController.configNavigationBarItem(viewController.title)
                    viewController.xNavigationBar?.items = [viewController.xNavigationBarItem!]
                    if let navigationVC = viewController.navigationController {
                        navigationVC.navigationBar.hidden = true
                    }
                }
                
                print("创建控制器:\(viewController.debugDescription)\n")
            }
        }
        try! UIViewController.aspect_hookSelector(Selector("viewDidLoad"), withOptions: AspectOptions.PositionAfter, usingBlock: unsafeBitCast(viewDidLoad1, AnyObject.self))
        
        //MARK: 友盟统计 页面访问
        let viewWillAppear1: @convention(block) (aspectInfo: AspectInfo) -> Void = {(aspectInfo: AspectInfo) -> Void in
            if let viewController = aspectInfo.instance() as? UIViewController{
                if viewController is QNInterceptorMobPageViewProtocol{
                    MobClick.beginLogPageView(NSStringFromClass(viewController.classForCoder))
                }
            }
            
        }
        try! UIViewController.aspect_hookSelector(Selector("viewWillAppear:"), withOptions: AspectOptions.PositionAfter, usingBlock: unsafeBitCast(viewWillAppear1, AnyObject.self))
        
        let viewWillDisAppear1: @convention(block) (aspectInfo: AspectInfo) -> Void = {(aspectInfo: AspectInfo) -> Void in
            if let viewController = aspectInfo.instance() as? UIViewController{
                if viewController is QNInterceptorMobPageViewProtocol{
                    MobClick.endLogPageView(NSStringFromClass(viewController.classForCoder))
                }
            }
            
        }
        try! UIViewController.aspect_hookSelector(Selector("viewWillDisappear:"), withOptions: AspectOptions.PositionAfter, usingBlock: unsafeBitCast(viewWillDisAppear1, AnyObject.self))
        
        
        //MARK: 拦截 UIViewController 的 deinit 方法
        let deInit1 : @convention(block) (aspectInfo: AspectInfo) -> Void = { (aspectInfo: AspectInfo) -> Void in
            if let viewController = aspectInfo.instance() as? UIViewController {
                print("控制器被释放:\(viewController.debugDescription)\n")
            }
        }
        try! UIViewController.aspect_hookSelector(Selector("dealloc"), withOptions: AspectOptions.PositionBefore, usingBlock: unsafeBitCast(deInit1, AnyObject.self))
        
        
    }
    
    
}