//
//  LyPrompt.swift
//  QooccShow
//
//  Created by LiuYu on 14/11/12.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

import UIKit

//MARK:- 会自动消失的提示框
private let waitingQueue: dispatch_queue_t = dispatch_queue_create("com.qoocc.qooccShow_Prompt", DISPATCH_QUEUE_SERIAL)
func lyShowPromptView(message: String, _ completion: (()->Void)? = nil) {
    let superView = UIWindow(frame: UIScreen.mainScreen().bounds) as UIWindow
    superView.userInteractionEnabled = false
    superView.hidden = false
    superView.windowLevel = UIWindowLevelAlert
        
    dispatch_async(waitingQueue, { () in
        let showDuration: NSTimeInterval = 1.0;      // 显示动画时长
        let hiddenDuration: NSTimeInterval = 0.5;    // 隐藏动画时长
        
        // 进入到主线程去显示并动画
        dispatch_async(dispatch_get_main_queue(), { () in
            // 黑色背景
            let bgView = UIView(frame: CGRectMake(0, 0, 10, 10))
            bgView.backgroundColor = UIColor(red:40/255.0, green:40/255.0, blue:40/255.0, alpha:0.8)
            bgView.layer.cornerRadius = 3
            superView.addSubview(bgView)
            
            // 显示文字
            let titleLabel = UILabel(frame:CGRectMake(50, superView.bounds.size.height/2, 220, 100))
            titleLabel.backgroundColor = UIColor.clearColor()
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.font = UIFont.systemFontOfSize(16.0)
            titleLabel.numberOfLines = 0
            bgView.addSubview(titleLabel)
            
            // 文字自适应
            titleLabel.text = message;
            var size = titleLabel.sizeThatFits(CGSize(width: superView.bounds.width - 80, height: CGFloat.max))
            titleLabel.bounds = CGRect(origin: CGPointZero, size: size)
            size.height += 40   // 增加边距 (上和下）
            size.width += 40    // 增加边距 (左和右）
            
            // 适配坐标
            bgView.bounds = CGRect(origin: CGPointZero, size: size)
            bgView.center = CGPoint(x: superView.bounds.width/2.0, y: superView.bounds.height/2.0);
            titleLabel.center = CGPoint(x: size.width/2.0, y: size.height/2.0);
            
            // 动画效果 -----------------------
            let animationView = bgView as UIView
            animationView.alpha = 0;
            UIView.animateWithDuration(showDuration, animations: { () -> Void in
                animationView.alpha = 1.0
                }) { (finished)  -> Void in
                    UIView.animateWithDuration(0.5, delay: hiddenDuration, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () in
                        animationView.alpha = 0;
                        }) { (finished) -> Void in
                            // 动画结束
                            animationView.removeFromSuperview()
                            superView
                            completion?();
                    }
            }
        });
        
        // 等待动画完成，额外增加1S避免太紧密
        sleep(UInt32(showDuration + hiddenDuration + 1));
    })
}

//MARK:- 加载提示框
private var activityWindow: UIWindow?
private weak var activityView: LyActivityView?
func lyShowActivityView(message: String?, inView: UIView? = nil, _ timeoutInterval: NSTimeInterval? = nil) {
    
    if inView == nil && activityWindow == nil {
        activityWindow = UIApplication.sharedApplication().keyWindow as UIWindow?
    }
    
    if inView == nil && activityWindow == nil {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds) as UIWindow
        window.userInteractionEnabled = true
        window.hidden = false
        window.windowLevel = UIWindowLevelAlert
        activityWindow = window
    }
    
    if inView != nil || activityWindow!.bounds.height > 300 {
        if activityView == nil {
            let foregroundControl = UIControl(frame: (inView ?? activityWindow!).bounds)
            foregroundControl.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            (inView ?? activityWindow!).addSubview(foregroundControl)
            
            let activityViewTemp = LyActivityView()
            if inView != nil {
                activityViewTemp.center = CGPointMake(foregroundControl.bounds.width/2.0, foregroundControl.bounds.height/2.0 - 64*COEFFICIENT_OF_HEIGHT_ZOOM)
            }
            else {
                activityViewTemp.center = CGPointMake(foregroundControl.bounds.width/2.0, foregroundControl.bounds.height/2.0)
            }
            foregroundControl.addSubview(activityViewTemp)
            activityView = activityViewTemp
            
            // 动画效果 -----------------------
            let animationView = activityView as UIView!
            animationView.alpha = 0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                animationView.alpha = 1
            })
        }
        
        activityView!.text = message
        
        // 超时自动隐藏加载框 （默认 三分钟）
        activityView!.tag = random()    // 重新标记，表示已经被改过了
        let tag = activityView!.tag
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(UInt64(timeoutInterval == nil ? 60*3 : timeoutInterval!) * NSEC_PER_SEC)), dispatch_get_main_queue(), { () in
            if activityView?.tag == tag {
                lyHiddenActivityView()
            }
        })
    }
}

func lyHiddenActivityView() {
    if activityView != nil {
        let animationView = activityView as UIView!
        
        UIView.animateWithDuration(0.25, animations: { () in
            animationView.alpha = 0
            }) { (finished) in
                animationView.superview?.removeFromSuperview()
                animationView.removeFromSuperview()
                activityWindow = nil
        }
    }
}



