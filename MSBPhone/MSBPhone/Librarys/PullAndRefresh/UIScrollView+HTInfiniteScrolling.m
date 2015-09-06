//
//  UIScrollView+HTInfiniteScrolling.m
//  haitao-ios
//
//  Created by Cure on 15/1/4.
//  Copyright (c) 2015年 haitao. All rights reserved.
//

#import "UIScrollView+HTInfiniteScrolling.h"
#import <objc/runtime.h>
#import <PureLayout/PureLayout.h>
#import "UIColor+HTColors.h"

static const CGFloat HTInfiniteScrollingViewHeight = 44.0f;

@interface HTInfiniteScrollingView ()

@property (nonatomic, strong) UILabel *finishLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableArray *viewForState;

@property (nonatomic, assign) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL isObserving;

@property (nonatomic, assign) BOOL finishInfiniteScrolling;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation HTInfiniteScrollingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = HTInfiniteScrollingViewStateStopped;
        self.enabled = YES;
        
        self.viewForState = [NSMutableArray arrayWithArray:@[@"", @"", @""]];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && !newSuperview) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsInfiniteScrolling) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_activityIndicatorView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_activityIndicatorView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - Property

- (UILabel *)finishLabel
{
    if (!_finishLabel) {
        _finishLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _finishLabel.text = @"已显示全部内容";
        _finishLabel.textColor = [UIColor htGrayTextColor];
        _finishLabel.textAlignment = NSTextAlignmentCenter;
        _finishLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:_finishLabel];
        _finishLabel.hidden = YES;
        [_finishLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_finishLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return _finishLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}

- (void)setCustomView:(UIView *)view forState:(HTInfiniteScrollingState)state
{
    id viewPlacehodler = view;
    if (!viewPlacehodler) {
        viewPlacehodler = @"";
    }
    
    self.viewForState[state] = viewPlacehodler;
    
    self.state = self.state;
//    self.state = state;
}

- (void)setState:(HTInfiniteScrollingState)state
{
    if (_state != state) {
        HTInfiniteScrollingState previousState = _state;
        _state = state;
        
        for (id theView in self.viewForState) {
            if ([theView isKindOfClass:[UIView class]]) {
                [theView removeFromSuperview];
            }
        }
        
        id customView = self.viewForState[state];
        BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
        
        if (hasCustomView) {
            [self addSubview:customView];
            CGRect viewBounds = [customView bounds];
            CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
            [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
        } else {
            CGRect viewBounds = [self.activityIndicatorView bounds];
            CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
            [self.activityIndicatorView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
            
            switch (state) {
                case HTInfiniteScrollingViewStateStopped:
                    [self.activityIndicatorView stopAnimating];
                    break;
                    
                case HTInfiniteScrollingViewSateTriggered:
                    [self.activityIndicatorView startAnimating];
                    break;
                    
                case HTInfiniteScrollingViewStateLoading:
                    [self.activityIndicatorView startAnimating];
                    break;
            }
        }
        
        if (previousState == HTInfiniteScrollingViewSateTriggered && state == HTInfiniteScrollingViewStateLoading && self.infiniteScrollingActionBlock && self.enabled) {
            self.infiniteScrollingActionBlock();
        }
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:[change[NSKeyValueChangeNewKey] CGPointValue]];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self layoutIfNeeded];
        self.frame = CGRectMake(0.0f, self.scrollView.contentSize.height, CGRectGetWidth(self.bounds), HTInfiniteScrollingViewHeight);
        if (self.finishInfiniteScrolling) {
            self.finishLabel.hidden = NO;
        } else {
            self.finishLabel.hidden = YES;
        }
    }
}

#pragma mark - Utilities

- (void)scrollViewContentOffsetDidChange:(CGPoint)contentOffset
{
    if (self.state != HTInfiniteScrollingViewStateLoading && self.enabled) {
        CGFloat scrollViewContentHeight = self.scrollView.contentSize.height;
        CGFloat scrollOffsetThreshold = scrollViewContentHeight - CGRectGetHeight(self.scrollView.bounds);
        
        if (!self.scrollView.isDragging && self.state == HTInfiniteScrollingViewSateTriggered) {
            self.state = HTInfiniteScrollingViewStateLoading;
        } else if (contentOffset.y > scrollOffsetThreshold && self.state == HTInfiniteScrollingViewStateStopped && self.scrollView.isDragging) {
            self.state = HTInfiniteScrollingViewSateTriggered;
        } else if (contentOffset.y < scrollOffsetThreshold && self.state != HTInfiniteScrollingViewStateStopped) {
            self.state = HTInfiniteScrollingViewStateStopped;
        }
    }
}

- (void)resetScrollViewContentInset
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset;
    [self setScrollViewContentInset:currentInsets];
    
}

