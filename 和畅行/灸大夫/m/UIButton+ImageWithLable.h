//
//  UIButton+ImageWithLable.h
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/14.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
- (void) modifyImageSize:(CGSize)size;
- (void) modifyImageSize:(CGSize)size
              normalSate:(UIImage*)normalSateImg
                highlightState:(UIImage*)highlightStateImg;

- (void) modifyImageWithSelectSize:(CGSize)size;

- (void)bolsterImageSize:(CGSize)size;
- (void)bolsterImageSize:(CGSize)size
              normalSate:(UIImage*)normalSateImg
                highlightState:(UIImage*)highlightStateImg;

- (void) modifyImageSelectedSize:(CGSize)size;
- (void) modifyImageEnlargeSize:(CGSize)size;

- (void)verticalImageAndTitle:(CGFloat)spacing;
@end
