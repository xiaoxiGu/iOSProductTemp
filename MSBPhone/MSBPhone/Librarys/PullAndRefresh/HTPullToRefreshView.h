//
//  HTPullToRefreshView.h
//  HiTao
//
//  Created by hitao3 on 15/7/20.
//  Copyright (c) 2015年 hitao. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat HTPullToRefreshViewHeight;

typedef NS_ENUM(NSInteger, HTPullToRefreshState) {
    HTPullToRefreshStatePulling,
    HTPullToRefreshStateLoading,
    HTPullToRefreshStateCompleted
};

@interface HTPullToRefreshView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void (^pullToRefreshActionBlock)();
@property (nonatomic, assign) HTPullToRefreshState state;
@property (nonatomic, assign) BOOL triggered;
@property (nonatomic, assign) CGFloat originalContentInsetY;

@property (nonatomic, strong) UILabel *refreshLabel;

- (void)endLoading;

- (void)triggerRefresh;

- (void)registerForKVO;

- (void)unregisterFromKVO;

@end