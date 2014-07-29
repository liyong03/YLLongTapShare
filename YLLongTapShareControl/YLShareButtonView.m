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
    self = [super initWithFrame:CGRectMake(0, 0, 80, 80)];
    if (self) {
        // Initialization code
        _shareIcon = icon;
        _shareTitle = title;
        _isSelected = NO;
        _isDone = NO;
        [self _setup];
        self.layer.opacity = 0;
    }
    return self;
}

- (void)_setup {
    _tintColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    _iconView = [[UIImageView alloc] initWithImage:_shareIcon];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.backgroundColor = [UIColor clearColor];
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
    _titleLabel.textColor = _tintColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.layer.opacity = 0;
    [_titleLabel sizeToFit];
    _doneLabel = [[UILabel alloc] init];
    _doneLabel.textAlignment = NSTextAlignmentCenter;
    _doneLabel.text = @"done!";
    _doneLabel.hidden = YES;
    _doneLabel.font = [UIFont systemFontOfSize:14];
    _doneLabel.textColor = _tintColor;
    _doneLabel.backgroundColor = [UIColor clearColor];
    [_doneLabel sizeToFit];
    
    [self addSubview:_iconView];
    [self addSubview:_doneMarkLabel];
    [self addSubview:_titleLabel];
    [self addSubview:_doneLabel];
    
    _iconLayer = [CAShapeLayer layer];
    _iconLayer.fillColor = [_tintColor colorWithAlphaComponent:0.0].CGColor;
    _iconLayer.strokeColor = _tintColor.CGColor;
    _iconLayer.lineWidth = 2;
    _iconLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _iconLayer.opacity = 1.0;
    [self.layer insertSublayer:_iconLayer above:_iconView.layer];

}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    _iconLayer.fillColor = [_tintColor colorWithAlphaComponent:0.0].CGColor;
    _iconLayer.strokeColor = _tintColor.CGColor;
    
    _doneLabel.textColor = _tintColor;
    _titleLabel.textColor = _tintColor;
}

- (void)layoutSubviews {
    CGRect frame = self.bounds;
    _titleLabel.frame = CGRectIntegral(CGRectMake(0.5*(frame.size.width - _titleLabel.frame.size.width), frame.size.height, _titleLabel.frame.size.width, _titleLabel.frame.size.height));
    _doneLabel.frame = CGRectIntegral(CGRectMake(0.5*(frame.size.width - _doneLabel.frame.size.width), frame.size.height, _doneLabel.frame.size.width, _doneLabel.frame.size.height));
    
    //frame.size.height -= labelHeight;
    CGFloat wid = MIN(frame.size.width, frame.size.height);
    CGRect square = CGRectMake((frame.size.width-wid)/2,
                               (frame.size.height-wid)/2,
                               wid, wid);
    square = CGRectInset(square, 4, 4);
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
    
    CAAnimation* animation = [YLShareAnimationHelper fillColorAnimationFrom:[self.tintColor colorWithAlphaComponent:0.5]
                                                                         to:self.tintColor
                                                               withDuration:0.5 andDelay:0
                                                          andTimingFunction:kCAMediaTimingFunctionEaseOut];
    
    [_iconLayer addAnimation:animation forKey:@"fillToWhite"];
    
    _doneMarkLabel.hidden = NO;
    _doneMarkLabel.layer.opacity = 0;
    CAAnimation* doneappear = [YLShareAnimationHelper opacityAnimationFrom:0 to:1
                                                              withDuration:0.5 andDelay:0
                                                         andTimingFunction:kCAMediaTimingFunctionEaseIn];
    CAAnimation* moveUp3 = [YLShareAnimationHelper scaleAnimationFrom:1.2 to:1
                                                         withDuration:0.5 andDelay:0
                                                    andTimingFunction:kCAMediaTimingFunctionEaseIn andIsSpring:NO];
    
    CAAnimationGroup* doneMarkAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[ doneappear, moveUp3 ]
                                                                                   andDuration:0.5];
    
    [_doneMarkLabel.layer addAnimation:doneMarkAnimation forKey:@"showDoneMark"];
    
    
    CAAnimation* disappear = [YLShareAnimationHelper opacityAnimationFrom:1 to:0
                                                             withDuration:0.2 andDelay:0.3
                                                        andTimingFunction:kCAMediaTimingFunctionEaseIn];
    
    CAAnimation* moveUp = [YLShareAnimationHelper positionYAnimationFrom:_titleLabel.layer.position.y
                                                                      to:_titleLabel.layer.position.y-_titleLabel.frame.size.height
                                                            withDuration:0.2 andDelay:0.3
                                                       andTimingFunction:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup* titleAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[ disappear, moveUp ]
                                                                                andDuration:0.5];
    
    [_titleLabel.layer addAnimation:titleAnimation forKey:@"titleMoveOut"];
    
    _doneLabel.hidden = NO;
    _doneLabel.layer.opacity = 0;
    CAAnimation* appear = [YLShareAnimationHelper opacityAnimationFrom:0 to:1
                                                          withDuration:0.2 andDelay:0.3
                                                     andTimingFunction:kCAMediaTimingFunctionEaseIn];
    
    CAAnimation* moveUp2 = [YLShareAnimationHelper positionYAnimationFrom:_doneLabel.layer.position.y+_doneLabel.frame.size.height
                                                                       to:_doneLabel.layer.position.y
                                                             withDuration:0.2 andDelay:0.3
                                                        andTimingFunction:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup* doneAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[ appear, moveUp2 ]
                                                                               andDuration:1.0];
    doneAnimation.completion = ^(BOOL finished) {
        doneBlock();
    };
    [_doneLabel.layer addAnimation:doneAnimation forKey:@"doneMoveIn"];
}

