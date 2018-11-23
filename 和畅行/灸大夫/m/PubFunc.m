//
//  PubFunc.m
//  MoxaAdvisor
//
//  Created by wangdong on 15/3/22.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "PubFunc.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#include <sys/sysctl.h>
#include <mach/mach.h>

#include <sys/param.h>
#include <sys/mount.h>




//extern NSString *CTSettingCopyMyPhoneNumber();
@implementation PubFunc

+(BOOL)isEmpty:(NSString *)str{
    if([str isEqual:[NSNull null]] || str == nil || str.length == 0 || [str isEqualToString:@"(null)"]){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)getCurrentDateInterval{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

+(void)ViewClearChildView:(UIView *) pv{
    NSArray *vArry = [pv subviews];
    for (UIView *v in vArry) {
        [v removeFromSuperview];
    }
}

+(BOOL)isAlert{
    if ([[UIApplication sharedApplication].keyWindow isMemberOfClass:[UIWindow class]])
    {
        ////There is no alertview present
        return  NO;
    }
    return YES;
}

+ (NSString *)string16FromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}

@end
