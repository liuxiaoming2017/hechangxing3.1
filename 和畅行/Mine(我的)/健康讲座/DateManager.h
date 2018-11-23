//
//  DateManager.h
//  quyubianshi
//
//  Created by ZhangYunguang on 16/5/10.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateManager : NSObject

+ (NSString *)currentYear;
+ (NSString *)currentMonth;
+ (NSString *)currentDay;
+ (NSString *)getYearFrom:(id)timestamp;
+ (NSString *)getMonthFrom:(id)timestamp;
+ (NSString *)getDayFrom:(id)timestamp;
+ (double)getNowTimestamp;

@end
