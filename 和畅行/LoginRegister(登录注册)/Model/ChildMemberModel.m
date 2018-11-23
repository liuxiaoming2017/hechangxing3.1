//
//  ChildMemberModel.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ChildMemberModel.h"

@implementation ChildMemberModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.createDate forKey:@"createDate"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.idNum forKey:@"id"];
    [aCoder encodeObject:self.idcard forKey:@"idcard"];
    [aCoder encodeObject:@(self.isMedicare) forKey:@"isMedicare"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.modifyDate forKey:@"modifyDate"];
    [aCoder encodeObject:self.weight forKey:@"weight"];
//    [aCoder encodeObject:self.parentName forKey:@"parentName"];
//    [aCoder encodeObject:self.parentIcon forKey:@"parentIcon"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.createDate = [aDecoder decodeObjectForKey:@"createDate"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.idNum = [aDecoder decodeObjectForKey:@"id"];
        self.idcard = [aDecoder decodeObjectForKey:@"idcard"];
        self.isMedicare = [[aDecoder decodeObjectForKey:@"isMedicare"] boolValue];
        self.modifyDate = [aDecoder decodeObjectForKey:@"modifyDate"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
//        self.parentName = [aDecoder decodeObjectForKey:@"parentName"];
//        self.parentIcon = [aDecoder decodeObjectForKey:@"parentIcon"];
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"idNum" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end
