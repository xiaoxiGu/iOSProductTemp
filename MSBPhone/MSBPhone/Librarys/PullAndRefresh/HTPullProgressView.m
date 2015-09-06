//
//  HTPullProgressView.m
//  HiTao
//
//  Created by hitao4 on 15/7/22.
//  Copyright (c) 2015年 hitao. All rights reserved.
//

#import "HTPullProgressView.h"
#import "UIColor+HTColors.h"

@interface HTPullProgressView ()
{
    CGFloat _angleInterval;
    NSTimer *timer;
    BOOL isLoading;
}
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic,assign) CGFloat tempProgressValue;
@end

@implementation HTPullProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = MIN(self.bounds.size.height, self.bounds.size.width) * 0.5;
        self.layer.masksToBounds = YES;
        [self setupImage];

    }
    return self;
}
- (void)setupImage{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_icon"]];
    imageView.frame = CGRectMake(0, 0, self.bounds.size.width-5.f, self.bounds.size.height - 5.f);
    imageView.center = self.center;
    [self addSubview:imageView];
}
- (void)drawRect:(CGRect)rect{
    [self setupProgress];
}
- (void)setupProgress{
    CGContextRef progress = UIGraphicsGetCurrentContext();
//    [[UIColor htRedColor] set];
    CGContextSetStrokeColorWithColor(progress,[UIColor htRedColor].CGColor);
    CGFloat xCenter = self.bounds.size.width/2;
    CGFloat yCenter = self.bounds.size.height/2;
    
    CGContextSetLineWidth(progress, 2.5f);
    CGContextSetLineCap(progress, kCGLineCapRound);
    CGFloat to;
    CGFloat from;
    
    if(isLoading){
        to = -M_PI * 0.2 + _angleInterval; //初始值 0.06
        from = _angleInterval;
    }else{
        to =   M_PI*0.75 + _progressValue*M_PI*2;  //初始值 0;
        from = M_PI*0.75;
    }
    CGFloat radius = MIN(self.bounds.size.height, self.bounds.size.width) * 0.5;
    CGContextAddArc(progress, xCenter, yCenter, radius, from, to, 0);
    CGContextStrokePath(progress);
}

- (void)setProgressValue:(CGFloat)progressValue{
    
    _progressValue = progressValue;
    
    if (progressValue > 1.0) {
        _progressValue = 1.0;
    }
    if (progressValue <0) {
        _progressValue = 0;
    }
    [self setNeedsDisplay];
    
}

- (void)changeAngle{
    _angleInterval += M_PI * 0.08;
    if (_angleInterval >= M_PI *2) {
        _angleInterval = 0;
    }
    [self setNeedsDisplay];
}

- (void)startLoading{
    
    isLoading = YES;
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(changeAngle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)endLoading{
    [timer invalidate];
    isLoading = NO;
}

@end
