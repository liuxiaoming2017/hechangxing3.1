//
//  HealthLectureModel.h
//  Voicediagno
//
//  Created by Mymac on 15/10/26.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BaseModel.h"

@interface HealthLectureModel : BaseModel

@property (nonatomic,retain) NSNumber *id;
@property (nonatomic,retain) NSNumber *createDate;
@property (nonatomic,retain) NSNumber *modifyDate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *talker;
@property (nonatomic,copy) NSString *supportPhone;
@property (nonatomic,assign) BOOL isPublication;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,retain) NSNumber* listeners;
@property (nonatomic,retain) NSNumber* reserveLimit;
@property (nonatomic,retain) NSNumber* laveListeners;
@property (nonatomic,retain) NSNumber* price;
@property (nonatomic,retain) NSNumber* beginDate;
@property (nonatomic,retain) NSNumber* endDate;
@property (nonatomic,retain) NSNumber* lectureDate;
@property (nonatomic,retain) NSNumber* productId;
@property (nonatomic,copy) NSString* path;


//视频问诊用


@end


/*
     {
 
         "id": 11,
         "createDate": 1440757004000,
         "modifyDate": 1445313902000,
         "title": "乳腺中心健康讲堂",
         "talker": "孙宇建；康煜冬；徐咏梅",
         "supportPhone": "52176593   5217659",
         "isPublication": true,
         "area": "首都医科大学附属北京中医医院体检中心",
         "picture": "http://app.ky3h.com:8001/healthlm/upload/image/2015/1015/4fe671fb-8a10-47dc-95d0-18b4cc39e98c.png",
         "listeners": 100,
         "reserveLimit": 0,
         "laveListeners": 89,
         "price": 0.01,
         "beginDate": 1443542400000,
         "endDate": 1448812800000,
         "lectureDate": 1448776800000,
         "productId": 1060,
         "path": "http://app.ky3h.com:8001/healthlm/lecture/view/11.jhtml"
     
     }
*/