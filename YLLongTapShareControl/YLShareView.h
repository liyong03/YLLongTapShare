//
//  YLShareView.h
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YLShareViewState) {
    YLShareViewUnopen = 0,
    YLShareViewOpened,
};

@interface YLShareView : UIView

@property (nonatomic, assign, readonly) YLShareViewState state;

- (id)initWithShareIcons:(NSArray*)icons andTitles:(NSArray*)titles;

- (void)showWithCompletion:(void(^)())handler;
- (void)dismissWithCompletion:(void(^)())handler;

/*
 *  point should be in the coordinate of current view
 */
- (void)slideTo:(CGPoint)point;

@end
