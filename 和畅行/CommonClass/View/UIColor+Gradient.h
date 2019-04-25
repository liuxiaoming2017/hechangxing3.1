//
//  UIColor+Gradient.h
//  和畅行
//
//  Created by Wei Zhao on 2018/12/7.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Gradient)

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;

+ (CAGradientLayer *)setGradualChangingColorHeng:(UIView *)view fromColor:(NSString *)fromHexColorStr  modColor:(NSString *)modColor toColor:(NSString *)toHexColorStr;


@end

NS_ASSUME_NONNULL_END
