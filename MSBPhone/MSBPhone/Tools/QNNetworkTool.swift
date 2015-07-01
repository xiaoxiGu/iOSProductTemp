//
//  QNNetworkTool.swift
//  QooccHealth
//
//  Created by LiuYu on 15/4/8.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import UIKit

//MARK:- 服务器地址
private let kServerAddress = { () -> String in
    "http://xite.qoocc.com/dc"          // 正式环境
//    "http://v2.xite.qoocc.com"          // v2测试环境
//    "http://192.168.20.133:7080/dc"     // 测试环境
//    "http://test.xite.qoocc.com/dc"     // 测试环境 Added by 肖小丰 2015-6-5
}()


/**
*  //MARK:- 网络处理中心
*/
class QNNetworkTool: NSObject {
}

/**
*  //MARK:- 网络基础处理
*/
private extension QNNetworkTool {
    /**
    //MARK: 生产共有的 URLRequest，如果是到巨细的服务器请求数据，必须使用此方法创建URLRequest
    
    :param: url    请求的地址
    :param: method 请求的方式， Get Post Put ...
    */
    private class func productRequest(url: NSURL!, method: NSString!) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.addValue("auth" ?? "", forHTTPHeaderField: "AUTH") // 用户身份串,在调用/api/login 成功后会返回这个串;未登录时为空
        request.addValue("1", forHTTPHeaderField: "AID")                // app_id, iphone=1, android=2
        request.addValue(APP_VERSION, forHTTPHeaderField: "VER")        // 客户端版本号
        request.addValue("cid", forHTTPHeaderField: "CID")             // 客户端设备号
        request.HTTPMethod = method as String
        return request
    }
    
    //MARK: 后台返回的数据错误，格式不正确 的 NSError
    private class func formatError() -> NSError {
        return NSError(domain: "后台返回的数据错误，格式不正确", code: 10087, userInfo: nil)
    }
    
    /**
    //MARK: Request 请求通用简化版
    
    :param: url               请求的服务器地址
    :param: method            请求的方式 Get/Post/Put/...
    :param: parameters        请求的参数
    :param: completionHandler 请求完成后的回掉， 如果 dictionary 为nil，那么 error 就不可能为空
    */
    private class func requestForSelf(url: NSURL?, method: String, parameters: [String : AnyObject]?, completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, dictionary: NSDictionary?, error: NSError?) -> Void) {
        request(ParameterEncoding.URL.encode(self.productRequest(url, method: method), parameters: parameters).0).response {
            if $3 != nil {  // 直接出错了
                completionHandler(request: $0, response: $1, data: $2, dictionary: nil, error: $3); return
            }
            var errorJson: NSErrorPointer = nil
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData($2 as! NSData, options: NSJSONReadingOptions.MutableContainers, error: errorJson)
            var dictionary = jsonObject as? NSDictionary
            
            if errorJson != nil {   // Json解析过程出错
                completionHandler(request: $0, response: $1, data: $2, dictionary: nil, error: errorJson.memory); return
            }
            
            if dictionary == nil {  // Json解析结果出错
                completionHandler(request: $0, response: $1, data: $2, dictionary: nil, error: NSError(domain: "JSON解析错误", code: 10086, userInfo: nil)); return
            }
            
            // 这里有可能对数据进行了jsonData的包装，有可能没有进行jsonData的包装
            if let jsonData = dictionary!["jsonData"] as? NSDictionary {
                dictionary = jsonData
            }
            
            let errorCode = (dictionary!["errorCode"] as? String)?.toInt()
            if errorCode == 1000 || errorCode == 0 {
                completionHandler(request: $0, response: $1, data: $2, dictionary: dictionary, error: nil)
            }
            else {
                completionHandler(request: $0, response: $1, data: $2, dictionary: dictionary, error: NSError(domain: "服务器返回错误", code:errorCode ?? 10088, userInfo: nil))
            }
        }
    }
    
    /**
    //MARK: Get请求通用简化版
    
    :param: urlString         请求的服务器地址
    :param: parameters        请求的参数
    :param: completionHandler 请求完成后的回掉
    */
    private class func requestGET(urlString: String, parameters: [String : AnyObject]?, completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?,  dictionary: NSDictionary?, error: NSError?) -> Void) {
        let url: NSURL! = NSURL(string: urlString)
        assert((url != nil), "输入的url有问题")
        requestForSelf(url, method: "Get", parameters: parameters, completionHandler: completionHandler)  
    }
    
    /**
    //MARK: Post请求通用简化版
    
    :param: urlString         请求的服务器地址
    :param: parameters        请求的参数
    :param: completionHandler 请求完成后的回掉
    */
    private class func requestPOST(urlString: String, parameters: [String : AnyObject]?, completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?,  dictionary: NSDictionary?, error: NSError?) -> Void) {
        let url: NSURL! = NSURL(string: urlString)
        assert((url != nil), "输入的url有问题")
        requestForSelf(url, method: "POST", parameters: parameters, completionHandler: completionHandler)
    }
    
    /**
    //MARK: 将输入参数转换成字符传
    */
    private class func paramsToJsonDataParams(params: [String : AnyObject]) -> [String : AnyObject] {
        let jsonData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: nil)
        let jsonDataString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
        return ["jsonData" : jsonDataString]
    }
    
    
}

//MARK:- 网络基础处理(上传)
extension QNNetworkTool {
    /**
    //MARK: 生产一个用于上传的Request
    
    :param: url      上传的接口的地址
    :param: method   上传的方式， Get Post Put ...
    :param: data     需要被上传的数据
    :param: fileName 上传的文件名
    */
    //构建上传request
    private class func productUploadRequest(url: NSURL!, method: NSString, data: NSData, fileName: NSString) -> NSURLRequest {
        var request = self.productRequest(url, method: method)
        // 定制一post方式上传数据，数据格式必须和下面方式相同
        let boundary = "abcdefg"
        request.setValue(String(format: "multipart/form-data;boundary=%@", boundary), forHTTPHeaderField: "Content-Type")
        // 注意 ："face"这个字段需要看文档服务端的要求，他们要取该字段进行图片命名
        var str = NSMutableString(format: "--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",boundary, "face", fileName, "application/octet-stream")
        // 配置内容
        var bodyData = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) as! NSMutableData
        bodyData.appendData(data)
        bodyData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        bodyData.appendData(NSString(format: "--%@--\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        request.HTTPBody = bodyData
        return request
    }
}

////MARK:- 登录 & 登出
//extension QNNetworkTool {
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
//}







