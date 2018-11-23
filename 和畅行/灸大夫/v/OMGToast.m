//
//  OMGToast.m
//  MoxaAdvisor
//
//  Created by xuzengjun on 15/3/27.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "OMGToast.h"
#import <QuartzCore/QuartzCore.h>

@interface OMGToast (private)

- (id)initWithText:(NSString *)text_;
- (void)setDuration:(CGFloat) duration_;

- (void)dismisToast;
- (void)toastTaped:(UIButton *)sender_;

- (void)showAnimation;
- (void)hideAnimation;

- (void)show;
- (void)showFromTopOffset:(CGFloat) topOffset_;
- (void)showFromBottomOffset:(CGFloat) bottomOffset_;

@end

@implementation OMGToast

//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIDeviceOrientationDidChangeNotification
//                                                  object:[UIDevice currentDevice]];
//    [contentView release],contentView = nil;
//    [text release],text = nil;
//    [super dealloc];
//}


- (id)initWithText:(NSString *)text_{
    if (self = [super init]) {
        
        text = [text_ copy];
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];
//        CGSize textSize = [text sizeWithFont:font
//                           constrainedToSize:CGSizeMake(280, MAXFLOAT)
//                               lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 12, textSize.height + 12)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.borderWidth = 1.0f;
        contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        contentView.backgroundColor = [UIColor colorWithRed:0.2f
                                                      green:0.2f
                                                       blue:0.2f
                                                      alpha:0.75f];
        [contentView addSubview:textLabel];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addTarget:self
                        action:@selector(toastTaped:)
              forControlEvents:UIControlEventTouchDown];
        contentView.alpha = 0.0f;
//        [textLabel release];
        
        duration = DEFAULT_DISPLAY_DURATION;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(deviceOrientationDidChanged:)
//                                                     name:UIDeviceOrientationDidChangeNotification
//                                                   object:[UIDevice currentDevice]];
    }
    return self;
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify_{
//    [self hideAnimation];
}

-(void)dismissToast{
    [contentView removeFromSuperview];
}

-(void)toastTaped:(UIButton *)sender_{
    [self hideAnimation];
}

- (void)setDuration:(CGFloat) duration_{
    duration = duration_;
}

-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = window.center;
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromTopOffset:(CGFloat) top_{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = CGPointMake(window.center.x, top_ + contentView.frame.size.height/2);
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromBottomOffset:(CGFloat) bottom_{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    contentView.center = CGPointMake(window.center.x, window.frame.size.height-(bottom_ + contentView.frame.size.height/2));
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}


+ (void)showWithText:(NSString *)text_{
    [OMGToast showWithText:text_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_
            duration:(CGFloat)duration_{
    OMGToast *toast = [[OMGToast alloc] initWithText:text_];
    [toast setDuration:duration_];
    [toast show];
}

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_{
    [OMGToast showWithText:text_  topOffset:topOffset_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_
            duration:(CGFloat)duration_{
    OMGToast *toast = [[OMGToast alloc] initWithText:text_];
    [toast setDuration:duration_];
    [toast showFromTopOffset:topOffset_];
}

+ (void)showWithText:(NSString *)text_
        bottomOffset:(CGFloat)bottomOffset_{
    [OMGToast showWithText:text_  bottomOffset:bottomOffset_ duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text_
        bottomOffset:(CGFloat)bottomOffset_
            duration:(CGFloat)duration_{
    OMGToast *toast = [[OMGToast alloc] initWithText:text_];
    [toast setDuration:duration_];
    [toast showFromBottomOffset:bottomOffset_];
}

+ (void)shakeMessage:(NSString*)text_ duration:(CGFloat)duration_ attchView:(UIView*)attchView_ {
    OMGToast *toast = [[OMGToast alloc] initWithText:text_];
    [toast setDuration:duration_];
    [toast show];
    [self shakeAnimationForView:attchView_];
}

+ (void)shakeAnimationForView:(UIView *) view
{
    if (view != nil) {
        // 获取到当前的View
        
        CALayer *viewLayer = view.layer;
        
        // 获取当前View的位置
        
        CGPoint position = viewLayer.position;
        
        // 移动的两个终点位置
        
        CGPoint x = CGPointMake(position.x + 10, position.y);
        
        CGPoint y = CGPointMake(position.x - 10, position.y);
        
        // 设置动画
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        
        // 设置运动形式
        
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        
        // 设置开始位置
        
        [animation setFromValue:[NSValue valueWithCGPoint:x]];
        
        // 设置结束位置
        
        [animation setToValue:[NSValue valueWithCGPoint:y]];
        
        // 设置自动反转
        
        [animation setAutoreverses:YES];
        
        // 设置时间
        
        [animation setDuration:.06];
        
        // 设置次数
        
        [animation setRepeatCount:3];
        
        // 添加上动画
        
        [viewLayer addAnimation:animation forKey:nil];
    }
}

@end
