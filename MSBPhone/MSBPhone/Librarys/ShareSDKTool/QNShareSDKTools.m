//
//  QNShareSDKTools.m
//  QooccShow
//
//  Created by xiaoxiaofeng on 14/11/7.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

#import "QNShareSDKTools.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#define kLogShare(...) ;//NSLog(__VA_ARGS__)

// URL Schemes 应填写：kWXAppID, tencent+kQQAppID, wb+kSinaAppKey, QQ+HEX(APP_ID)/*16进制表示的AppleID，不足的在前面补上0*/
// wx293e65ba9600207c,wb1832590950,QQ41C7CF5C,tencent1103613788

// ShareSDK（  AppKey）
#define kShareSDKAppKey     @"5f9ba6f3d174"
// 微信
#define kWXAppID            @"wx85d5c26606f09756"
#define kWXAppSecret        @"7b85d109aa2797b13a23e916744c1571"

// QQ/空间
#define kQQAppID            @" "
#define kQQSpaceSecret      @" "

// 新浪
#define kSinaAppKey         @"568898243"
#define kSinaAppSecret      @"38a4f8204cc784f81f9f0daaf31e02e3"
#define kSinaRedirectUrl    @"http://www.msb365.com"


@implementation QNShareSDKTools

/*!
 *  取消所有本应用的授权
 */
+ (void)cancelAllAuth {
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
}

/*!
 *  查询某授权是否有了
 */
+ (BOOL)hasAuthorizedWithType:(ShareType)type {
    return [ShareSDK hasAuthorizedWithType:type];
}

/*!
 *  查询是否安装了某App
 */
+ (BOOL)isInstalledWithType:(ShareType)type {
    switch (type) {
        case ShareTypeQQ:
        case ShareTypeQQSpace:
            return [QQApiInterface isQQInstalled];
        case ShareTypeWeixiFav:
        case ShareTypeWeixiSession:
        case ShareTypeWeixiTimeline:
            return [WXApi isWXAppInstalled];
        default:
            NSLog(@"判断分享是否安装未做设置 %d", type);
            break;
    }
    return NO;
//    typedef enum
//    {
//        ShareTypeSinaWeibo = 1,         /**< 新浪微博 */
//        ShareTypeTencentWeibo = 2,      /**< 腾讯微博 */
//        ShareTypeSohuWeibo = 3,         /**< 搜狐微博 */
//        ShareType163Weibo = 4,          /**< 网易微博 */
//        ShareTypeDouBan = 5,            /**< 豆瓣社区 */
//        ShareTypeQQSpace = 6,           /**< QQ空间 */
//        ShareTypeRenren = 7,            /**< 人人网 */
//        ShareTypeKaixin = 8,            /**< 开心网 */
//        ShareTypePengyou = 9,           /**< 朋友网 */
//        ShareTypeFacebook = 10,         /**< Facebook */
//        ShareTypeTwitter = 11,          /**< Twitter */
//        ShareTypeEvernote = 12,         /**< 印象笔记 */
//        ShareTypeFoursquare = 13,       /**< Foursquare */
//        ShareTypeGooglePlus = 14,       /**< Google＋ */
//        ShareTypeInstagram = 15,        /**< Instagram */
//        ShareTypeLinkedIn = 16,         /**< LinkedIn */
//        ShareTypeTumblr = 17,           /**< Tumbir */
//        ShareTypeMail = 18,             /**< 邮件分享 */
//        ShareTypeSMS = 19,              /**< 短信分享 */
//        ShareTypeAirPrint = 20,         /**< 打印 */
//        ShareTypeCopy = 21,             /**< 拷贝 */
//        ShareTypeWeixiSession = 22,     /**< 微信好友 */
//        ShareTypeWeixiTimeline = 23,    /**< 微信朋友圈 */
//        ShareTypeQQ = 24,               /**< QQ */
//        ShareTypeInstapaper = 25,       /**< Instapaper */
//        ShareTypePocket = 26,           /**< Pocket */
//        ShareTypeYouDaoNote = 27,       /**< 有道云笔记 */
//        ShareTypeSohuKan = 28,          /**< 搜狐随身看 */
//        ShareTypePinterest = 30,        /**< Pinterest */
//        ShareTypeFlickr = 34,           /**< Flickr */
//        ShareTypeDropbox = 35,          /**< Dropbox */
//        ShareTypeVKontakte = 36,        /**< VKontakte */
//        ShareTypeWeixiFav = 37,         /**< 微信收藏 */
//        ShareTypeYiXinSession = 38,     /**< 易信好友 */
//        ShareTypeYiXinTimeline = 39,    /**< 易信朋友圈 */
//        ShareTypeYiXinFav = 40,         /**< 易信收藏 */
//        ShareTypeMingDao = 41,          /**< 明道 */
//        ShareTypeLine = 42,             /**< Line */
//        ShareTypeWhatsApp = 43,         /**< Whats App */
//        ShareTypeKaKaoTalk = 44,        /**< KaKao Talk */
//        ShareTypeKaKaoStory = 45,       /**< KaKao Story */
//        ShareTypeOther = -1,            /**< > */
//        ShareTypeAny = 99               /**< 任意平台 */
//    }
//    ShareType;
}

