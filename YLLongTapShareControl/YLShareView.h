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

@interface YLShareItem : NSObject

@property (nonatomic, strong) UIImage* icon;
@property (nonatomic, copy) NSString* title;

+ (YLShareItem*)itemWithIcon:(UIImage*)icon andTitle:(NSString*)title;

@end

@interface YLShareView : UIView

@property (nonatomic, assign, readonly) YLShareViewState state;

- (id)initWithShareItems:(NSArray*)shareItems;

- (void)showWithCompletion:(void(^)())handler;
- (void)dismissWithCompletion:(void(^)())handler;

/*
 *  point should be in the coordinate of current view
 */
- (void)slideTo:(CGPoint)point;

@end
