//
//  SelectedAdvisorModel.h
//  
//
//  Created by ZhangYunguang on 15/11/26.
//
//

#import "BaseModel.h"

@interface SelectedAdvisorModel : BaseModel

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
@property (nonatomic,retain) NSNumber *serviceNum;
@property (nonatomic,retain) NSNumber *servicedNum;
@property (nonatomic,copy) NSString *phone;

@end
/*
 {
 
 "id": ​27,
 "createDate": ​1445406968000,
 "modifyDate": ​1448348946000,
 "order": null,
 "name": "lgq",
 "gender": "male",
 "birth": ​-227606400000,
 "graduated": "牛顿大学",
 "rank": "教授",
 "level": "high",
 "skill": "亚健康",
 "image": null,
 "introduction": null,
 "isYanHuang": true,
 "advisorCategory": "私人医生",
 "serviceLevel": "三星",
 "serviceOrder": ​3,
 "serviceNum": ​6,
 "servicedNum": ​2,
 "phone": null
 
 }
 */