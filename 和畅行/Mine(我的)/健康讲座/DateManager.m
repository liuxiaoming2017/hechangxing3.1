//
//  DateManager.m
//  quyubianshi
//
//  Created by ZhangYunguang on 16/5/10.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "DateManager.h"

@implementation DateManager

+(NSString *)currentYear{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    return [formatter stringFromDate:date];
}
+(NSString *)currentMonth{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    return [formatter stringFromDate:date];
}
+(NSString *)currentDay{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd";
    return [formatter stringFromDate:date];
}
+(NSString *)getYearFrom:(id)timestamp{
    double time = [timestamp doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0f]];
}
+(NSString *)getMonthFrom:(id)timestamp{
    double time = [timestamp doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0f]];
}
+(NSString *)getDayFrom:(id)timestamp{
    double time = [timestamp doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd";
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0f]];
}
+(double)getNowTimestamp{
    return [[NSDate date] timeIntervalSince1970]*1000;
}

@end
