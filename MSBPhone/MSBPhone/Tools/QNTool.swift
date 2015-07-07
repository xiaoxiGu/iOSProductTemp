//
//  QNTool.swift
//  QooccHealth
//
//  Created by LiuYu on 15/5/28.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import UIKit

/**
*  //MARK:- 通用工具类
*/
class QNTool: NSObject {
}

/**
*  @author LiuYu, 15-06-24
*
*  //MARK:- 更新时做 数据迁移
*/
private let kKeyVersionOnLastOpen = ("VersionOnLastOpen" as NSString).encrypt(g_SecretKey)
extension QNTool {
    class func update() {
        let versionOnLastOpen = (getObjectFromUserDefaults(kKeyVersionOnLastOpen) as? NSString)?.decrypt(g_SecretKey)
        if versionOnLastOpen == nil || compareVersion(versionOnLastOpen!, APP_VERSION) != NSComparisonResult.OrderedSame { // 当没有设置最后一次打开的版本号，或者最后一次打开的版本号比当前版本号低的情况下要做更新操作
            
            // 当版本从低于或者等于2.0的时候，做下面的数据迁移
            if versionOnLastOpen == nil || compareVersion(versionOnLastOpen!, "2.0") != NSComparisonResult.OrderedDescending {
                do { // 用户账号数据迁移，从老数据中获取账号，然后重新登录，需要用户设置密码
                    let key = "GROUP"
//                    if let groupDictionary = getObjectFromUserDefaults(key) as? NSDictionary, let group = QN_Group(groupDictionary) {
//                        saveAccountAndPassword(group.groupId, nil)
//                        removeObjectAtUserDefaults(key)
//                    }
                } while (false)
                
                // 删除被废弃的 key
                removeObjectAtUserDefaults("IsFirstStartApp")
                removeObjectAtUserDefaults("NotReadSystemMessageCount")
                removeObjectAtUserDefaults("NotReadHomeMessageCount")
                removeObjectAtUserDefaults("DeviceToken")
                removeObjectAtUserDefaults("AllowShowPhone")
                removeObjectAtUserDefaults("NotReadMonthlyReportCount")
                removeObjectAtUserDefaults("NotReadSuggestCount")
                removeObjectAtUserDefaults("CurrentUserIndex")
            }
            
            // 所有版本升级都需要做的操作
//            do {
//                removeObjectAtUserDefaults(kKeyIsFirstStartApp) // 清空第一次登录操作
//            } while (false)
            
            // 所有操作完成后，更新最低版本号
            saveObjectToUserDefaults(kKeyVersionOnLastOpen, (APP_VERSION as NSString).encrypt(g_SecretKey))
        }
    }
}

/**
*  @author LiuYu, 15-05-28 15:05:50
*
*  //MARK:- 提示框相关
*/
extension QNTool {
    
    /**
    //MARK: 弹出会自动消失的提示框
    
    :param: message    提示内容
    :param: completion 提示框消失后的回调
    */
    class func showPromptView(message: String = "服务升级中，请耐心等待！", _ completion: (()->Void)? = nil) {
        lyShowPromptView(message, completion)
    }
    
    /**
    //MARK: 弹出进度提示框
    
    :param: message         提示内容
    :param: inView          容器，如果设置为nil，会放在keyWindow上
    :param: timeoutInterval 超时隐藏，如果设置为nil，超时时间是3min
    */
    class func showActivityView(message: String?, inView: UIView? = nil, _ timeoutInterval: NSTimeInterval? = nil) {
        lyShowActivityView(message, inView: inView, timeoutInterval)
    }
    
    /**
    //MARK: 隐藏进度提示框
    */
    class func hiddenActivityView() {
        lyHiddenActivityView()
    }
    
    /**
    //MARK: 显示错误提示
    
    优先显示服务器返回的错误信息，如果没有，则显示网络层返回的错误信息，如果在没有，则显示默认的错误提示
    
    :param: dictionary 服务器返回的Dic
    :param: error      网络层返回的error
    :param: errorMsg   服务器返回的错误信息
    */
    class func showErrorPromptView(dictionary: NSDictionary?, error: NSError?, errorMsg: String? = nil) {
        if errorMsg != nil {
            QNTool.showPromptView(message: errorMsg!); return
        }
        
        if let errorMsg = dictionary?["errorMsg"] as? String {
            QNTool.showPromptView(message: errorMsg); return
        }
        
        if error != nil && error!.domain.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            QNTool.showPromptView(message: "网络异常，请稍后重试！"); return
        }
        
        QNTool.showPromptView()
    }
    
    
}

/**
*  @author LiuYu, 15-06-11
*
*  //MARK:- 增加空提示的View
*/
private let kTagEmptyView = 96211
private let kTagMessageLabel = 96212
extension QNTool {
    class func showEmptyView(message: String? = nil, inView: UIView?) {
        if inView == nil { return }
        
        //
        var emptyView: UIView! = inView!.viewWithTag(kTagEmptyView)
        if emptyView == nil {
            emptyView = UIView(frame: inView!.bounds)
            emptyView.backgroundColor = UIColor.clearColor()
            emptyView.tag = kTagEmptyView
            inView!.addSubview(emptyView)
        }
        
        // 设置提示
        if message != nil {
            let widthMax = emptyView.bounds.width - 40
            var messageLabel: UILabel! = emptyView.viewWithTag(kTagMessageLabel) as? UILabel
            if messageLabel == nil {
                messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: widthMax, height: 20))
                messageLabel.tag = kTagMessageLabel
                messageLabel.textColor = tableViewCellDefaultDetailTextColor
                messageLabel.backgroundColor = UIColor.clearColor()
                messageLabel.textAlignment = .Center
                messageLabel.autoresizingMask = .FlexibleWidth
                messageLabel.numberOfLines = 0
                emptyView.addSubview(messageLabel)
            }
            
