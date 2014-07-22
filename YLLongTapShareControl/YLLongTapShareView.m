//
//  YLLongTapShareView.m
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/22/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "YLLongTapShareView.h"
#import "TapEffectView.h"

@implementation YLLongTapShareView {
    TapEffectView*  _effectView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touched %lu!", (unsigned long)touches.count);
    
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:self];
            
            UIImage* icon = [UIImage imageNamed:@"pinterest"];
            NSString* title = @"Pinterest";
            
            UIImage* instaIcon = [UIImage imageNamed:@"instagram"];
            UIImage* facebook = [UIImage imageNamed:@"facebook"];
            
            TapEffectView* effectView = [[TapEffectView alloc] initWithShareIcons:@[facebook,instaIcon,icon] andTitles:@[@"Facebook", @"instagram", title]];
            effectView.center = touchPoint;
            [self addSubview:effectView];
            [effectView showCircleEffectWithCompletion:^{
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
            [_effectView moveTo:touchPoint];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"End!");
    [_effectView dismissEnlargeEffect:^{
        [_effectView removeFromSuperview];
    }];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"cancelled!");
}


@end
