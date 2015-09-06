//
//  UIScrollView+HTPullToRefresh.h
//  haitao-ios
//
//  Created by Cure on 14/12/30.
//  Copyright (c) 2014年 haitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTPullToRefreshView.h"

/**
 * 下拉刷新
 */
@interface UIScrollView (HTPullToRefresh)

@property (nonatomic, strong) HTPullToRefreshView *refreshView;

/**
 * 初始化方法
 */
- (HTPullToRefreshView *)addPullToRefreshViewWithActionBlock:(void (^)(void))actionBlock;

/**
 * 触发下拉刷新
 */
- (void)triggerPullRefresh;

/**
 * 需在viewController的dealloc中调用
 */
- (void)removePullToRefresh;

/**
 * 需在获取完数据时调用, 通知scrollView回弹PullToRefresh视图
 */
- (void)didFinishPullToRefresh;

@end