            messageLabel.text = message
            messageLabel.bounds = CGRect(origin: CGPointZero, size: messageLabel.sizeThatFits(CGSize(width: widthMax, height: CGFloat.max)))
            messageLabel.center = CGPoint(x: emptyView.bounds.width/2.0, y: emptyView.bounds.height/2.0)
        }
        else {
            emptyView.viewWithTag(kTagMessageLabel)?.removeFromSuperview()
        }
    }
    
    class func hiddenEmptyView(forView: UIView?) {
        forView?.viewWithTag(kTagEmptyView)?.removeFromSuperview()
    }
    
    
}

/**
*  @author LiuYu, 15-05-28 16:05:14
*
*  //MARK:- 页面切换相关
*/
extension QNTool {

    /**
    //MARK: 转场动画过渡
    
    :param: vc 将要打开的ViewController
    */
    class func enterRootViewController(vc: UIViewController, animated: Bool = true) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let animationView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
            appDelegate.window?.addSubview(animationView)
            let changeRootViewController = { () -> Void in
                appDelegate.window?.rootViewController = vc
                if animated {
                    appDelegate.window?.bringSubviewToFront(animationView)
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        animationView.transform = CGAffineTransformMakeScale(3.0, 3.0)
                        animationView.alpha = 0
                        }, completion: { (finished) -> Void in
                            animationView.removeFromSuperview()
                    })
                }
                else {
                    animationView.removeFromSuperview()
                }
            }
            
            if let viewController = appDelegate.window?.rootViewController where viewController.presentedViewController != nil {
                viewController.dismissViewControllerAnimated(false) {
                    changeRootViewController()
                }
            }
            else {
                changeRootViewController()
            }
        }
    }
    
    /**
    //MARK: 进入登陆的控制器
    */
    class func enterLoginViewController() {
        let vc = (UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? UIViewController)!
        QNTool.enterRootViewController(vc)
    }
    
    
}

//MARK:- 获得某个范围内的屏幕图像
extension QNTool {
    class func imageFromView(view: UIView, frame: CGRect) -> UIImageView {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        UIRectClip(frame)
        view.layer.renderInContext(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        return  imageView
    }
}

//MARK:- 弹出APP评论框
//NOTE: 如果用户去评论了将不会弹出评论页面
private let kKeyTheRemainingNumberShowComment = ("TheRemainingNumberShowComment" as NSString).encrypt(g_SecretKey) // 显示评论剩余次数
private let theRemainingNumberShowCommentDefault = 10    // 设置成0，表示每次都会弹出评论提示，直到用户去评论，或者用户残忍拒绝。  设置成2，表示每相隔启动2次会弹出提示
private var theRemainingNumberShowComment: Int? {
get {
    return getObjectFromUserDefaults(kKeyTheRemainingNumberShowComment) as? Int ?? theRemainingNumberShowCommentDefault // 显示评论剩余次数，当该值 = -1的时候，表示已经评论过了，就不会在给出评论了,
}
set {
    if newValue == nil {
        removeObjectAtUserDefaults(kKeyTheRemainingNumberShowComment)
    }
    else {
        saveObjectToUserDefaults(kKeyTheRemainingNumberShowComment, newValue!)
    }
}
}
extension QNTool {
    class func showCommentAppAlertView() {
        let commentAlertView = UIAlertView(title: "程序员牺牲陪女神的时间，加班加点做出的产品，你狠心不给个评分吗？", message: nil, delegate: nil, cancelButtonTitle: "狠心拒绝")
        commentAlertView.addButtonWithTitle("去评分")
        commentAlertView.rac_buttonClickedSignal().subscribeNext({(indexNumber) -> Void in
            if let index = indexNumber as? Int {
                switch index {
                case 0: // 残忍拒绝
                    theRemainingNumberShowComment = nil
                case 1: // 去评论
                    theRemainingNumberShowComment = -1
                    UIApplication.sharedApplication().openURL(NSURL(string: APP_URL_IN_ITUNES)!)
                default: break
                }
            }
        })
        commentAlertView.show()
    }
    
    // 自动显示弹出App评论框
    class func autoShowCommentAppAlertView() {
        if let count = theRemainingNumberShowComment {
            switch count {
            case 0:
                self.showCommentAppAlertView()
            case Int.min..<0:
                return // 小于0 表示用户已经去评论过了，所有不在弹出App评论框
            default:
                theRemainingNumberShowComment = count - 1
            }
        }
    }
    
}

//MARK:- 判断当前网络状况
extension QNTool {
    //网络连接状态
    class func netWorkStatus() -> NetworkStatus {
        let netWorkStatic = Reachability.reachabilityForInternetConnection()
        netWorkStatic.startNotifier()
        return netWorkStatic.currentReachabilityStatus()
    }
}

//MARK:- 自动提示编辑昵称
extension QNTool {
    class func autoShowEditNickNameView() {
        if g_NickName == nil {
            let alert = UIAlertView(title: nil, message: "为了方便您的家人识别您，请输入昵称", delegate: nil, cancelButtonTitle: "取消")
            alert.addButtonWithTitle("确认")
            alert.alertViewStyle = .PlainTextInput
            alert.rac_buttonClickedSignal().subscribeNext { (index) -> Void in
                if let indexInt = index as? Int, let text = alert.textFieldAtIndex(0)?.text where indexInt == 1 {

                }
            }
            alert.show()
            
            alert.textFieldAtIndex(0)?.placeholder = "昵称"
            alert.textFieldAtIndex(0)?.returnKeyType = .Done
        }
    }
}


