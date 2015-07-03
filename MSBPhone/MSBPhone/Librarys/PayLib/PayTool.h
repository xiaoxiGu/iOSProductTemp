//
//  PayTool.h
//  master
//
//  Created by dehang on 15/6/30.
//  Copyright (c) 2015年 dgutwindy.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  以下通知需要在自己控制器中增加然后去做相应的处理。
 */
#define kNotificationWXPayCancel  @"MTNCommentNOSucc"
#define kNotificationWXPaySuccess @"MTNCommentSucc"

@interface PayTool : NSObject


+ (PayTool*)sharedPayTool;
/**
 *  微信支付接口
 *
 *  @param order_number 定单编号
 *  @param orderAmount  付款金额
 *  @param orderName    订单名字
 */
+(void)WXPayWithOrderNumber:(NSString *)order_number OrderAmout:(NSString *)orderAmount OrderName:(NSString *)orderName;
/**
 *  余额宝支付方法
 *
 *  @param notifyUrl          //回调URL
 *  @param returnURL          //回调URL
 *  @param order_no           //订单ID（由商家自行制定）
 *  @param productName        //商品标题
 *  @param productDescription //商品描述
 *  @param orderAmount        商品价格
 *  @param resultBlock        回调block
 */
+(void)AliPayWithNotifyURL:(NSString *)notifyUrl  returnURL:(NSString *)returnURL  OrderNo:(NSString*)order_no ProductName:(NSString *)productName ProductDesc:(NSString *)productDescription OrderAmout:(NSString *)orderAmount
               resultBlock:(void(^)(NSDictionary * para,NSInteger errorCode))resultBlock;

+(BOOL)HandleApplicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end
