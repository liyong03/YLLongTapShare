//
//  YLLongTapShareView.m
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/22/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "YLLongTapShareView.h"
#import "YLShareView.h"

@interface YLLongTapShareView ()

@property (nonatomic, strong, readonly) NSMutableArray *shareItems;

@end

@implementation YLLongTapShareView {
    YLShareView*    _shareView;
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
            
            YLShareView* shareView = [[YLShareView alloc] initWithShareItems:self.shareItems];
            if ([self.delegate respondsToSelector:@selector(colorOfShareView)]) {
                shareView.tintColor = [self.delegate colorOfShareView];
            }
            __weak YLLongTapShareView* weakSelf = self;
            [shareView showShareViewInView:self at:touchPoint withCompletion:^(NSUInteger index, YLShareItem *item) {
                if ([weakSelf.delegate respondsToSelector:@selector(longTapShareView:didSelectShareTo:withIndex:)]) {
                    [weakSelf.delegate longTapShareView:weakSelf didSelectShareTo:item withIndex:index];
                }
            }];
            _shareView = shareView;
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:_shareView];
            [_shareView slideTo:touchPoint];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [_shareView dismissShareView];
    _shareView = nil;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}


@end
