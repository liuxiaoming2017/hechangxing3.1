//
//  HealthTipsModel.h
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/6.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthTipsModel : NSObject

///经脉
@property (nonatomic,strong) NSDictionary *subject;
@property (nonatomic,strong) NSDictionary *phoneReport;
@property (nonatomic,strong) NSNumber *createDate;
@property (nonatomic,copy)   NSString *createTime;


///脏腑
@property (nonatomic,copy)   NSString *zz_name_str;
@property (nonatomic,copy)   NSString *icd_name_str;

@end
