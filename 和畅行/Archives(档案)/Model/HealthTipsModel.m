//
//  HealthTipsModel.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/6.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "HealthTipsModel.h"

@implementation HealthTipsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"])
        self.oxygenId = value;
}

@end
