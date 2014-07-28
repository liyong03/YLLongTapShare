//
//  UIButton+LongTapShare.h
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/28/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLShareView.h"

@interface UIButton (LongTapShare)

@property (nonatomic, strong) NSMutableArray* shareItems;
@property (nonatomic, strong) YLShareView* shareView;
@property (nonatomic, weak) id<YLLongTapShareDelegate> delegate;

- (void)addShareItem:(YLShareItem*)item;

@end
