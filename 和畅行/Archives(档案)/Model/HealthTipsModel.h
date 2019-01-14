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

@property (nonatomic,copy)   NSString *typeStr;

@property (nonatomic,copy)   NSString *subjectCategorySn;


///脏腑
@property (nonatomic,copy)   NSString *zz_name_str;
@property (nonatomic,copy)   NSString *icd_name_str;
@property (nonatomic,copy)   NSString *zz_name;
@property (nonatomic,copy)   NSString *physique_id;

@property (nonatomic,copy)   NSString *cust_id;


//心电图
@property (nonatomic,copy)   NSString *path;

@property (nonatomic,copy)   NSString *content;


//季度报告model

//年份
@property (nonatomic,copy)   NSString *year;
//季度
@property (nonatomic,copy)   NSString *quarter;


//血氧
@property (nonatomic,copy)   NSString *oxygenId;
@property (nonatomic,copy)   NSString *density;


//血压
@property (nonatomic,copy)   NSString *highPressure;
@property (nonatomic,copy)   NSString *lowPressure;

// 体温
@property (nonatomic,copy)   NSString *temperature;


//病例

@property (nonatomic,copy)   NSString *medicRecordId;
@property (nonatomic,copy)   NSString *mainSuit;
@property (nonatomic,copy)   NSString *doctorDept;
@property (nonatomic,copy)   NSString *doctorName;


//档案全量
@property (nonatomic,copy)   NSString *name;
@property (nonatomic,copy)   NSString *type;
@property (nonatomic,copy)   NSString *typeName;
@property (nonatomic,copy)   NSString *link;
@property (nonatomic,copy)   NSString *sn;
@property (nonatomic,copy)   NSString *date;
@property (nonatomic,copy)   NSString *time;


@end
