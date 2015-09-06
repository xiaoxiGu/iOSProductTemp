//
//  UIColor+HTColors.m
//  HiTao
//
//  Created by hitao3 on 15/6/29.
//  Copyright (c) 2015年 hitao. All rights reserved.
//

#import "UIColor+HTColors.h"
#import <ColorUtils/ColorUtils.h>

@implementation UIColor (HTColors)

+ (UIColor *)htRedColor {
    return [UIColor colorWithString:@"#e10482"];
}

+ (UIColor *)htRedDisabledColor {
    return [UIColor colorWithString:@"#EEEEEE"];
}

+ (UIColor *)htLightDisabledColor {
    return [UIColor colorWithString:@"#f2f2f2"];
}

+ (UIColor *)htHighlightedRedColor {
    return [UIColor colorWithString:@"#CA0475"];
}

+ (UIColor *)htHighlightedGreyColor {
    return [UIColor colorWithString:@"#FCE5F2"];
}

+ (UIColor *)htBlackTextColor {
    return [UIColor colorWithString:@"#444444"];
}

+ (UIColor *)htGrayTextColor {
    return [UIColor colorWithString:@"#999999"];
}

+ (UIColor *)htCellBackgroundColor {
    return [UIColor colorWithString:@"#f2F0F0"];
}

+ (UIColor *)htSeparatorColor {
    return [UIColor colorWithString:@"#DDDDDD"];
}

+ (UIColor *)htViewBackgroundColor {
    return [UIColor colorWithString:@"#f5f5f5"];
}

+ (UIColor *)htBuyButtonOnSaleColor {
    return [UIColor blackColor];
}

+ (UIColor *)htBuyButtonWillOnSaleColor {
    return [UIColor colorWithString:@"#7eb254"];
}

@end
