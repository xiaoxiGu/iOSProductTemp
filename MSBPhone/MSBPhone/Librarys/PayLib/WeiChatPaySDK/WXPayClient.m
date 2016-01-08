//
//  WXPayClient.m
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "WXApi.h"
#import "WXPayClient.h"
#import "CommonUtil.h"

NSString *AccessTokenKey = @"access_token";
NSString *PrePayIdKey = @"prepayid";
NSString *errcodeKey = @"errcode";
NSString *errmsgKey = @"errmsg";
NSString *expiresInKey = @"expires_in";

/**
 *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
 */
NSString * const WXAppId = @"wx85d5c26606f09756";

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXAppKey = @"JaTOlQ6OtCICEFXYDML1FoViBov4Lv2PmOjyKqcyO9Pw8ieB3gXzt8ACOwlt0XpDRSKV2IUvEaWJP3koRNlQTWsPlOIPP4tkZhGL7Dq4jHJ8p2Bn92HV873uP6WhF7s2";

/**
 * 微信开放平台和商户约定的密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXAppSecret = @"7b85d109aa2797b13a23e916744c1571";

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXPartnerKey = @"95d345c686c72da0a47cdf84ccd617a1";

/**
 *  微信公众平台商户模块生成的ID
 */
NSString * const WXPartnerId = @"1232345301";

#define NOTIFY_URL      @"http://www.msb365.com/home/payment_index/wxsdk"

@interface WXPayClient ()

@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, copy) NSString *traceId;
@property (nonatomic, copy) NSString *order_Number;
@property (nonatomic, copy) NSString *order_Amount;
@property (nonatomic, copy) NSString *order_Name;
@end

@implementation WXPayClient

#pragma mark - Public

+ (instancetype)shareInstance
{
    static WXPayClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[WXPayClient alloc] init];
    });
    return sharedClient;
}

- (void)payProduct:(NSString *)order_number OrderAmout:(NSString *)orderAmount OrderName:(NSString *)orderName;
{
    self.order_Amount = orderAmount;
    self.order_Name = orderName;
    self.order_Number = order_number;
    [self getAccessToken];
}

#pragma mark - 生成各种参数

- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

/**
 * 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪
 */
- (NSString *)genTraceId
{
    return self.order_Number;
}

- (NSString *)genOutTradNo
{
    return self.order_Number;
}

- (NSString *)genPackage
{
    // 构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:self.order_Name forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    [params setObject:NOTIFY_URL forKey:@"notify_url"];
    [params setObject:[self genOutTradNo] forKey:@"out_trade_no"];
    [params setObject:WXPartnerId forKey:@"partner"];
    [params setObject:[CommonUtil getIPAddress:YES] forKey:@"spbill_create_ip"];
    [params setObject:@"1" forKey:@"total_fee"];    // 1 =＝ ¥0.01
    
    NSArray *keys = [params allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    
    [package appendString:@"key="];
    [package appendString:WXPartnerKey]; // 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[CommonUtil md5:[package copy]] uppercaseString];
    package = nil;
    
    //     生成 packageParamsString
    NSString *value = nil;
    package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];
    
    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    
    NSLog(@"--- Package: %@", result);
    
    return result;
}

- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [CommonUtil sha1:signString];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}

- (NSMutableData *)getProductArgs
{
    self.timeStamp = [self genTimeStamp];
    self.nonceStr = [self genNonceStr]; // traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
    self.traceId = [self genTraceId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:WXAppId forKey:@"appid"];
    [params setObject:WXAppKey forKey:@"appkey"];
    [params setObject:self.nonceStr forKey:@"noncestr"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
    [params setObject:self.traceId forKey:@"traceid"];
    [params setObject:[self genPackage] forKey:@"package"];
    [params setObject:[self genSign:params] forKey:@"app_signature"];
    [params setObject:@"sha1" forKey:@"sign_method"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSLog(@"--- ProductArgs: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return [NSMutableData dataWithData:jsonData];
}

#pragma mark - 主体流程

- (void)getAccessToken
{
    NSString *getAccessTokenUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%@&secret=%@", WXAppId, WXAppSecret];
    
    NSLog(@"--- GetAccessTokenUrl: %@", getAccessTokenUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getAccessTokenUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data && !connectionError) {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dict) {
                NSString *accessToken = dict[AccessTokenKey];
                if (accessToken) {
                    NSLog(@"--- AccessToken: %@", accessToken);
                    [self getPrepayId:accessToken];
                } else {
                    NSString *strMsg = [NSString stringWithFormat:@"errcode: %@, errmsg:%@", dict[errcodeKey], dict[errmsgKey]];
                    NSLog(@"微信支付错误%@", strMsg);
                }
            }
        }else{
            NSLog(@"微信支付错误%@", connectionError.domain);
        }
    }];
}

- (void)getPrepayId:(NSString *)accessToken
{
    NSString *getPrepayIdUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@", accessToken];
    
    NSLog(@"--- GetPrepayIdUrl: %@", getPrepayIdUrl);
    
    NSMutableData *postData = [self getProductArgs];
    
    // 文档: 详细的订单数据放在 PostData 中,格式为 json
    NSMutableURLRequest *requestPrePay = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getPrepayIdUrl]];
    [requestPrePay addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestPrePay addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    requestPrePay.HTTPMethod = @"POST";
    requestPrePay.HTTPBody = postData;
    [NSURLConnection sendAsynchronousRequest:requestPrePay queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data && !connectionError) {
                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                if (dict && dict[PrePayIdKey]) {
                    NSLog(@"--- PrePayId: %@", dict[PrePayIdKey]);
                    
                    // 调起微信支付
                    PayReq *request   = [[PayReq alloc] init];
                    request.partnerId = WXPartnerId;
                    request.prepayId  = dict[PrePayIdKey];
                    request.package   = @"Sign=WXPay";      // 文档为 `Request.package = _package;` , 但如果填写上面生成的 `package` 将不能支付成功
                    request.nonceStr  = self.nonceStr;
                    request.timeStamp = [self.timeStamp longLongValue];
                    
                    // 构造参数列表
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setObject:WXAppId forKey:@"appid"];
                    [params setObject:WXAppKey forKey:@"appkey"];
                    [params setObject:request.nonceStr forKey:@"noncestr"];
                    [params setObject:request.package forKey:@"package"];
                    [params setObject:request.partnerId forKey:@"partnerid"];
                    [params setObject:request.prepayId forKey:@"prepayid"];
                    [params setObject:[NSString stringWithFormat:@"%@", @(request.timeStamp)] forKey:@"timestamp"];
                    
                    request.sign = [self genSign:params];
                    
                    // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
                    [WXApi sendReq:request];
                }else{
                    NSLog(@"微信支付错误%@", @"PrePayId");
                }
            }else{
                NSLog(@"微信支付错误%@", connectionError.domain);
            }
        });
    }];
}
@end
