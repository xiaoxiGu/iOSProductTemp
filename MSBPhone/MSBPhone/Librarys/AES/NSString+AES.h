//
//  NSString+AES.h
//  QooccHealth
//
//  Created by LiuYu on 15/5/28.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+AES.h"

/**
 *  @author LiuYu, 15-05-28 11:05:35
 *
 *  扩展对 NSString 进行转化成 NSData 然后 进行 AES128 加密 || 解密，在通过Base64格式输出
 *    会先对密钥进行MD5加密，取前32位作为AES128加密的密钥
 */
@interface NSString (AES)

// 加密
- (NSString *)encrypt:(NSString *)key;
// 解密
- (NSString *)decrypt:(NSString *)key;

@end
