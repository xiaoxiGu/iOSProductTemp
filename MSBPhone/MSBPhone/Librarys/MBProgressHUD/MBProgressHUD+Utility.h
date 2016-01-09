//
//  MBProgressHUD+Utility.h
//  WinWorld
//
//  Created by Cyril Hu on 14-6-7.
//  Copyright (c) 2014年 WinWorld. All rights reserved.
//

#import "MBProgressHUD.h"

/** 显示提醒
 只会显示一个提醒，显示新提醒时，上一个会自动移除。
 text 支持换行显示，title不支持。
 */
@interface MBProgressHUD (Utility)

/** 显示文字提醒，1.5s 后自动消失，text 过长时支持换行显示 */
+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text title:(NSString *)title;

/** 显示 UIActivityIndicatorView，不会自动消失，需隐藏可调用 `hide`，`showText:` 或 `showImage:`，text 过长时支持换行显示 */
+ (void)showLoading:(NSString *)text;
+ (void)showLoading:(NSString *)text title:(NSString *)title color:(UIColor *)color;

/** 显示圆形进度饼图，不会自动消失，需隐藏可调用 `hide`，`showText:` 或 `showImage:`，text 过长时支持换行显示 */
+ (void)showProgress:(NSString *)text;
+ (void)showProgress:(NSString *)text title:(NSString *)title;
+ (void)updateProgress:(float)progress;

/** 显示图片，大小默认为 37 X 37，1.5s 后自动消失，text 过长时支持换行显示 */
+ (void)showImage:(UIImage *)image text:(NSString *)text;
+ (void)showImage:(UIImage *)image text:(NSString *)text title:(NSString *)title;

/** 马上隐藏所有提醒 */
+ (void)hide;

@end
