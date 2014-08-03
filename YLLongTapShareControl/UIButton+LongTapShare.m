//
//  UIButton+LongTapShare.m
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/28/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "UIButton+LongTapShare.h"
#import <objc/runtime.h>

const void* UIButtonShareItemsKey = &UIButtonShareItemsKey;
const void* UIButtonShareViewKey = &UIButtonShareViewKey;
const void* UIButtonShareDelegatesKey = &UIButtonShareDelegatesKey;

@implementation UIButton (LongTapShare)
@dynamic shareItems;
@dynamic shareView;
@dynamic delegate;

- (NSMutableArray *)shareItems {
    NSMutableArray *_shareItems = objc_getAssociatedObject(self, &UIButtonShareItemsKey);
    return _shareItems;
}

- (void)setShareItems:(NSMutableArray *)shareItems {
    objc_setAssociatedObject(self, &UIButtonShareItemsKey, shareItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (YLShareView *)shareView {
    YLShareView *_shareView = objc_getAssociatedObject(self, &UIButtonShareViewKey);
    return _shareView;
}

- (void)setShareView:(YLShareView *)shareView {
    objc_setAssociatedObject(self, &UIButtonShareViewKey, shareView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (id<YLLongTapShareDelegate>)delegate {
    id<YLLongTapShareDelegate> _delegate = objc_getAssociatedObject(self, &UIButtonShareDelegatesKey);
    return _delegate;
}

- (void)setDelegate:(id<YLLongTapShareDelegate>)delegate {
    objc_setAssociatedObject(self, &UIButtonShareDelegatesKey, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)addShareItem:(YLShareItem*)item {
    if (!self.shareItems) {
        self.shareItems = [NSMutableArray array];
        [self addTarget:self action:@selector(longTapBegin:withEvent:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(longTapMove:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [self addTarget:self action:@selector(longTapMove:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        [self addTarget:self action:@selector(longTapEnd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(longTapEnd:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    }
    [self.shareItems addObject:item];
}

- (void)longTapBegin:(UIButton*)button withEvent:(UIEvent*)event {
    NSSet* touches = event.allTouches;
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:self];
            
            YLShareView* shareView = [[YLShareView alloc] initWithShareItems:self.shareItems];
            if ([self.delegate respondsToSelector:@selector(colorOfShareView)]) {
                shareView.tintColor = [self.delegate colorOfShareView];
            }
            __weak UIButton* weakSelf = self;
            [shareView showShareViewInView:self at:touchPoint withCompletion:^(NSUInteger index, YLShareItem *item) {
                if ([weakSelf.delegate respondsToSelector:@selector(longTapShareView:didSelectShareTo:withIndex:)]) {
                    [weakSelf.delegate longTapShareView:weakSelf didSelectShareTo:item withIndex:index];
                }
            }];
            self.shareView = shareView;
        }
    }
}

- (void)longTapMove:(UIButton*)button withEvent:(UIEvent*)event {
    NSSet* touches = event.allTouches;
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:self.shareView];
            [self.shareView slideTo:touchPoint];
        }
    }
}

- (void)longTapEnd:(UIButton*)button withEvent:(UIEvent*)event {
    [self.shareView dismissShareView];
    self.shareView = nil;
}


@end