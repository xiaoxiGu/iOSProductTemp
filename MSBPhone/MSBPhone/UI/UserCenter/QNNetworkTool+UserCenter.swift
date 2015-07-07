//
//  QNNetworkTool+UserCenter.swift
//  MSBPhone
//
//  Created by 顾金友 on 15/7/6.
//  Copyright (c) 2015年 msb. All rights reserved.
//

import Foundation

extension QNNetworkTool{
//    /**
//    登录接口
//
//    :param: groupId       登录Id
//    :param: groupPassword 登录密码
//    :param: completion    请求完成后的回掉
//    */
//    private class func login(GroupId groupId: String, GroupPassword groupPassword: String, completion: (QN_Group?, NSError?, String?) -> Void) {
//        requestPOST(kServerAddress + "/api/login", parameters: paramsToJsonDataParams(["groupId" : groupId, "groupPassword" : groupPassword])) { (_, _, _, dictionary, error) -> Void in
//            if dictionary != nil {
//                if let group = QN_Group(dictionary!) {
//                    // 本地头像和昵称与服务器同步
//                    if let client = dictionary?["client"] as? NSDictionary {
//                        if let headImageUrl = client["face"] as? String where count(headImageUrl) > 1 {
//                            g_HeadImageUrl = headImageUrl
//                        }
//                        else {
//                            g_HeadImageUrl = nil
//                        }
//
//                        if let nickName = client["nick"] as? String where count(nickName) > 0 {
//                            g_NickName = nickName
//                        }
//                        else {
//                            g_NickName = nil
//                        }
//                    }
//
//                    completion(group, nil, nil)
//                }
//                else {
//                    completion(nil, self.formatError(), dictionary!["errorMsg"] as? String)
//                }
//            }
//            else {
//                completion(nil, error, nil)
//            }
//        }
//    }
//
//    /**
//    登录，并且拥有页面跳转功能
//
//    :param: groupId       登录Id
//    :param: groupPassword 登录密码
//    :param: isTest        是否是测试账号
//    */
//    class func login(GroupId groupId: String, GroupPassword groupPassword: String, isTest: Bool = false) {
//        QNTool.showActivityView("正在登录...")
//        QNNetworkTool.login(GroupId: groupId, GroupPassword: groupPassword) { (group, error, errorMsg) -> Void in
//            QNTool.hiddenActivityView()
//            if group != nil {
//                g_currentGroup = group
//                g_currentGroup!.isTest = isTest
//                if g_currentUserIndex != nil && g_currentUserIndex < g_currentGroup!.count {
//                    g_currentGroup!.currentUserIndex = g_currentUserIndex!
//                }
//                if !isTest { // 请求成功，保存账号密码到本地(  测试账号不保存）
//                    saveAccountAndPassword(groupId, groupPassword)
//                }
//                QNNetworkTool.uploadRegistrationIdAndToken()
//                QNNetworkTool.updateApplyNotReadCount()
//                QNNetworkTool.updateMyMessageNotReadCount()
//
//                UIApplication.sharedApplication().statusBarHidden = false
//                let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? UIViewController)!
//                QNTool.enterRootViewController(vc)
//
//                QNTool.autoShowEditNickNameView()
//            }
//            else {
//                 QNTool.showErrorPromptView(nil, error: error, errorMsg: errorMsg)
//            }
//        }
//    }
//
//    /**
//    更新用户信息
//    */
//    class func updateCurrentGroupInfo(completion: ((Bool) -> Void)?) {
//        if !g_currentGroup!.isTest, let account = g_Account, let password = g_Password {
//            QNNetworkTool.login(GroupId: account, GroupPassword: password) { (group, error, errorMsg) -> Void in
//                if group != nil {
//                    g_currentGroup = group
//                    g_currentGroup!.isTest = false
//                    QNNetworkTool.uploadRegistrationIdAndToken()
//                    completion?(true)
//                }
//                else {
//                    completion?(false)
//                    if errorMsg != nil && errorMsg?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 1 {
//                        completion?(false)
//                        let commentAlertView = UIAlertView(title: "密码已修改，请重新登录！", message: nil, delegate: nil, cancelButtonTitle:nil)
//                        commentAlertView.addButtonWithTitle("好")
//                        commentAlertView.rac_buttonClickedSignal().subscribeNext({(indexNumber) -> Void in
//                            QNNetworkTool.logout()
//                        })
//                        commentAlertView.show()
//
//                    }
//                }
//            }
//        }
//    }
//    
//    /**
//    退出登录，并且拥有页面跳转功能
//    */
//    class func logout() {
//        g_currentUserIndex = nil
//        g_currentGroup = nil
//        cleanPassword()
//        QNPhoneTool.hidden = true
//        QNTool.enterLoginViewController()
//    }
//    
//
}