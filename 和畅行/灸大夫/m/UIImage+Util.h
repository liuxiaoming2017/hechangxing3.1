//
//  UIImage+Util.h
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/17.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height;
+ (UIImage *)newImageNotCached:(NSString *)filename;
+ (UIImage *)newImageByColor:(UIColor*)color size:(CGSize)size;
- (UIImage *)fixOrientation;

- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height
                     scale:(CGFloat)scale;

@end
