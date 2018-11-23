//
//  OrderNumModel.h
//  Voicediagno
//
//  Created by Mymac on 15/11/2.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BaseModel.h"

@interface OrderNumModel : BaseModel

@property (nonatomic,retain) NSNumber *id;
//@property (nonatomic,copy) NSString *id;
@property (nonatomic,retain) NSNumber *createDate;
@property (nonatomic,retain) NSNumber *modifyDate;
@property (nonatomic,copy) NSString *reserveSn;

@end
/*
 {
 
 "id": ​344,
 "createDate": ​1446170114000,
 "modifyDate": ​1446170114000,
 "reserveSn": "EA2132CC06CB4253BD88E5495F6C387B"
 
 }
 */