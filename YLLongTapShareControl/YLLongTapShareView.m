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
    NSLog(@"touched %lu!", (unsigned long)touches.count);
    
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:self];
            
            YLShareView* effectView = [[YLShareView alloc] initWithShareItems:self.shareItems];
            [effectView showShareViewInView:self at:touchPoint withCompletion:^(NSUInteger index, YLShareItem *item) {
                [effectView removeFromSuperview];
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
    NSLog(@"End!");
    [_effectView dismissShareView];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"cancelled!");
}


@end
