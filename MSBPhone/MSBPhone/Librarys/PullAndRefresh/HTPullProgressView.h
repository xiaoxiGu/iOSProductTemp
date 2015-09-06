//
//  HTPullProgressView.h
//  HiTao
//
//  Created by hitao4 on 15/7/22.
//  Copyright (c) 2015年 hitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTPullProgressView : UIView

@property (nonatomic,assign) CGFloat  progressValue;

- (void)startLoading;
- (void)endLoading;

@end
