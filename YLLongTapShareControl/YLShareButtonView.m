//
//  YLShareButtonView.m
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/18/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "YLShareButtonView.h"
#import "Evaluate.h"
#import "CAAnimation+Blocks.h"
#import "YLShareAnimationHelper.h"

@interface YLShareButtonView()

@property (nonatomic, strong, readwrite) UIImage* shareIcon;
@property (nonatomic, copy, readwrite) NSString* shareTitle;
@property (nonatomic, copy) void(^doneHandler)();

@end

@implementation YLShareButtonView {
    UIImageView*    _iconView;
    CAShapeLayer*   _iconLayer;
    UILabel*        _titleLabel;
    UILabel*        _doneLabel;
    UILabel*        _doneMarkLabel;
    
    BOOL            _isSelected;
    BOOL            _isDone;
}

- (id)initWithIcon:(UIImage*)icon andTitle:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (self) {
        // Initialization code
        _shareIcon = icon;
        _shareTitle = title;
        _isSelected = NO;
        _isDone = NO;
        [self _setup];
    }
    return self;
}

- (void)_setup {
    
    _iconView = [[UIImageView alloc] initWithImage:_shareIcon];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _doneMarkLabel = [[UILabel alloc] init];
    _doneMarkLabel.text = @"✔︎";
    _doneMarkLabel.textColor = [UIColor grayColor];
    _doneMarkLabel.backgroundColor = [UIColor clearColor];
    _doneMarkLabel.font = [UIFont systemFontOfSize:40];
    _doneMarkLabel.textAlignment = NSTextAlignmentCenter;
    _doneMarkLabel.hidden = YES;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _shareTitle;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel sizeToFit];
    _doneLabel = [[UILabel alloc] init];
    _doneLabel.textAlignment = NSTextAlignmentCenter;
    _doneLabel.text = @"done!";
    _doneLabel.hidden = YES;
    _doneLabel.font = [UIFont systemFontOfSize:14];
    _doneLabel.textColor = [UIColor whiteColor];
    _doneLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_iconView];
    [self addSubview:_doneMarkLabel];
    [self addSubview:_titleLabel];
    [self addSubview:_doneLabel];
    
    _iconLayer = [CAShapeLayer layer];
    _iconLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor;
    _iconLayer.strokeColor = [UIColor whiteColor].CGColor;
    _iconLayer.lineWidth = 2;
    _iconLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _iconLayer.opacity = 1.0;
    [self.layer insertSublayer:_iconLayer above:_iconView.layer];

}

- (void)layoutSubviews {
    CGRect frame = self.bounds;
    CGFloat labelHeight = _titleLabel.frame.size.height;
    _titleLabel.frame = CGRectMake(0, frame.size.height - labelHeight, frame.size.width, labelHeight);
    _doneLabel.frame = _titleLabel.frame;
    
    frame.size.height -= labelHeight;
    CGFloat wid = MIN(frame.size.width, frame.size.height);
    CGRect square = CGRectMake((frame.size.width-wid)/2,
                               (frame.size.height-wid)/2,
                               wid, wid);
    square = CGRectInset(square, 10, 10);
    _iconView.frame = square;
    _doneMarkLabel.frame = _iconView.frame;
    
    _iconLayer.bounds = _iconView.bounds;
    _iconLayer.position = _iconView.center;
    _iconLayer.path = [UIBezierPath bezierPathWithRoundedRect:_iconLayer.bounds cornerRadius:_iconLayer.bounds.size.width/2].CGPath;
}

