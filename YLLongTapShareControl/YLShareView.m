//
//  YLShareView.m
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "YLShareView.h"
#import "Evaluate.h"
#import "YLShareButtonView.h"
#import "OMVector.h"
#import "YLShareAnimationHelper.h"

@implementation YLShareItem

+ (YLShareItem*)itemWithIcon:(UIImage*)icon andTitle:(NSString*)title {
    YLShareItem* item = [[YLShareItem alloc] init];
    item.icon = icon;
    item.title = title;
    
    return item;
}

@end

@interface YLShareView()

@property (nonatomic, assign, readwrite) YLShareViewState state;
@property (nonatomic, copy) SelectedHandler completionHandler;

@end

@implementation YLShareView {
    NSArray*            _shareItems;
    NSMutableArray*     _shareBtns;
    YLShareButtonView*  _selectedView;
    CGFloat             _avgAng;
    NSTimer*            _selectTimer;
    
    BOOL                _isDone;
    BOOL                _isDismissed;
    
    CAShapeLayer*       _bgLayer;
    CAShapeLayer*       _layer;
    CAShapeLayer*       _btnLayer;
}

- (id)initWithShareItems:(NSArray*)shareItems {
    self = [self initWithFrame:CGRectMake(0, 0, 60, 60)];
    if (self) {
        _shareBtns = [NSMutableArray array];
        _state = YLShareViewUnopen;
        _selectedView = nil;
        _isDone = NO;
        _isDismissed = NO;
        _shareItems = shareItems;
        [self createAllShareBtnsWithShareItems:shareItems];
    }
    
    return self;
}

