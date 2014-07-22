//
//  TapEffectView.m
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "TapEffectView.h"
#import "Evaluate.h"
#import "ShareButtonView.h"
#import "OMVector.h"

@interface TapEffectView()

@property (nonatomic, assign, readwrite) TapEffectState state;
@property (nonatomic, copy) void(^completionHandler)();

@end

@implementation TapEffectView {
    NSMutableArray*     _shareBtns;
    ShareButtonView*    _selectedView;
    CGFloat             _avgAng;
    NSTimer*            _selectTimer;
    
    BOOL            _isDone;
    
    CAShapeLayer*   _bgLayer;
    CALayer*        _layer;
    CAShapeLayer*   _btnLayer;
}

- (id)initWithShareIcons:(NSArray*)icons andTitles:(NSArray*)titles {
    self = [self initWithFrame:CGRectMake(0, 0, 60, 60)];
    if (self) {
        _shareBtns = [NSMutableArray array];
        _state = TapEffectUnopen;
        _selectedView = nil;
        _isDone = NO;
        [self createAllShareBtnsWithIcons:icons andTitles:titles];
    }
    
    return self;
}

- (void)createAllShareBtnsWithIcons:(NSArray*)icons andTitles:(NSArray*)titles {
    int n = icons.count;
    const CGFloat distance = 100.f;
    const CGFloat shareSize = 80;
    CGFloat angle = M_PI/(n*2);
    _avgAng = angle;
    for (int i=0; i<n; i++) {
        CGFloat fan = angle*(i*2+1);
        CGPoint p;
        p.x = roundf(-distance * cosf(fan) + self.bounds.size.width/2);
        p.y = roundf(-distance * sinf(fan) + self.bounds.size.height/2);
        
        CGRect frame = CGRectMake(p.x-shareSize/2, p.y-shareSize/2, shareSize, shareSize);
        ShareButtonView* view = [[ShareButtonView alloc] initWithIcon:icons[i] andTitle:titles[i]];
        view.frame = frame;
        view.hidden = YES;
        [self addSubview:view];
        [_shareBtns addObject:view];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
        _bgLayer.strokeColor = [UIColor whiteColor].CGColor;
        _bgLayer.lineWidth = 2;
        [self.layer addSublayer:_bgLayer];
        _bgLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _bgLayer.opacity = 0.0;
        
        _btnLayer = [CAShapeLayer layer];
        _btnLayer.fillColor = [UIColor whiteColor].CGColor;
        _btnLayer.strokeColor = [UIColor whiteColor].CGColor;
        _btnLayer.lineWidth = 2;
        [self.layer addSublayer:_btnLayer];
        _btnLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _btnLayer.opacity = 1.0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    _bgLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2].CGPath;
    _bgLayer.bounds = rect;
    _bgLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    rect = CGRectInset(rect, 10, 10);
    _btnLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2].CGPath;
    _btnLayer.bounds = rect;
    _btnLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)showCircleEffectWithCompletion:(void(^)())handler {
    CGFloat edge = MIN(self.bounds.size.width, self.bounds.size.height);
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, edge, edge) cornerRadius:edge/2].CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = 2;
    layer.lineCap= kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:layer];
    layer.bounds = self.bounds;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    layer.opacity = 1.0;
    _layer = layer;
    
    
    static float scaleTime = 1.0;
    static float disappTime = 0.1;
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //    animation.delegate = self;
    animation.duration = scaleTime;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
    
    
    CABasicAnimation* disappear = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    disappear.duration = disappTime;
    disappear.beginTime = scaleTime;
    disappear.fromValue = @(1);
    disappear.toValue = @(0.01);
    disappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    disappear.fillMode = kCAFillModeForwards;
    disappear.removedOnCompletion = NO;
    
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[ animation, disappear ];
    group.duration = (scaleTime + disappTime);
    //group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [layer addAnimation:group forKey:@"tapEffect"];
    
    
    CAKeyframeAnimation* disappear2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    disappear2.fromValue = @(0.01);
