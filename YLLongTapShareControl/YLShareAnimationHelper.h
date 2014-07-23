//
//  YLShareAnimationHelper.h
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/23/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLShareAnimationHelper : NSObject

/*
 * Scale animation with spring or not
 */
+ (CAAnimation*)scaleAnimationFrom:(CGFloat)beginScale to:(CGFloat)finalScale withDuration:(CGFloat)duration andDelay:(CGFloat)delay andTimingFunction:(NSString*)timingFunc andIsSpring:(BOOL)isSprint;


/*
 * Opacity animation
 */
+ (CAAnimation*)opacityAnimationFrom:(CGFloat)beginOpacity to:(CGFloat)finalOpacity withDuration:(CGFloat)duration andDelay:(CGFloat)delay andTimingFunction:(NSString*)timingFunc;


/*
 * Y position animation
 */
+ (CAAnimation*)positionYAnimationFrom:(CGFloat)beginY to:(CGFloat)finalY withDuration:(CGFloat)duration andDelay:(CGFloat)delay andTimingFunction:(NSString*)timingFunc;


/*
 * Fillcolor animation
 */
+ (CAAnimation*)fillColorAnimationFrom:(UIColor*)beginColor to:(UIColor*)finalColor withDuration:(CGFloat)duration andDelay:(CGFloat)delay andTimingFunction:(NSString*)timingFunc;

/*
 * Group animation
 */
+ (CAAnimationGroup*)groupAnimationWithAnimations:(NSArray*)animations andDuration:(CGFloat)duration;

@end
