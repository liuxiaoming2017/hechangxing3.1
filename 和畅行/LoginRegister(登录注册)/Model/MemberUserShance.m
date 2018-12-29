//
//  MemberUserShance.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MemberUserShance.h"
#import "ChildMemberModel.h"

static MemberUserShance *shareOnce = nil;
static dispatch_once_t onceToken;
static dispatch_once_t onceToken1;

@implementation MemberUserShance

+ (MemberUserShance *)shareOnce
{
    
    dispatch_once(&onceToken,^{
        shareOnce = [[MemberUserShance alloc] init];
    });
    return shareOnce;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    dispatch_once(&onceToken1, ^{
        shareOnce = [super allocWithZone:zone];
    });
    
    return shareOnce;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return shareOnce;
}

-(id)copyWithZone:(NSZone *)zone
{
    return shareOnce;
}




+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"idNum" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

- (void)setMemberModel:(ChildMemberModel *)model
{
    
}

+(void)attemptDealloc{
    
    shareOnce =nil;
    onceToken=0l;
    onceToken1 =0l;
}

@end