- (void)showAnimationWithDelay:(CGFloat)delay {
    
    CAAnimation* animation = [YLShareAnimationHelper scaleAnimationFrom:0.01 to:1.0
                                                           withDuration:0.8 andDelay:delay
                                                      andTimingFunction:nil andIsSpring:YES];
    CAAnimation* opacity = [YLShareAnimationHelper opacityAnimationFrom:0 to:1
                                                           withDuration:0.001 andDelay:delay
                                                      andTimingFunction:kCAMediaTimingFunctionLinear];
    CAAnimation* group = [YLShareAnimationHelper groupAnimationWithAnimations:@[animation, opacity] andDuration:0.8+delay];
    [self.layer addAnimation:group forKey:@"showAnimation"];
}


- (void)selectAnimation {
    if (_isSelected || _isDone)
        return;
    
    _isSelected = YES;
    CAAnimation* enlarge = [YLShareAnimationHelper scaleAnimationFrom:1 to:1.1
                                                         withDuration:0.25 andDelay:0
                                                    andTimingFunction:kCAMediaTimingFunctionEaseOut andIsSpring:NO];
    
    CAAnimation* moveUp = [YLShareAnimationHelper positionYAnimationFrom:self.layer.position.y
                                                                      to:self.layer.position.y-10
                                                            withDuration:0.25 andDelay:0
                                                       andTimingFunction:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup* selectAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[enlarge, moveUp]
                                                                                 andDuration:0.25];
    
    [self.layer addAnimation:selectAnimation forKey:@"selectAnimation"];
    
    
    CAAnimation* blend = [YLShareAnimationHelper fillColorAnimationFrom:[self.tintColor colorWithAlphaComponent:0]
                                                                     to:[self.tintColor colorWithAlphaComponent:0.5]
                                                           withDuration:0.25 andDelay:0
                                                      andTimingFunction:kCAMediaTimingFunctionEaseOut];
    [_iconLayer addAnimation:blend forKey:@"blend"];
    
    CAAnimation* titleOpacity = [YLShareAnimationHelper opacityAnimationFrom:0 to:1
                                                                withDuration:0.25 andDelay:0
                                                           andTimingFunction:kCAMediaTimingFunctionEaseOut];
    [_titleLabel.layer addAnimation:titleOpacity forKey:@"showTitle"];
}

- (void)resetAnimation {
    if (!_isSelected || _isDone)
        return;
    
    _isSelected = NO;
    
    CAAnimation* shrink = [YLShareAnimationHelper scaleAnimationFrom:1.1 to:1.0
                                                        withDuration:0.25 andDelay:0
                                                   andTimingFunction:kCAMediaTimingFunctionEaseOut andIsSpring:NO];
    
    CAAnimation* moveDown = [YLShareAnimationHelper positionYAnimationFrom:self.layer.position.y-10
                                                                        to:self.layer.position.y
                                                              withDuration:0.25 andDelay:0
                                                         andTimingFunction:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup* unSelectAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[shrink, moveDown]
                                                                                   andDuration:0.25];
    
    [self.layer addAnimation:unSelectAnimation forKey:@"unSelectAnimation"];
    
    CAAnimation* blend = [YLShareAnimationHelper fillColorAnimationFrom:[self.tintColor colorWithAlphaComponent:0.5]
                                                                     to:[self.tintColor colorWithAlphaComponent:0]
                                                           withDuration:0.25 andDelay:0
                                                      andTimingFunction:kCAMediaTimingFunctionEaseOut];
    [_iconLayer addAnimation:blend forKey:@"blend"];
    
    
    CAAnimation* titleOpacity = [YLShareAnimationHelper opacityAnimationFrom:1 to:0
                                                                withDuration:0.25 andDelay:0
                                                           andTimingFunction:kCAMediaTimingFunctionEaseOut];
    [_titleLabel.layer addAnimation:titleOpacity forKey:@"hideTitle"];
}

@end
