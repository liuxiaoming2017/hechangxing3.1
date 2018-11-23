//
//  MessageModel.m
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/29.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.createDate forKey:@"createDate"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.modifyDate forKey:@"modifyDate"];
    [aCoder encodeObject:self.sendType forKey:@"sendType"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:@(self.isNewMessage) forKey:@"isNewMessage"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.createDate = [aDecoder decodeObjectForKey:@"createDate"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.modifyDate = [aDecoder decodeObjectForKey:@"modifyDate"];
        self.sendType = [aDecoder decodeObjectForKey:@"sendType"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.isNewMessage = [[aDecoder decodeObjectForKey:@"isNewMessage"] boolValue];
    }
    return self;
}

@end
