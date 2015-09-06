//
//  HTProgressView.h
//  ProgressDemo
//
//  Created by hitao4 on 15/8/10.
//  Copyright (c) 2015年 hitao4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTProgressView : UIView

@property (nonatomic,strong) UIView * centraView;


- (void)animateToProgress:(CGFloat)progress;
- (void)startLoading;
- (void)endLoading;
@end
