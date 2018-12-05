//
//  HealthTipsModel.h
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/6.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthTipsModel : NSObject

@property (nonatomic,strong) NSDictionary *subject;
@property (nonatomic,strong) NSDictionary *phoneReport;
@property (nonatomic,strong) NSNumber *createDate;
@property (nonatomic,copy)   NSString *createTime;

@end
