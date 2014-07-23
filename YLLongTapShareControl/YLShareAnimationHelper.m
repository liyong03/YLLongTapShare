//
//  YLShareAnimationHelper.m
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/23/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "YLShareAnimationHelper.h"
#import "Evaluate.h"

@implementation YLShareAnimationHelper

+ (CAAnimation*)scaleAnimationFrom:(CGFloat)beginScale to:(CGFloat)finalScale withDuration:(CGFloat)duration andDelay:(CGFloat)delay andTimingFunction:(NSString*)timingFunc andIsSpring:(BOOL)isSprint {
    
    if (isSprint) {
        CAKeyframeAnimation* keyScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        keyScaleAnimation.duration = duration;
        keyScaleAnimation.beginTime = delay;
        keyScaleAnimation.values = [YLSPringAnimation calculateKeyFramesFromeStartValue:beginScale endValue:finalScale interstitialSteps:20];
        keyScaleAnimation.fillMode = kCAFillModeForwards;
        keyScaleAnimation.removedOnCompletion = NO;
        return keyScaleAnimation;
    } else {
        CABasicAnimation* basicScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basicScaleAnimation.duration = duration;
        basicScaleAnimation.beginTime = delay;
        basicScaleAnimation.fromValue = @(beginScale);
        basicScaleAnimation.toValue = @(finalScale);
        basicScaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunc];
        basicScaleAnimation.fillMode = kCAFillModeForwards;
        basicScaleAnimation.removedOnCompletion = NO;
        return basicScaleAnimation;
    }
}

+ (CAAnimation*)opacityAnimationFrom:(CGFloat)beginOpacity to:(CGFloat)finalOpacity withDuration:(CGFloat)duration andDelay:(CGFloat)delay andTimingFunction:(NSString*)timingFunc {
    
    CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration;
    opacityAnimation.beginTime = delay;
    opacityAnimation.fromValue = @(beginOpacity);
    opacityAnimation.toValue = @(finalOpacity);
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunc];
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    
    return opacityAnimation;
}

+ (CAAnimationGroup*)groupAnimationWithAnimations:(NSArray*)animations andDuration:(CGFloat)duration {
    CAAnimationGroup *groupAnimation = [[CAAnimationGroup alloc] init];
    groupAnimation.animations = animations;
    groupAnimation.duration = duration;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.removedOnCompletion = NO;
    
    return groupAnimation;
}

@end
