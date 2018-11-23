//
//  MessageModel.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/29.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel<NSCoding>

@property (nonatomic,copy) NSString *content;
@property (nonatomic,retain) NSNumber *createDate;
@property (nonatomic,retain) NSNumber *id;
@property (nonatomic,retain) NSNumber *modifyDate;
@property (nonatomic,copy) NSString *sendType;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,assign) BOOL isNewMessage;//是否是新消息

@end
/*
 {
 content = aaa;
 createDate = 1450406158000;
 id = 96;
 modifyDate = 1450406158000;
 sendType = system;     //消息类型：sendType=bespoke客户的预约挂号信息，sendType=video视频预约信息 sendType=lecture讲座信息，
                                   sendType=system系统消息

 title = test;
 type = all;
 }
 */