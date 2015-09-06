//
//  HTPullToRefreshView.m
//  HiTao
//
//  Created by hitao3 on 15/7/20.
//  Copyright (c) 2015年 hitao. All rights reserved.
//

#import "HTPullToRefreshView.h"
#import <objc/runtime.h>
#import "UIColor+HTColors.h"
#import <PureLayout/PureLayout.h>
#import "HTProgressView.h"
#import <libextobjc/EXTScope.h>
#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

#define cDefaultFloatComparisonEpsilon    0.001
#define cEqualFloats(f1, f2, epsilon)    ( fabs( (f1) - (f2) ) < epsilon )
#define cNotEqualFloats(f1, f2, epsilon)    ( !cEqualFloats(f1, f2, epsilon) )

CGFloat HTPullToRefreshViewHeight = 50.0f;

@interface HTPullToRefreshView ()

@property (nonatomic, assign) BOOL didSetupContraints;

@property (nonatomic, assign) BOOL animating;


@property (nonatomic, strong) HTProgressView * progressView;

@property (nonatomic, strong) UIImageView *sloganImageView;

@end

@implementation HTPullToRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _refreshLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refreshLabel.font = [UIFont systemFontOfSize:13.0f];
        _refreshLabel.textColor = [UIColor htGrayTextColor];
        _refreshLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_refreshLabel];
        
        _sloganImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slogan"]];
        [self addSubview:_sloganImageView];
        
        _progressView = [[HTProgressView alloc] initWithFrame:CGRectMake(0.f, 0.f, 28.f, 28.f)];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetHeight(self.progressView.frame)-3.f, CGRectGetHeight(self.progressView.frame)-3.f)];
        imageView.image = [UIImage imageNamed:@"loading_icon"];
        _progressView.centraView = imageView;
        [self addSubview:_progressView];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterFromKVO];
}

- (void)updateConstraints
{
    if (!self.didSetupContraints) {
        /*
        [_refreshLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [_refreshLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self withOffset:10.0f];
         */
        
        [_progressView autoSetDimension:ALDimensionWidth toSize:28.f];
        [_progressView autoSetDimension:ALDimensionHeight toSize:28.f];
        [_progressView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
        [_progressView autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
        
        [_sloganImageView autoSetDimension:ALDimensionWidth toSize:156.f];
        [_sloganImageView autoSetDimension:ALDimensionHeight toSize:14.f];
        [_sloganImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_progressView withOffset:-10.f];
        [_sloganImageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    }
    [super updateConstraints];
}

#pragma mark - Property

- (void)setScrollView:(UIScrollView *)scrollView
{
    [self unregisterFromKVO];
    _scrollView = scrollView;
    [self registerForKVO];
}

- (void)setState:(HTPullToRefreshState)state
{
    CGFloat offset = -(self.scrollView.contentOffset.y + self.originalContentInsetY);
    if (offset < 0.0f) {
        offset = 0.0f;
    }
    if (offset > HTPullToRefreshViewHeight) {
        offset = HTPullToRefreshViewHeight;
    }
    
    CGFloat percent = offset / HTPullToRefreshViewHeight;
    switch (state) {
        case HTPullToRefreshStatePulling:
        {
            if (percent < 1.0f) {
                _refreshLabel.text = @"下拉即可刷新...";
            } else {
                _refreshLabel.text = @"释放即可刷新...";
            }
        }
            break;
        case HTPullToRefreshStateLoading:
        {
            _refreshLabel.text = @"刷新中...";
        }
            break;
        case HTPullToRefreshStateCompleted:
        {
            _refreshLabel.text = @"刷新中...";
        }
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"ILLEGAL STATE"];
            break;
    }
    
    _state = state;
}

#pragma mark - KVO

- (void)registerForKVO
{
    for (NSString *keyPath in [self observableKeyPaths]) {
        [self.scrollView addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
}

- (void)unregisterFromKVO
{
    for (NSString *keyPath in [self observableKeyPaths]) {
        [self.scrollView removeObserver:self forKeyPath:keyPath];
    }
    _scrollView = nil;
}

- (NSArray *)observableKeyPaths
{
    return @[@"contentOffset", @"pan.state"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([NSThread isMainThread]) {
        [self updateUIForKeyPath:keyPath];
    } else {
        [self performSelectorOnMainThread:@selector(updateUIForKeyPath:) withObject:keyPath waitUntilDone:NO];
    }
}

- (void)updateUIForKeyPath:(NSString *)keyPath
{
    if (self.scrollView.contentOffset.y + self.originalContentInsetY <= 0) {
        if ([keyPath isEqualToString:@"pan.state"]) {
            [self handleScrollViewPanGesture];
        } else if ([keyPath isEqualToString:@"contentOffset"]) {
            
            NSLog(@"contentInset = %f",_scrollView.contentInset.top);
            NSLog(@"contentOffset = %f",_scrollView.contentOffset.y);
            CGFloat progress = fabs((fabs(_scrollView.contentInset.top) - fabs(_scrollView.contentOffset.y)))/HTPullToRefreshViewHeight;
            if (progress == 0) {
                progress = 1;
            }
            [_progressView animateToProgress:progress];
            [self scrollViewContentOffsetDidChange];
        }
    }
}

#pragma mark - Utilities

- (void)handleScrollViewPanGesture
{
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded
        && self.triggered) {
        [self triggerRefresh];
    }
}

- (void)triggerRefresh {
    self.state = HTPullToRefreshStateLoading;
    

    @weakify(self);
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        @strongify(self);
        
        self.scrollView.contentOffset = CGPointMake(0, -HTPullToRefreshViewHeight - self.originalContentInsetY);
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.top = HTPullToRefreshViewHeight + self.originalContentInsetY;
        self.scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        if (self.pullToRefreshActionBlock) {
            @strongify(self);
            [self.progressView startLoading];
            self.pullToRefreshActionBlock();
        }
    }];
}

- (void)scrollViewScrollWithOffset:(CGFloat)offset {
    
}

- (void)scrollViewContentOffsetDidChange
{
    if (self.state != HTPullToRefreshStateLoading && self.state != HTPullToRefreshStateCompleted) {
        if (self.scrollView.isDragging
            && self.scrollView.contentOffset.y + self.originalContentInsetY < -HTPullToRefreshViewHeight
            && !self.triggered) {
            self.triggered = YES;
        } else {
            if (self.scrollView.isDragging
                && self.scrollView.contentOffset.y + self.originalContentInsetY > -HTPullToRefreshViewHeight) {
                self.triggered = NO;
            }
            self.state = HTPullToRefreshStatePulling;
        }
    }
    
    if ((self.scrollView.contentOffset.y + self.originalContentInsetY) >= 0.0f && !_animating) {
        //self.refreshImageView.hidden = YES;
    } else {
        //self.refreshImageView.hidden = NO;
    }
}

- (void)endLoading
{
    if (self.state == HTPullToRefreshStateLoading) {
        self.triggered = NO;
        [_progressView endLoading];
        
        self.state = HTPullToRefreshStateCompleted;
        
        _animating = YES;
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            UIEdgeInsets contentInset = self.scrollView.contentInset;
            contentInset.top = self.originalContentInsetY;
            self.scrollView.contentInset = contentInset;
        } completion:^(BOOL finished) {
            self.state = HTPullToRefreshStatePulling;
            //self.refreshImageView.hidden = YES;
            _animating = NO;
        }];
    }
}

@end