// ShareSDK配置分享
+ (void)loadShareSDK {
    NSLog(@"当前ShareSDK的版本号：%@", [ShareSDK version]);

    [ShareSDK registerApp:kShareSDKAppKey];
    
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http:open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:kSinaAppKey
                               appSecret:kSinaAppSecret
                             redirectUri:kSinaRedirectUrl];

//    分享到空间
    [ShareSDK connectQZoneWithAppKey:kQQAppID
                           appSecret:kQQSpaceSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //添加QQ应用
    [ShareSDK connectQQWithQZoneAppKey:kQQAppID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:kWXAppID wechatCls:[WXApi class]];
    
    
//    添加短信分享
    [ShareSDK connectSMS];
    //添加邮件分享
    [ShareSDK connectMail];
}

// 分享链接
+ (void)shareUrl:(NSString *)url image:(UIImage *)image title:(NSString *)title content:(NSString *)content shareType:(NSInteger)shareType callback:(void(^)(BOOL isSuccessed))callback {

    if (!url) {
        NSAssert(NO, @"分享链接的时候，链接居然为空！");
        return;
    }
    id<ISSCAttachment> attImg = image ? [ShareSDK jpegImageWithImage:image quality:1] : nil;
    
    if (shareType == ShareTypeSinaWeibo || shareType == ShareTypeTencentWeibo || shareType ==ShareTypeMail || shareType ==ShareTypeSMS) { // 如果是新浪微博分享则在内容里面添加链接地址
        content = [NSString stringWithFormat:@"%@%@", content, url];
    }
    
    // 构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:attImg
                                                title:title
                                                  url:url
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    
    // 定制微信朋友圈信息
    if (shareType == ShareTypeWeixiTimeline) {
        NSString *wxUrl = [NSString stringWithFormat:@"%@?isWeixin=1", url];
        [publishContent addWeixinTimelineUnitWithType:@(SSPublishContentMediaTypeNews)
                                              content:INHERIT_VALUE
                                                title:content /*微信朋友圈，没有title，直接使用content*/
                                                  url:wxUrl
                                                image:attImg
                                         musicFileUrl:INHERIT_VALUE
                                              extInfo:nil
                                             fileData:nil
                                         emoticonData:nil];
    }
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"内容分享" shareViewDelegate:nil];
    
    [ShareSDK shareContent:publishContent type:(ShareType)shareType authOptions:authOptions shareOptions:shareOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state != SSResponseStateBegan) {
            switch (state) {
                case SSResponseStateSuccess:    // 分享成功
                    callback(YES);  
                    break;
                case SSResponseStateCancel:     // 
                    kLogShare(@"分享取消");
                    break;
                case SSResponseStateFail:
                default:
                    kLogShare(@"分享错误:（%d）%@", [error errorCode], [error errorDescription]);
                    /* errorCode
                    -10001 取消添加好友
                    -11001 此方法已过时，请使用getFriendsWithPage方法代替
                    -14001 分享失败!
                    -22001 尚未集成微信接口
                    -22002 未知的消息发送类型
                    -22003 尚未安装微信
                    -22004 当前微信版本不支持该功能
                    -22005 请求微信OpenApi失败
                    -22006 尚未设置微信的URL Scheme -24001 发送失败
                    -24002 尚未安装QQ
                    -24003 当前QQ版本不支持该功能
                    -24004 未知的消息发送类型
                    -24005 尚未集成QQ接口
                    -24006 尚未设置QQ的URL Scheme
                     
                    -103 尚未授权
                    */
                    NSString *errorDescription = nil;
                    switch ([error errorCode]) {
                        case -103:
                            errorDescription = @""; // 新浪授权取消，不给出提示
                            break;
                        case -22003:
                            errorDescription = @"请安装微信客户端";
                            break;
                        case -24002:
                            errorDescription = @"请安装QQ手机客户端";
                            break;
                        default: 
                            errorDescription = nil;
                            break;
                    }
                    
                    if (errorDescription) {
                        if (errorDescription.length > 0) {
                            [[[UIAlertView alloc] initWithTitle:nil message:errorDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                        }
                    }
                    else {
                        callback(NO);   // 分享失败
                    }
                    
                    break;
            }
        }
    }];
}

