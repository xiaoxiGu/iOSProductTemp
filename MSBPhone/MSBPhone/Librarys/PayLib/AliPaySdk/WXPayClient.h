//
//  WXPayClient.h
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

extern NSString *const WXAppId;

@interface WXPayClient : NSObject

+ (instancetype)shareInstance;

- (void)payProduct:(NSString *)order_number OrderAmout:(NSString *)orderAmount OrderName:(NSString *)orderName;

@end
