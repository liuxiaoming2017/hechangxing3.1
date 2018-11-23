//
//  ConfigUtil.m
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/10.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "ConfigUtil.h"

@implementation ConfigUtil


+ (NSString *)getMoxaLastTime{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:MOXA_LASTTIME];
}
//
+ (void)setMoxaLastTime:(NSString *)time{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:time forKey:MOXA_LASTTIME];
    [userDefaults synchronize];
}

+ (NSString *)getMoxaLastTemp{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:MOXA_LASTTEMP];
}
//
+ (void)setMoxaLastTemp:(NSString *)temp{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:temp forKey:MOXA_LASTTEMP];
    [userDefaults synchronize];
}

+ (void)setMoxaModule:(BOOL)b {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:b forKey:MOXA_MODULE_USE];
    [userDefaults synchronize];
}

+ (NSString*)getLatestRecipel {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:LATESTRECIPEL];
}

+ (void)setLatestRecipel:(NSString*)s {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:s forKey:LATESTRECIPEL];
    [userDefaults synchronize];
}
//
+ (int)getRemindRegCount {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults stringForKey:REMINDREGCOUNT] intValue];
}

+ (void)setRemindRegCount:(int)count {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *s = [NSString stringWithFormat:@"%d", count];
    [userDefaults setValue:s forKey:REMINDREGCOUNT];
    [userDefaults synchronize];
}

+ (NSString*)getLastConnectMesh{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:MESHNAME];
}

+ (void)setConnectMesh:(NSString*)meshname{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:meshname forKey:MESHNAME];
    [userDefaults synchronize];
}

@end
