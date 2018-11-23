//
//  NSString+Util.h
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/11.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Util)

//- (BOOL)isEmpty;
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (NSString*)encodeString;
- (NSString *)decodeString;

@end