- (void)createAllShareBtnsWithShareItems:(NSArray*)shareItems {
    int n = (int)shareItems.count;
    const CGFloat distance = 100.f;
    const CGFloat shareSize = 60;
    CGFloat angle = M_PI/(3*2); // using the angle of 3 items is best
    _avgAng = angle;
    CGFloat startAngle = M_PI_2 - (n-1)*angle;
    for (int i=0; i<n; i++) {
        YLShareItem* item = (YLShareItem*)shareItems[i];
        CGFloat fan = startAngle + angle*i*2;
        CGPoint p;
        p.x = roundf(-distance * cosf(fan) + self.bounds.size.width/2);
        p.y = roundf(-distance * sinf(fan) + self.bounds.size.height/2);
        
        CGRect frame = CGRectMake(p.x-shareSize/2, p.y-shareSize/2, shareSize, shareSize);
        YLShareButtonView* view = [[YLShareButtonView alloc] initWithIcon:item.icon andTitle:item.title];
        view.tintColor = _tintColor;
        view.frame = frame;
        [self addSubview:view];
        [_shareBtns addObject:view];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tintColor = [UIColor whiteColor];
        
        _layer = [CAShapeLayer layer];
        _layer.fillColor = [UIColor clearColor].CGColor;
        _layer.strokeColor = self.tintColor.CGColor;
        _layer.lineWidth = 2;
        _layer.lineCap= kCALineCapRound;
        _layer.lineJoin = kCALineJoinRound;
        _layer.opacity = 1.0;
        [self.layer addSublayer:_layer];
        
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.fillColor = [self.tintColor colorWithAlphaComponent:0.8].CGColor;
        _bgLayer.strokeColor = self.tintColor.CGColor;
        _bgLayer.lineWidth = 2;
        [self.layer addSublayer:_bgLayer];
        _bgLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _bgLayer.opacity = 0.0;
        
        _btnLayer = [CAShapeLayer layer];
        _btnLayer.fillColor = self.tintColor.CGColor;
        _btnLayer.strokeColor = self.tintColor.CGColor;
        _btnLayer.lineWidth = 2;
        [self.layer addSublayer:_btnLayer];
        _btnLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _btnLayer.opacity = 1.0;
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    _layer.strokeColor = self.tintColor.CGColor;
    _bgLayer.fillColor = [self.tintColor colorWithAlphaComponent:0.8].CGColor;
    _bgLayer.strokeColor = self.tintColor.CGColor;
    _btnLayer.fillColor = self.tintColor.CGColor;
    _btnLayer.strokeColor = self.tintColor.CGColor;
    
    for (YLShareButtonView* view in _shareBtns) {
        view.tintColor = _tintColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    CGFloat edge = MIN(self.bounds.size.width, self.bounds.size.height);
    _layer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, edge, edge) cornerRadius:edge/2].CGPath;
    _layer.bounds = self.bounds;
    _layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    _layer.bounds = self.bounds;
    _layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    _bgLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2].CGPath;
    _bgLayer.bounds = rect;
    _bgLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    rect = CGRectInset(rect, 10, 10);
    _btnLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2].CGPath;
    _btnLayer.bounds = rect;
    _btnLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)showShareViewInView:(UIView*)view at:(CGPoint)point withCompletion:(SelectedHandler)handler {
    
    self.center = point;
    [view addSubview:self];
    
    static float scaleTime = 1.0;
    static float disappTime = 0.1;
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = scaleTime;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    CAAnimation* disappear = [YLShareAnimationHelper scaleAnimationFrom:1.0 to:0.01
                                                           withDuration:disappTime andDelay:scaleTime
                                                      andTimingFunction:kCAMediaTimingFunctionEaseOut andIsSpring:NO];
    
    
    CAAnimationGroup *group = [YLShareAnimationHelper groupAnimationWithAnimations:@[ animation, disappear ]
                                                                       andDuration:(scaleTime + disappTime)];
    [_layer addAnimation:group forKey:@"circleProgress"];
    
    
    CAAnimation* disappear2 = [YLShareAnimationHelper scaleAnimationFrom:0.01 to:1.0
                                                                    withDuration:0.8 andDelay:(scaleTime+disappTime)
                                                               andTimingFunction:nil andIsSpring:YES];
    
    CAAnimation* showOpacity = [YLShareAnimationHelper opacityAnimationFrom:1 to:1
                                                               withDuration:0.8 andDelay:(scaleTime+disappTime)
                                                          andTimingFunction:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *group2 = [YLShareAnimationHelper groupAnimationWithAnimations:@[ disappear2, showOpacity ]
                                                                        andDuration:(scaleTime + disappTime + 0.8)];
    [_bgLayer addAnimation:group2 forKey:@"showSlideBackground"];
    
    for (int i=0; i<_shareBtns.count; i++) {
        YLShareButtonView* view = (YLShareButtonView*)_shareBtns[i];
        [view showAnimationWithDelay:(scaleTime + disappTime + 0.1*i)];
        self.state = YLShareViewOpened;
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

- (void)dismissShareView {
    _isDismissed = YES;
    [self pauseLayer:_layer];
    [self pauseLayer:_btnLayer];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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

- (void)slideTo:(CGPoint)point {
    CGFloat radius = 20;
    CGPoint center = {self.bounds.size.width/2, self.bounds.size.height/2};
    CGVector v = CGVectorMakeWithPoints(center, point);
    if (CGPointEqualToPoint(center, point))
        return;
    CGFloat dis = CGVectorLength(v);
    if (dis >= radius) {
        dis = radius;
        
        YLShareButtonView* selectedView;
        NSInteger selected = -1;
        CGFloat minAng = 2*M_PI;
        for (int i=0; i<_shareBtns.count; i++) {
            YLShareButtonView* view = (YLShareButtonView*)_shareBtns[i];
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
    
    if (!_isDismissed) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        _btnLayer.position = btnPos;
        [CATransaction commit];
    }
}

- (void)doneSelected {
    _isDone = YES;
    NSUInteger i = [_shareBtns indexOfObject:_selectedView];
    __weak typeof(self) weakSelf = self;
    __weak typeof(_shareItems) weakShareItems = _shareItems;
    [_selectedView animateToDoneWithHandler:^{
        if (weakSelf.completionHandler) {
            weakSelf.completionHandler(i, weakShareItems[i]);
            weakSelf.completionHandler = nil;
        }
        [weakSelf dismissShareView];
    }];
    [_selectTimer invalidate];
    _selectTimer = nil;
}

@end
