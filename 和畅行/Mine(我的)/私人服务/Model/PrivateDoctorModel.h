//
//  PrivateDoctorModel.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/11/30.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "BaseModel.h"

@interface PrivateDoctorModel : BaseModel

@property (nonatomic,retain) NSNumber *id;
@property (nonatomic,retain) NSNumber *createDate;
@property (nonatomic,retain) NSNumber *modifyDate;
@property (nonatomic,retain) NSNumber *order;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,retain) NSNumber *birth;
@property (nonatomic,copy) NSString *graduated;
@property (nonatomic,copy) NSString *rank;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *skill;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,assign) BOOL isYanHuang;
@property (nonatomic,copy) NSString *advisorCategory;
@property (nonatomic,copy) NSString *serviceLevel;
@property (nonatomic,retain) NSNumber *serviceOrder;
@property (nonatomic,retain) NSNumber *servicedNum;
@property (nonatomic,copy) NSString *phone;

@end
/*
 {
 
 "id": ​29,
 "createDate": ​1448611921000,
 "modifyDate": ​1448611921000,
 "order": null,
 "name": "孙悟空",
 "gender": "male",
 "birth": ​1447084800000,
 "graduated": "菩提老祖大讲堂",
 "rank": null,
 "level": "high",
 "skill": null,
 "image": null,
 "introduction": null,
 "isYanHuang": null,
 "advisorCategory": "营养师",
 "serviceLevel": "三星",
 "serviceOrder": ​3,
 "serviceNum": ​120,
 "servicedNum": ​0,
 "phone": null
 
 }
 */