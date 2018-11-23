//
//  UIView+FirstResponder.m
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/2.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "UIView+FirstResponder.h"

@implementation UIView (FirstResponder)
- (id)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView findFirstResponder];
        if (responder) return responder;
    }
    return nil;
    //    for (UIView *subView in self.view.subviews) {
    //        if ([subView isFirstResponder]) {
    //            return subView;
    //        }
    //    }
    //    return nil;
}

- (id)firstResponderSuperView {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView findFirstResponder];
        if (responder) return subView;
    }
    return nil;
}
@end
