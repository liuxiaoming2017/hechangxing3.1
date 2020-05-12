//
//  UISegmentedControl+Style_ios13.m
//  和畅行
//
//  Created by 刘晓明 on 2020/5/12.
//  Copyright © 2020 刘晓明. All rights reserved.
//

#import "UISegmentedControl+Style_ios13.h"

@implementation UISegmentedControl (Style_ios13)

- (void)sameWithIos12Style
{
    if(@available(iOS 13,*)){
        //UIColor *tintColor = [self tintColor];
       // UIImage *tintColorImage = [self imageWithColor:tintColor];
        // Must set the background image for normal to something (even clear) else the rest won't work
        [self setBackgroundImage:[self imageWithColor:self.backgroundColor ? self.backgroundColor : [UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
       // [self setBackgroundImage:[self imageWithColor:[tintColor colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
       // [self setBackgroundImage:[self imageWithColor:[tintColor colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
       // [self setBackgroundImage:tintColorImage forState:UIControlStateSelected|UIControlStateSelected barMetrics:UIBarMetricsDefault];
        //[self setTitleTextAttributes:@{NSForegroundColorAttributeName: tintColor, NSFontAttributeName: [UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
       
        [self setDividerImage:[self imageWithColor:[UIColor clearColor]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [tintColor CGColor];
    }
}

- (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
