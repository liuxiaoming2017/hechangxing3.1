//
//  PrivateServiceModel.h
//  
//
//  Created by ZhangYunguang on 15/11/26.
//
//

#import "BaseModel.h"

@interface PrivateServiceModel : BaseModel

@property (nonatomic,retain) NSNumber *id;
@property (nonatomic,retain) NSNumber *createDate;
@property (nonatomic,retain) NSNumber *modifyDate;
@property (nonatomic,retain) NSNumber *order;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,retain) NSNumber *serviceNum;

@end
/*
 {
 
 "id": ​6,
 "createDate": ​1443511606000,
 "modifyDate": ​1443511606000,
 "order": null,
 "name": "营养师",
 "serviceNum": ​120
 
 }
 */