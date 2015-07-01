//
//  NSString+AES.m
//  QooccHealth
//
//  Created by LiuYu on 15/5/28.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

#import "NSString+AES.h"

@implementation NSString (AES)

// 加密
- (NSString *)encrypt:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) { return nil; }
    
    NSData *encryptData = [data encrypt:key];
    return [encryptData base64EncodedStringWithOptions:0];
}

// 解密
- (NSString *)decrypt:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    if (data == nil) { return nil; }
    
    NSData *decryptData = [data decrypt:key];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

@end