- (void)animateToDoneWithHandler:(void(^)())doneBlock; {
    if (_isDone)
        return;
    _isDone = YES;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.duration = 0.5;
    animation.fromValue = (id)[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    animation.toValue = (id)[UIColor whiteColor].CGColor;
    //animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [_iconLayer addAnimation:animation forKey:@"done"];
    
    _doneMarkLabel.hidden = NO;
    _doneMarkLabel.layer.opacity = 0;
    CABasicAnimation* doneappear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    doneappear.duration = 0.5;
    doneappear.beginTime = 0.0;
    doneappear.fromValue = @(0);
    doneappear.toValue = @(1);
    doneappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    doneappear.fillMode = kCAFillModeForwards;
    doneappear.removedOnCompletion = NO;
    
    CABasicAnimation* moveUp3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    moveUp3.duration = 0.5;
    moveUp3.beginTime = 0.0;
    moveUp3.fromValue = @(1.2);
    moveUp3.toValue = @(1);
    moveUp3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    moveUp3.fillMode = kCAFillModeForwards;
    moveUp3.removedOnCompletion = NO;
    
    CAAnimationGroup* doneMarkAnimation = [[CAAnimationGroup alloc] init];
    doneMarkAnimation.animations = @[ doneappear, moveUp3 ];
    doneMarkAnimation.duration = 0.5;
    doneMarkAnimation.delegate = self;
    doneMarkAnimation.fillMode = kCAFillModeForwards;
    doneMarkAnimation.removedOnCompletion = NO;
    [_doneMarkLabel.layer addAnimation:doneMarkAnimation forKey:@"doneAnimation"];
    
    
    CABasicAnimation* disappear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    disappear.duration = 0.2;
    disappear.beginTime = 0.3;
    disappear.fromValue = @(1);
    disappear.toValue = @(0);
    disappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    disappear.fillMode = kCAFillModeForwards;
    disappear.removedOnCompletion = NO;
    
    CABasicAnimation* moveUp = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveUp.duration = 0.2;
    moveUp.beginTime = 0.3;
    moveUp.fromValue = @(_titleLabel.layer.position.y);
    moveUp.toValue = @(_titleLabel.layer.position.y-20);
    moveUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    moveUp.fillMode = kCAFillModeForwards;
    moveUp.removedOnCompletion = NO;
    
    CAAnimationGroup* titleAnimation = [[CAAnimationGroup alloc] init];
    titleAnimation.animations = @[ disappear, moveUp ];
    titleAnimation.duration = 0.5;
    titleAnimation.delegate = self;
    titleAnimation.fillMode = kCAFillModeForwards;
    titleAnimation.removedOnCompletion = NO;
    
    [_titleLabel.layer addAnimation:titleAnimation forKey:@"moveup"];
    
    _doneLabel.hidden = NO;
    _doneLabel.layer.opacity = 0;
    CABasicAnimation* appear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    appear.duration = 0.2;
    appear.beginTime = 0.3;
    appear.fromValue = @(0);
    appear.toValue = @(1);
    appear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    appear.fillMode = kCAFillModeForwards;
    appear.removedOnCompletion = NO;
    
    CABasicAnimation* moveUp2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveUp2.duration = 0.2;
    moveUp2.beginTime = 0.3;
    moveUp2.fromValue = @(_doneLabel.layer.position.y+20);
    moveUp2.toValue = @(_doneLabel.layer.position.y);
    moveUp2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    moveUp2.fillMode = kCAFillModeForwards;
    moveUp2.removedOnCompletion = NO;
    
    CAAnimationGroup* doneAnimation = [[CAAnimationGroup alloc] init];
    doneAnimation.animations = @[ appear, moveUp2 ];
    doneAnimation.duration = 1.0;
    doneAnimation.delegate = self;
    doneAnimation.fillMode = kCAFillModeForwards;
    doneAnimation.removedOnCompletion = NO;
    doneAnimation.completion = ^(BOOL finished) {
        doneBlock();
    };
    [_doneLabel.layer addAnimation:doneAnimation forKey:@"doneAnimation"];
}

- (void)showAnimation {
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.delegate = self;
    animation.duration = 0.8;
    animation.values = [YLSPringAnimation calculateKeyFramesFromeStartValue:0.01 endValue:1.0 interstitialSteps:20];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [self.layer addAnimation:animation forKey:@"showAnimation"];
}


- (void)selectAnimation {
    if (_isSelected || _isDone)
        return;
    
    _isSelected = YES;
    CABasicAnimation* enlarge = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    enlarge.duration = 0.25;
    enlarge.fromValue = @(1);
    enlarge.toValue = @(1.1);
    enlarge.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    enlarge.fillMode = kCAFillModeForwards;
    enlarge.removedOnCompletion = NO;
    
    CABasicAnimation* moveUp = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveUp.duration = 0.25;
    moveUp.fromValue = @(self.layer.position.y);
    moveUp.toValue = @(self.layer.position.y-10);
    moveUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    moveUp.fillMode = kCAFillModeForwards;
    moveUp.removedOnCompletion = NO;
    
    CAAnimationGroup* selectAnimation = [[CAAnimationGroup alloc] init];
    selectAnimation.animations = @[enlarge, moveUp];
    selectAnimation.duration = 0.25;
    selectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    selectAnimation.fillMode = kCAFillModeForwards;
    selectAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:selectAnimation forKey:@"selectAnimation"];
    
    
    CABasicAnimation* blend = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    blend.duration = 0.25;
    blend.fromValue = (id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor;
    blend.toValue = (id)[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    blend.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    blend.fillMode = kCAFillModeForwards;
    blend.removedOnCompletion = NO;
    [_iconLayer addAnimation:blend forKey:@"blend"];
}

- (void)resetAnimation {
    if (!_isSelected || _isDone)
        return;
    
    _isSelected = NO;
    
    CABasicAnimation* shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shrink.duration = 0.25;
    shrink.fromValue = @(1.1);
    shrink.toValue = @(1);
    shrink.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    shrink.fillMode = kCAFillModeForwards;
    shrink.removedOnCompletion = NO;
    
    CABasicAnimation* moveDown = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveDown.duration = 0.25;
    moveDown.fromValue = @(self.layer.position.y-10);
    moveDown.toValue = @(self.layer.position.y);
    moveDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    moveDown.fillMode = kCAFillModeForwards;
    moveDown.removedOnCompletion = NO;
    
    CAAnimationGroup* unSelectAnimation = [[CAAnimationGroup alloc] init];
    unSelectAnimation.animations = @[shrink, moveDown];
    unSelectAnimation.duration = 0.25;
    unSelectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    unSelectAnimation.fillMode = kCAFillModeForwards;
    unSelectAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:unSelectAnimation forKey:@"unSelectAnimation"];
    
    CABasicAnimation* blend = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    blend.duration = 0.25;
    blend.fromValue = (id)[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    blend.toValue = (id)[[UIColor whiteColor] colorWithAlphaComponent:0].CGColor;
    blend.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    blend.fillMode = kCAFillModeForwards;
    blend.removedOnCompletion = NO;
    [_iconLayer addAnimation:blend forKey:@"blend"];
}

@end
