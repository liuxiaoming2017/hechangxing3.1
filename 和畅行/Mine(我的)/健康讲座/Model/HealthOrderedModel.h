//
//  HealthOrderedModel.h
//  Voicediagno
//
//  Created by Mymac on 15/10/30.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BaseModel.h"

@interface HealthOrderedModel : BaseModel

@property (nonatomic,retain) NSNumber *id;
@property (nonatomic,retain) NSNumber *createDate;
@property (nonatomic,retain) NSNumber *modifyDate;
@property (nonatomic,copy  ) NSString *status;
@property (nonatomic,retain) NSNumber *reserveNums;
@property (nonatomic,retain) NSNumber *actualPayment;



//预约挂号时用
@property (nonatomic,copy  ) NSString *patientName;
@property (nonatomic,copy  ) NSString *patientPhone;
@property (nonatomic,copy  ) NSString *patientId;
@property (nonatomic,assign) BOOL     isInsuranceCard;

@property (nonatomic,retain) NSNumber *pauseDate;
@property (nonatomic,copy  ) NSString *pauseTime;
@property (nonatomic,copy  ) NSString *clickHospitalName;//坐诊医院
@property (nonatomic,retain) NSNumber *clickHospitalId;

//体质门诊
@property (nonatomic,copy  ) NSString *startTime;
@property (nonatomic,copy  ) NSString *endTime;

@end
/*
 id": ​279,
 "createDate": ​1446170114000,
 "modifyDate": ​1446170114000,
 "status": "cancelled",
 "reserveNums": ​1,
 "actualPayment": ​0.010000,
 */