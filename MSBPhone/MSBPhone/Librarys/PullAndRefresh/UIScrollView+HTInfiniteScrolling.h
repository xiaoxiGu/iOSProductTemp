//
//  UIScrollView+HTInfiniteScrolling.h
//  haitao-ios
//
//  Created by Cure on 15/1/4.
//  Copyright (c) 2015年 haitao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTInfiniteScrollingState) {
    HTInfiniteScrollingViewStateStopped = 0,
    HTInfiniteScrollingViewSateTriggered,
    HTInfiniteScrollingViewStateLoading
};

@interface HTInfiniteScrollingView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void (^infiniteScrollingActionBlock)();
@property (nonatomic, assign) HTInfiniteScrollingState state;
@property (nonatomic, assign) BOOL enabled;

- (void)setCustomView:(UIView *)view forState:(HTInfiniteScrollingState)state;
- (void)startAnimating;
- (void)stopAnimating;

@end

@interface UIScrollView (HTInfiniteScrolling)

@property (nonatomic, strong) HTInfiniteScrollingView *infiniteScrollingView;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;

- (void)addInfiniteScrollingViewWithActionBlock:(void (^)(void))actionBlock;
- (void)triggerInfiniteScrolling;
- (void)didResetInfiniteScrolling;
- (void)didFinishInfiniteScrolling;

- (void)removeInfiniteScrollingExplicitly;
@end