// 分享GIF图片
+ (void)shareGifWithImagePath:(NSString *)imagePath title:(NSString *)title content:(NSString *)content shareType:(NSInteger)shareType callback:(void(^)(BOOL isSuccessed))callback{
    
#warning @"这个方法目前尚没进过测试"
    
    //    if(!imageData){
    //        return;
    //    }
    //    NSData *imageData = nil;
    //    if(UIImageJPEGRepresentation(image, 1)){
    //        imageData = UIImageJPEGRepresentation(image, 1);
    //    }else{
    //        imageData = UIImagePNGRepresentation(image);
    //    }
    
    //必须添加一张默认的
//    id<ISSContent> publishContent = [ShareSDK content:nil
//                                       defaultContent:nil
//                                                image:[ShareSDK jpegImageWithImage:[UIImage imageNamed:@"addImage"] quality:1]
//                                                title:title
//                                                  url:nil
//                                          description:content
//                                            mediaType:SSPublishContentMediaTypeGif];
//    
//    if (shareType == ShareTypeWeixiSession) {//分享到微信朋友
//        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
//                                             content:INHERIT_VALUE
//                                               title:INHERIT_VALUE
//                                                 url:INHERIT_VALUE
//                                               image:INHERIT_VALUE
//                                        musicFileUrl:nil
//                                             extInfo:nil
//                                            fileData:nil
//                                        emoticonData:[NSData dataWithContentsOfFile:imagePath]];
//    }
//    
//    //定制QQ分享信息
//    if (shareType == ShareTypeQQ) {
//    }
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
    //    //在授权页面中添加关注官方微博
    //    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
    //                                    nil]];
    
    
//    [ShareSDK shareContent:publishContent
//                      type:(ShareType)shareType
//               authOptions:authOptions
//             statusBarTips:YES
//                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                        
//                        if (state == SSPublishContentStateSuccess) {
//                            callback(YES);
//                        }
//                        else if (state == SSPublishContentStateFail) {
//                            if ([error errorCode] == -22003) {
//                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                                                    message:[error errorDescription]
//                                                                                   delegate:nil
//                                                                          cancelButtonTitle:@"确定"
//                                                                          otherButtonTitles:nil];
//                                [alertView show];
//                            }
//                            else {
//                                callback(NO);
//                            }
//                        }
//                    }];
}






@end
