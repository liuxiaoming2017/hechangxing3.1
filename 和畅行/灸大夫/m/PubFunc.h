//
//  PubFunc.h
//  MoxaAdvisor
//
//  Created by wangdong on 15/3/22.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#define RECIPEL_HEAD @"<jdf:recipel>"
#define RECIPEL_TAIL @"</jdf:recipel>"

typedef enum {
    NetWorkType_None = 0,
    NetWorkType_WIFI,
    NetWorkType_2G,
    NetWorkType_3G,
    NetWorkType_4G,
} NetWorkType;

@interface PubFunc : NSObject

+ (BOOL)isEmpty:(NSString *)str;
+ (NSString *)getCurrentDateInterval;
+(void)ViewClearChildView:(UIView *) pv;

+ (NSString *)string16FromHexString:(NSString *)hexString ;

+(BOOL)isAlert;

@end
