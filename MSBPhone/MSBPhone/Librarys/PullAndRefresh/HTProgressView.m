//
//  HTProgressView.m
//  ProgressDemo
//
//  Created by hitao4 on 15/8/10.
//  Copyright (c) 2015年 hitao4. All rights reserved.
//

#import "HTProgressView.h"
#import "UIColor+HTColors.h"

static NSString *const HTProgressAnimationKey = @"progresskey";
static NSString *const HTCirCularKey = @"animation";
@interface HTCirCularProgress : UIView
- (CAShapeLayer *)shapeLayer;
- (void)updateProgress:(CGFloat)progress;
@end


@interface HTProgressView ()

@property (nonatomic,strong) HTCirCularProgress * progressView;


@property (nonatomic,assign) CGFloat borderWidth;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic, assign) CFTimeInterval animationDuration UI_APPEARANCE_SELECTOR;

@end

@implementation HTProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI{
    self.progressView = [[HTCirCularProgress alloc] initWithFrame:self.bounds];
    self.progressView.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self addSubview:self.progressView];
    
    [self resetDefaults];
}
- (void)resetDefaults{
    _progress = 0.5f;
    _animationDuration = 0.3;
    self.centraView = nil;
    
    self.borderWidth = 1.f;
    self.lineWidth = 2.f;
    
    self.progressView.shapeLayer.strokeColor = [UIColor htRedColor].CGColor;
    self.progressView.shapeLayer.borderColor = [UIColor htRedColor].CGColor;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.progressView.frame = self.bounds;
    self.centraView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)animateToProgress:(CGFloat)progress{
    [self stopAnimation];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = self.animationDuration;
    animation.fromValue = @(self.progress);
    animation.toValue = @(progress);
    animation.delegate = self;
    [self.progressView.shapeLayer addAnimation:animation forKey:HTProgressAnimationKey];

    _progress = progress;
}

- (void)stopAnimation{
    [self.progressView.shapeLayer removeAnimationForKey:HTProgressAnimationKey];
}

- (void)startLoading{
    [self animateToProgress:0.93f];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.delegate = self;
    rotationAnimation.toValue = @(M_PI*2.f);
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    rotationAnimation.duration = 0.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeBoth;
    [self.progressView.layer addAnimation:rotationAnimation forKey:HTCirCularKey];
    
}
- (void)endLoading{
    _progress = 0.f;
    [self.progressView.layer removeAnimationForKey:HTCirCularKey];
}
#pragma mark - Public Accessors
- (void)setCentraView:(UIView *)centraView{
    if (_centraView != centraView) {
        [_centraView removeFromSuperview];
        _centraView = centraView;
        [self addSubview:self.centraView];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.progressView updateProgress:_progress];
}
@end

#pragma mark - HTCirCularProgress
@implementation HTCirCularProgress

+ (Class)layerClass{
    return CAShapeLayer.class;
}

- (CAShapeLayer *)shapeLayer{
    return (CAShapeLayer*)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self updateProgress:0.f];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.shapeLayer.cornerRadius = self.frame.size.width / 2.f;
    self.shapeLayer.path = [self layoutPath].CGPath;
}

- (UIBezierPath *)layoutPath{
    const double TWO_M_PI = 2.0 * M_PI;
    const double startAngle = 0.75 * TWO_M_PI;
    const double endAngle = startAngle + TWO_M_PI;
    
    CGFloat width = self.frame.size.width;
    CGFloat borderWidth = self.shapeLayer.borderWidth;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.f, width/2.f) radius:width/2.f - borderWidth startAngle:startAngle endAngle:endAngle clockwise:YES];
}
- (void)updateProgress:(CGFloat)progress {
    [self updatePath:progress];
}
- (void)updatePath:(CGFloat)progress{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.shapeLayer.strokeEnd = progress;
    [CATransaction commit];
}
@end
