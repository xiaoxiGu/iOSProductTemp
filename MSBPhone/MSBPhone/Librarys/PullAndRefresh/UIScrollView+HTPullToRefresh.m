//
//  UIScrollView+HTPullToRefresh.m
//  haitao-ios
//
//  Created by Cure on 14/12/30.
//  Copyright (c) 2014年 haitao. All rights reserved.
//

#import "UIScrollView+HTPullToRefresh.h"
#import <objc/runtime.h>
#import "UIColor+HTColors.h"
#import <PureLayout/PureLayout.h>


static char UIScrollViewPullToRefresh;

@implementation UIScrollView (HTPullToRefresh)

#pragma mark - Property

- (void)setRefreshView:(HTPullToRefreshView *)refreshView
{
    [self willChangeValueForKey:@"UIScrollViewPullToRefresh"];
    objc_setAssociatedObject(self,
                             &UIScrollViewPullToRefresh,
                             refreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewPullToRefresh"];
}

- (HTPullToRefreshView *)refreshView
{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefresh);
}

#pragma mark -

- (HTPullToRefreshView *)addPullToRefreshViewWithActionBlock:(void (^)(void))actionBlock
{
   return [self addPullToRefreshViewWithLogoImage:nil pullingImags:@[] loadingImages:@[] actionBlock:actionBlock];
}

- (HTPullToRefreshView *)addPullToRefreshViewWithLogoImage:(UIImage *)logoImage pullingImags:(NSArray *)pullingImages loadingImages:(NSArray *)loadingImages actionBlock:(void (^)(void))actionBlock
{
    if (!self.refreshView) {
        HTPullToRefreshView *refreshView = [[HTPullToRefreshView alloc] initWithFrame:CGRectMake(0.0f, -HTPullToRefreshViewHeight, CGRectGetWidth([UIScreen mainScreen].bounds), HTPullToRefreshViewHeight)];
        
        refreshView.originalContentInsetY = self.contentInset.top;
        
        
        refreshView.scrollView = self;
        refreshView.pullToRefreshActionBlock = actionBlock;
        [self addSubview:refreshView];
        
        self.refreshView = refreshView;
    }
    return self.refreshView;
}

- (void)triggerPullRefresh
{
    [self.refreshView triggerRefresh];
}

- (void)removePullToRefresh
{
    [self.refreshView unregisterFromKVO];
}

- (void)didFinishPullToRefresh
{
    [self.refreshView endLoading];
}

@end