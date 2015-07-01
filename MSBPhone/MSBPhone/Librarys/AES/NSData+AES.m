//
//  NSData+AES256.m
//  QooccShow
//
//  Created by LiuYu on 15/2/4.
//  Copyright (c) 2015年 Qoocc. All rights reserved.
//

#import "NSData+AES.h"
#import <CommonCrypto/CommonDigest.h>   // MD5
#import <CommonCrypto/CommonCryptor.h>  // AES128

@implementation NSData (AES)

// 加密
- (NSData *)encrypt:(NSString *)key   {
    return [self aes:[self md5:key] isEncrypt:YES];
}

// 解密
- (NSData *)decrypt:(NSString *)key {
    return [self aes:[self md5:key] isEncrypt:NO];
}

- (NSData *)aes:(NSString *)key isEncrypt:(BOOL)isEncrypt {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t resultBufferSize = dataLength + kCCBlockSizeAES128;
    void *resultBuffer = malloc(resultBufferSize);
    size_t resultLength = 0;
    CCCryptorStatus cryptStatus = CCCrypt((isEncrypt ? kCCEncrypt : kCCDecrypt), kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength /* input */,
                                          resultBuffer, resultBufferSize, &resultLength /* output */);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:resultBuffer length:resultLength];
    }
    
    free(resultBuffer);
    return nil;
}

// 为了保证密钥必须是16位，所以需要对密钥进行求md5，取16位
- (NSString *)md5:(NSString *)key {
    const char * cStrValue = key.UTF8String;  
    unsigned char theResult[CC_MD5_DIGEST_LENGTH];  
    CC_MD5(cStrValue, (CC_LONG)(strlen(cStrValue)), theResult);  
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X",
            theResult[0], theResult[1], theResult[2], theResult[3],   
            theResult[4], theResult[5], theResult[6], theResult[7]];
}

@end
