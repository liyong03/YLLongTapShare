//
//  YLShareButtonView.h
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/18/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLShareButtonView : UIView

@property (nonatomic, strong, readonly) UIImage* shareIcon;
@property (nonatomic, copy, readonly) NSString* shareTitle;
@property (nonatomic, strong) UIColor *tintColor;

- (id)initWithIcon:(UIImage*)icon andTitle:(NSString*)title;

- (void)showAnimationWithDelay:(CGFloat)delay;
- (void)animateToDoneWithHandler:(void(^)())doneBlock;
- (void)selectAnimation;
- (void)resetAnimation;

@end
