//
//  YLLongTapShareView.m
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/22/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "YLLongTapShareView.h"
#import "YLShareView.h"
#import <objc/runtime.h>

@interface YLLongTapShareView ()

@property (nonatomic, strong, readonly) NSMutableArray *shareItems;

@end

@implementation YLLongTapShareView {
    YLShareView*    _effectView;
}
@synthesize shareItems = _shareItems;

- (NSMutableArray*)shareItems {
    if (!_shareItems) {
        _shareItems = [NSMutableArray array];
    }
    
    return _shareItems;
}

- (void)addShareItem:(YLShareItem*)item {
    [self.shareItems addObject:item];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:self];
            
            YLShareView* effectView = [[YLShareView alloc] initWithShareItems:self.shareItems];
            __weak YLLongTapShareView* weakSelf = self;
            [effectView showShareViewInView:self at:touchPoint withCompletion:^(NSUInteger index, YLShareItem *item) {
                if ([weakSelf.delegate respondsToSelector:@selector(longTapShareView:didSelectShareTo:withIndex:)]) {
                    [weakSelf.delegate longTapShareView:weakSelf didSelectShareTo:item withIndex:index];
                }
            }];
            _effectView = effectView;
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:_effectView];
            [_effectView slideTo:touchPoint];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [_effectView dismissShareView];
    _effectView = nil;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}


@end

const void* UIButtonShareItemsKey = &UIButtonShareItemsKey;
const void* UIButtonShareViewKey = &UIButtonShareViewKey;
const void* UIButtonShareDelegatesKey = &UIButtonShareDelegatesKey;

@implementation UIButton(LongTapShare)
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


- (id<YLLongTapShareViewDelegate>)delegate {
    id<YLLongTapShareViewDelegate> _delegate = objc_getAssociatedObject(self, &UIButtonShareDelegatesKey);
    return _delegate;
}

- (void)setDelegate:(id<YLLongTapShareViewDelegate>)delegate {
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
            
            YLShareView* effectView = [[YLShareView alloc] initWithShareItems:self.shareItems];
            __weak UIButton* weakSelf = self;
            [effectView showShareViewInView:self at:touchPoint withCompletion:^(NSUInteger index, YLShareItem *item) {
                if ([weakSelf.delegate respondsToSelector:@selector(longTapShareView:didSelectShareTo:withIndex:)]) {
                    [weakSelf.delegate longTapShareView:weakSelf didSelectShareTo:item withIndex:index];
                }
            }];
            self.shareView = effectView;
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