//    disappear2.toValue = @(1);
    disappear2.values = [YLSPringAnimation calculateKeyFramesFromeStartValue:0.01 endValue:1.0 interstitialSteps:20];
    disappear2.fillMode = kCAFillModeForwards;
    disappear2.removedOnCompletion = NO;
    disappear2.duration = 0.8;
    disappear2.beginTime = scaleTime + disappTime;
    
    CABasicAnimation* showOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showOpacity.duration = 0.8;
    showOpacity.beginTime = scaleTime + disappTime;
    showOpacity.fromValue = @(1);
    showOpacity.toValue = @(1);
    showOpacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    showOpacity.fillMode = kCAFillModeForwards;
    showOpacity.removedOnCompletion = NO;
    
    CAAnimationGroup *group2 = [[CAAnimationGroup alloc] init];
    group2.animations = @[ disappear2, showOpacity ];
    group2.duration = (scaleTime + disappTime + 0.8);
    group2.fillMode = kCAFillModeForwards;
    group2.removedOnCompletion = NO;
    [_bgLayer addAnimation:group2 forKey:@"bgshowup"];
    
    for (int i=0; i<_shareBtns.count; i++) {
        ShareButtonView* view = (ShareButtonView*)_shareBtns[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((scaleTime + disappTime + 0.05*i) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            view.hidden = NO;
            [view showAnimation];
            self.state = TapEffectOpened;
        });
    }
    
    self.completionHandler = handler;
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)dismissEnlargeEffect:(void(^)())handler {
    [self pauseLayer:_layer];
    [self pauseLayer:_btnLayer];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        handler();
    }];
}

- (float)angleForCenterPoint:(CGPoint)center andPoint1:(CGPoint)p1 andPoint2:(CGPoint)p2 {
    if (CGPointEqualToPoint(center, p1) || CGPointEqualToPoint(center, p2))
        return 0.0f;
    CGPoint v1 = CGPointMake(p1.x-center.x, p1.y-center.y);
    CGPoint v2 = CGPointMake(p2.x-center.x, p2.y-center.y);
    CGFloat dot = v1.x*v2.x + v1.y*v2.y;
    CGFloat arccos = dot/(sqrt((v1.x*v1.x+v1.y*v1.y)*(v2.x*v2.x+v2.y*v2.y)));
    CGFloat result = acosf(arccos);
    return result;
}

- (void)moveTo:(CGPoint)point {
    CGFloat radius = 20;
    CGPoint center = {self.bounds.size.width/2, self.bounds.size.height/2};
    CGVector v = CGVectorMakeWithPoints(center, point);
    CGFloat dis = CGVectorLength(v);
    if (dis >= radius) {
        dis = radius;
        
        ShareButtonView* selectedView;
        NSInteger selected = -1;
        CGFloat minAng = 2*M_PI;
        for (int i=0; i<_shareBtns.count; i++) {
            ShareButtonView* view = (ShareButtonView*)_shareBtns[i];
            CGPoint vP = view.center;
            CGFloat ang = [self angleForCenterPoint:center andPoint1:point andPoint2:vP];
            if (minAng > ang) {
                selectedView = view;
                selected = i;
                minAng = ang;
            }
        }
        if (minAng <= _avgAng && !_isDone) {
            if (_selectedView != selectedView) {
                if (_selectedView) {
                    [_selectedView resetAnimation];
                }
                _selectedView = selectedView;
                [_selectedView selectAnimation];
                [_selectTimer invalidate];
                _selectTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(doneSelected) userInfo:nil repeats:NO];
            }
        } else {
            [_selectedView resetAnimation];
            _selectedView = nil;
            [_selectTimer invalidate];
            _selectTimer = nil;
        }
    } else {
        [_selectedView resetAnimation];
        _selectedView = nil;
        [_selectTimer invalidate];
        _selectTimer = nil;
    }
    CGVector vNorm = CGVectorNormalize(v);
    CGVector newV = CGVectorMultiply(vNorm, dis);
    CGPoint btnPos = CGPointFromStartAndVector(center, newV);
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    _btnLayer.position = btnPos;
    [CATransaction commit];
}

- (void)doneSelected {
    _isDone = YES;
    [_selectedView animateToDoneWithHandler:^{
        if (self.completionHandler) {
            self.completionHandler();
        }
        self.completionHandler = nil;
    }];
}

@end
