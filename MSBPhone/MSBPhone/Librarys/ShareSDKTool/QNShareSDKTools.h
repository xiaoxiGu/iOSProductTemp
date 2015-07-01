//
//  QNShareSDKTools.h
//  QooccShow
//
//  Created by xiaoxiaofeng on 14/11/7.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface QNShareSDKTools : NSObject

/*!
 *  取消所有本应用的授权
 */
+ (void)cancelAllAuth;

/*!
 *  查询某授权是否有了
 */
+ (BOOL)hasAuthorizedWithType:(ShareType)type;

/*!
 *  查询是否安装了某App
 */
+ (BOOL)isInstalledWithType:(ShareType)type;

/**
 *  ShareSDK配置分享
 */
+ (void)loadShareSDK;

/**
 *  分享链接
 *
 *  @param url       分享链接 （必须要有）
 *  @param image     分享的image
 *  @param title     分享标题
 *  @param content   分享描述
 *  @param shareType 分享类型
 *  @param callback  分享回调
 */
+ (void)shareUrl:(NSString *)url image:(UIImage *)image title:(NSString *)title content:(NSString *)content shareType:(NSInteger)shareType callback:(void(^)(BOOL isSuccessed))callback;

/**
 *  分享GIF图片 （未完成的方法）
 *
 *  @param image     分享图片
 *  @param title     分享标题
 *  @param content   分享内容
 *  @param shareType 分享类型
 *  @param callback  分享回调
 */
//+ (void)shareGifWithImagePath:(NSString *)imagePath title:(NSString *)title content:(NSString *)content shareType:(NSInteger)shareType callback:(void(^)(BOOL isSuccessed))callback;

@end
