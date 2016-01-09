//
//  MBProgressHUD+Utility.m
//  WinWorld
//
//  Created by Cyril Hu on 14-6-7.
//  Copyright (c) 2014年 WinWorld. All rights reserved.
//

#import "MBProgressHUD+Utility.h"


@interface MBProgressHUD (UtilityPrivateHack)
- (void)setTransformForCurrentOrientation:(BOOL)animated;
@end

@implementation MBProgressHUD (Utility)

+ (instancetype)sharedHUD {
    static MBProgressHUD *sharedHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        sharedHUD.removeFromSuperViewOnHide = YES;
        sharedHUD.detailsLabelFont = [UIFont systemFontOfSize:16.0];
        __weak MBProgressHUD *weakSelf = sharedHUD;
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            weakSelf.yOffset = -108;
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            weakSelf.yOffset = 0;
        }];
    });
    return sharedHUD;
}

+ (void)showMode:(MBProgressHUDMode)mode text:(NSString *)text title:(NSString *)title color:(UIColor *)color delay:(NSTimeInterval)delay {
    MBProgressHUD *HUD = [self sharedHUD];
    HUD.color = color;
    HUD.detailsLabelText = text;
    HUD.labelText = title;
    HUD.mode = mode;
    if (delay > 0) {
        [HUD hide:YES afterDelay:delay];
    }
    [HUD setTransformForCurrentOrientation:NO];
    [HUD show:(HUD.superview == nil)]; // 如果已经显示在界面上，就不用动画
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
}

#pragma mark -
+ (void)showText:(NSString *)text {
    [self showText:text title:nil];
}

+ (void)showText:(NSString *)text title:(NSString *)title {
    [self showMode:MBProgressHUDModeText text:text title:title color:nil delay:1.5];
}

#pragma mark -
+ (void)showLoading:(NSString *)text {
    [self showLoading:text title:nil color:nil];
}

+ (void)showLoading:(NSString *)text title:(NSString *)title color:(UIColor *)color{
    [self showMode:MBProgressHUDModeIndeterminate text:text title:title color:color delay:-1];
}

#pragma mark -
+ (void)showProgress:(NSString *)text {
    [self showProgress:text title:nil];
}

+ (void)showProgress:(NSString *)text title:(NSString *)title {
    [self showMode:MBProgressHUDModeDeterminate text:text title:nil color:nil delay:-1];
}

+ (void)updateProgress:(float)progress {
    [[self sharedHUD] setProgress:progress];
}

#pragma mark -
+ (void)showImage:(UIImage *)image text:(NSString *)text {
    [self showImage:image text:text title:nil];
}

+ (void)showImage:(UIImage *)image text:(NSString *)text title:(NSString *)title {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 37.0, 37.0);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [[self sharedHUD] setCustomView:imageView];
    [self showMode:MBProgressHUDModeCustomView text:text title:title color:nil delay:1.5];
}

#pragma mark -
+ (void)hide {
    [[self sharedHUD] hide:YES];
}

@end
