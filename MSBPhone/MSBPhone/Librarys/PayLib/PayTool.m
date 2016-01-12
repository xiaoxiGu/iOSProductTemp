//
//  PayTool.m
//  master
//
//  Created by dehang on 15/6/30.
//  Copyright (c) 2015年 dgutwindy.com. All rights reserved.
//

#import "PayTool.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Order.h"
#import "DataSigner.h"
#import "WXPayClient.h"


@interface PayTool()<WXApiDelegate>

@end
@implementation PayTool

static PayTool* sharedManager;

+ (PayTool*)sharedPayTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[PayTool alloc]init];
      
    });
    return sharedManager;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+(void)WXPayWithOrderNumber:(NSString *)order_number OrderAmout:(NSString *)orderAmount OrderName:(NSString *)orderName
{
//#warning 微信支付，未测试
    [[WXPayClient shareInstance] payProduct:order_number OrderAmout:orderAmount OrderName:orderName];
}

+(void)AliPayWithNotifyURL:(NSString *)notifyUrl  returnURL:(NSString *)returnURL  OrderNo:(NSString*)order_no ProductName:(NSString *)productName ProductDesc:(NSString *)productDescription OrderAmout:(NSString *)orderAmount
   resultBlock:(void(^)(NSDictionary * para,NSInteger errorCode))resultBlock
{
    NSString *alipayCurrent =  [[AlipaySDK defaultService] currentVersion];
    NSLog(@"alipayCurrent is %@",alipayCurrent);
    NSString *appScheme = @"ApliPayWithMinShiBao";
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088811572228741";
    NSString *seller = @"msb365@126.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALQNuNuKtKJRKg9/uV5NxipE2UZllkDUtv2BMuu+7OiQCY+H3VRPHTpEk6/CTLE0CPoOd8i6nqK+V6FuolF3IxRfJ3ViJfuNnEpSlmwxPEa9hjiKrv9fCQdOKOs0beX9A/FLR5VEo9zMY6F8S8O8Dc4Pr2nUrUNmLaJwYR7GPlwbAgMBAAECgYEArQ2nR7Mn6/5Qi7b55g6gUQ39OrD22fbYrgxYccb+koOl/MLb0mV7tP4maD46UfKuUhBHxrC/ObHyLaFU9zGnjxct6Qw/uG5dQaAesQeePp8ASqtdY6KZ78mtBWEG3Ah/8y7F2I19WL+ldWP4pNC7Or3daRHlht8fwAAZb97Vz8ECQQDZZTmoIP/WpWDvV+Dm6Ga1Ma26gNcl+wnOPsm7kAt2KPKOMHUUBQEUOLv2a/V54jXsisOgbEOM09pEfASfHRp7AkEA1AbxGFWS2IQIcdypSGugFuaYQDfJA9HE9cb2hoiXKk0sBvP5H5qos5YcLTSV978XIpPe1V1T7TS0JdNG1WVi4QJBALwFqqpZcCzLeF1JmkDb/Aj24JUP3gUBbGevMndAjEkz/SUxj/Eyqs48i4UDtpomJhFhqvTS7lGc4Yid4rljSIUCQA6Ux6HPyMCBG/+QmEe1txW8F/5al8VeeLgaTbvkytiK5Bs6TgihXzayfQ+SzTlzd8jV+H4d4/atKDJtvDJSvaECQF+SParbB6eqxPJai+R2U/iaSsYWKlDTM1eyex5UPrAKzvAk8y7IxN1oekrXDZmTWcQtoIUZr3qbf3T0RtiXQZM=";
    /*============================================================================*/
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO =order_no; //订单ID（由商家自行制定）
    order.productName =productName; //商品标题
    order.productDescription = productDescription; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[orderAmount floatValue]]; //商品价格
    order.notifyURL = notifyUrl; //回调URL
//    order.returnURL=returnURL;
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //MyLog(@"orderSpec = %@,orderno is %@",orderSpec,orderAmount);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        //orderString = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@",
        //               orderSpec, signedString, @"RSA"];
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
            // MyLog(@"reslut = %@",resultDic);
             if ([resultDic isKindOfClass:[NSDictionary class]])
             {
                 if ([[resultDic objectForKey:@"resultStatus"] intValue]== 9000)
                 {
                     if(resultBlock)resultBlock(nil,0);
                 }
                 else{
                     
                     if(resultBlock)resultBlock(nil,1);
                 }
             }
         }];
    }

}
+(BOOL)HandleApplicationOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //MyLog(@"result = %@",resultDic);
            //             [[NSNotificationCenter defaultCenter]postNotificationName:@"ApliPayNotifacation" object:resultDic];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
           // MyLog(@"result = %@",resultDic);
            //            [[NSNotificationCenter defaultCenter]postNotificationName:@"ApliPayNotifacation" object:resultDic];
        }];
    }
    return [WXApi handleOpenURL:url delegate:[PayTool sharedPayTool]];
}

@end
