//
//  UIView+FirstResponder.h
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/2.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FirstResponder)

- (id)findFirstResponder;
- (id)firstResponderSuperView;

@end