- (void)setScrollViewContentInsetInfiniteScrolling
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = self.originalBottomInset + HTInfiniteScrollingViewHeight;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)insets
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentInset = insets;
    } completion:nil];
}

- (void)triggerRefresh
{
    self.state = HTInfiniteScrollingViewSateTriggered;
    self.state = HTInfiniteScrollingViewStateLoading;
}

- (void)startAnimating
{
    self.state = HTInfiniteScrollingViewStateLoading;
}

- (void)stopAnimating
{
    self.state = HTInfiniteScrollingViewStateStopped;
}

@end

static char UIScrollViewInfiniteScrolling;
@implementation UIScrollView (HTInfiniteScrolling)

#pragma mark - Property

- (void)setInfiniteScrollingView:(HTInfiniteScrollingView *)infiniteScrollingView
{
    [self willChangeValueForKey:@"UIScrollViewInfiniteScrolling"];
    objc_setAssociatedObject(self, &UIScrollViewInfiniteScrolling, infiniteScrollingView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewInfiniteScrolling"];
}

- (HTInfiniteScrollingView *)infiniteScrollingView
{
    return objc_getAssociatedObject(self, &UIScrollViewInfiniteScrolling);
}

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling
{
    self.infiniteScrollingView.hidden = !showsInfiniteScrolling;
    
    if (!showsInfiniteScrolling) {
        if (self.infiniteScrollingView.isObserving) {
            [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentOffset"];
            [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentSize"];
            [self.infiniteScrollingView resetScrollViewContentInset];
            self.infiniteScrollingView.isObserving = NO;
        }
    } else {
        if (!self.infiniteScrollingView.isObserving) {
            [self addObserver:self.infiniteScrollingView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
            [self addObserver:self.infiniteScrollingView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
            [self.infiniteScrollingView setScrollViewContentInsetInfiniteScrolling];
            self.infiniteScrollingView.isObserving = YES;
            
            [self.infiniteScrollingView setNeedsLayout];
            self.infiniteScrollingView.frame = CGRectMake(0.0f, self.contentSize.height, CGRectGetWidth(self.infiniteScrollingView.bounds), HTInfiniteScrollingViewHeight);
        }
    }
}

- (BOOL)showsInfiniteScrolling
{
    return !self.infiniteScrollingView.hidden;
}

#pragma mark - Utilities

- (void)addInfiniteScrollingViewWithActionBlock:(void (^)(void))actionBlock
{
    if (!self.infiniteScrollingView) {
        HTInfiniteScrollingView *view = [[HTInfiniteScrollingView alloc] initWithFrame:CGRectMake(0.0f, self.contentSize.height, CGRectGetWidth(self.bounds), HTInfiniteScrollingViewHeight)];
        view.infiniteScrollingActionBlock = actionBlock;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalBottomInset = self.contentInset.bottom;
        self.infiniteScrollingView = view;
        self.showsInfiniteScrolling = YES;
    }
    self.infiniteScrollingView.finishInfiniteScrolling = NO;
}

- (void)triggerInfiniteScrolling
{
    self.infiniteScrollingView.state = HTInfiniteScrollingViewSateTriggered;
    [self.infiniteScrollingView startAnimating];
}

- (void)didResetInfiniteScrolling
{
    self.infiniteScrollingView.finishInfiniteScrolling = NO;
}

- (void)didFinishInfiniteScrolling
{
    self.infiniteScrollingView.finishInfiniteScrolling = YES;
}

- (void)removeInfiniteScrollingExplicitly
{
    if (self.infiniteScrollingView) {
        [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentOffset"];
        [self removeObserver:self.infiniteScrollingView forKeyPath:@"contentSize"];
        self.infiniteScrollingView.isObserving = NO;
    }
}

@end
