//
//  UIFont+YHFont.m
//  和畅行
//
//  Created by Wei Zhao on 2019/8/21.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "UIFont+YHFont.h"
#import <objc/runtime.h>
@implementation UIFont (YHFont)

+ (void)load {
    // 获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    // 获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    [UserShareOnce shareOnce].padSizeFloat  = 1.0;
    if(ISPaid) {
        [UserShareOnce shareOnce].padSizeFloat  = 1.8;
    }
    [UserShareOnce shareOnce].fontSize = [UserShareOnce shareOnce].multipleFontSize*[UserShareOnce shareOnce].padSizeFloat;
    newFont = [UIFont adjustFont:fontSize * [UserShareOnce shareOnce].fontSize ];
    
    if ([UserShareOnce shareOnce].canChageSize == NO){
        if(ISPaid) {
            newFont = [UIFont adjustFont:fontSize*1.35];
        }else{
            newFont = [UIFont adjustFont:fontSize*1.1];
        }
        
    }
     return newFont;
}


@end
